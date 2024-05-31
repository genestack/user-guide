#!/usr/bin/python

import argparse
import base64
import csv
import json
import requests
import time


MULTI_VALUE_SEPARATOR = '|'

EXAMPLE_TEXT = '''example:

 python %(prog)s.py --srv https://odm-demos.genestack.com/ --study study_metadata.tsv --samples samples_metadata.tsv --token <token>

 python %(prog)s.py --srv https://odm-demos.genestack.com/ --study study_metadata.tsv --samples samples_metadata.tsv --expression expression.json --token <token>

 python %(prog)s.py --srv https://odm-demos.genestack.com/ --study study_metadata.tsv --samples samples_metadata.tsv --template GSF000065 --token <token>
 '''

DEFAULT_GCT_100_LINK = 'https://bio-test-data.s3.amazonaws.com/public/dummy/dummy100.gct'
DEFAULT_GCT_1000_LINK = 'https://bio-test-data.s3.amazonaws.com/public/dummy/dummy1000.gct'
DEFAULT_GCT_10000_LINK = 'https://bio-test-data.s3.amazonaws.com/public/dummy/dummy.gct'
DEFAULT_GCT_METADATA_LINK = 'https://bio-test-data.s3.amazonaws.com/public/dummy/dummy.gct.tsv'

def get_rest_endpoint(host):
    return host + '/frontend/rs/genestack/'


def get_app_endpoint(host):
    return host + '/frontend/endpoint/application/invoke/genestack/'


def get_request_headers(token):
    return {'Genestack-API-Token': token,
                   'Accept': 'application/json',
                   'Content-Type': 'application/json'}


def encode_samples_group(sample_group_accession):
    sample_group_id = 'sampleGroup:{}'.format(sample_group_accession)
    return base64.b64encode(sample_group_id.encode('ascii')).decode('ascii')


def decode_sample_group(encoded_accession):
    line = base64.b64decode(encoded_accession.encode('ascii')).decode('ascii')
    # sampleGroup:GSF279960
    return line[line.index(':')+1:]


def update_study(study_accession, study_metadata, host, token):
    url = get_rest_endpoint(host) + 'studyCurator/default-released/studies/' + study_accession
    r = requests.patch(url=url, headers=get_request_headers(token), data=json.dumps(study_metadata))
    # print(r)


def create_expression_gct(gct_link, gct_metadata_link, host, token):
    url = get_rest_endpoint(host) + 'expressionCurator/default-released/expression/gct'
    args = {'link': gct_link, 'metadataLink': gct_metadata_link}
    r = json.loads(requests.post(url=url, headers=get_request_headers(token), data=json.dumps(args)).text)
    runs = r['runs']
    experiment_accession = r['experiment']
    return experiment_accession, runs


def link_expression_group_to_samples(expr_accession, samples_parent, host, token):
    url = get_rest_endpoint(host) + 'integrationCurator/default-released/integration/link/expression/group/'+ \
          str(expr_accession) + '/to/sample/group/' + samples_parent
    raw_result = (requests.post(url=url, headers=get_request_headers(token)))
    if raw_result.status_code != 200:
        print(raw_result.status_code)
        print(raw_result.text)


def read_study_metadata(study_filename):
    with open(study_filename) as f:
        reader = csv.reader(f, delimiter='\t')
        headers = next(reader)
        row = next(reader)
        result = dict()
        for key, value in zip(headers, row):
            values = value.split(MULTI_VALUE_SEPARATOR)
            result[key] = values
    return result


def create_study(study_filename, template_accession, number_of_samples, host, token):
    study_metadata = read_study_metadata(study_filename)
    study_name = study_metadata.get('Study Title', ['Unknown study'])[0]
    number_of_initial_samples = number_of_samples

    url_authenticate = get_app_endpoint(host) + 'signin/authenticateByApiToken'
    url_new_study = get_app_endpoint(host) + 'study-metainfo-editor/createStudy'

    s = requests.Session()
    session = s.post(url_authenticate, json=[token])
    res = json.loads(s.post(url=url_new_study, json=[study_name, template_accession, number_of_initial_samples]).text)
    if 'result' not in res:
        print(res)
        raise Exception('study has not been created')
    study_accession = res['result']
    update_study(study_accession, study_metadata, host, token)
    return study_accession


def replace_samples(study_accession, samples_parent, data, host, token):
    url_authenticate = get_app_endpoint(host) + 'signin/authenticateByApiToken'
    url_replace_samples = get_app_endpoint(host) + 'study-metainfo-editor/replaceSamples'
    s = requests.Session()
    session = s.post(url_authenticate, json=[token])
    res = json.loads(s.post(url=url_replace_samples, data=json.dumps([samples_parent, data])).text)
    if 'result' not in res:
        print(res)
        raise Exception('There is a problem while invoking replaceSamples')


def read_samples_metadata(samples_filename):
    new_samples = []
    with open(samples_filename) as f:
        reader = csv.reader(f, delimiter='\t')
        headers = next(reader)
        for row in reader:
            new_sample = []
            for key, value in zip(headers, row):
                values = value.split(MULTI_VALUE_SEPARATOR)
                new_sample.append({"attributeName": key, "values": values})
            new_samples.append(new_sample)
    return new_samples


def get_samples_parent(study_accession, host, token):
    url_authenticate = get_app_endpoint(host) + 'signin/authenticateByApiToken'
    url_get_study_container_descriptor = get_app_endpoint(host) + 'study-metainfo-editor/getStudyContainerDescriptor'

    s = requests.Session()
    session = s.post(url_authenticate, json=[token])
    res = json.loads(s.post(url=url_get_study_container_descriptor, data=json.dumps([study_accession])).text)
    if 'result' not in res:
        print(res)
        raise Exception('There is a problem while invoking replaceSamples')
    check_samples = res['result']['metadataDescriptors']
    return [item['id'] for item in check_samples if item[u'typeId'] == 'sampleGroup'][0]


def sample_record_to_dict(sample):
    result = dict()
    for record in sample:
        result[record['attributeName']] = record['values']
    return result


def check_sample_source_ids(samples):
    count = 0
    for sample in samples:
        sample_dict = sample_record_to_dict(sample)
        # print(sample_dict)
        if 'Sample Source ID' not in sample_dict:
            raise Exception('Sample Source ID is absent in samples metadata')
        if sample_dict['Sample Source ID'] != 'Sample' + str(count):
            return False
        count += 1
    return True


def correct_samples(samples):
    count = 0
    result = list()
    for sample in samples:
        sample_dict = sample_record_to_dict(sample)
        # print(sample_dict)
        sample_dict['SampleSourceID'] = sample_dict['Sample Source ID']
        sample_dict['Sample Source ID'] = ['Sample' + str(count)]
        count += 1
        new_sample = []
        for key, values in sample_dict.items():
            new_sample.append({"attributeName": key, "values": values})
        result.append(new_sample)
    return result


def create_studies_and_samples(study_filename, samples_filename, template_accession, host, token):
    encoded_samples_parent = None
    if samples_filename is None:
        study_accession = create_study(study_filename, template_accession, 0, host, token)
    else:
        new_samples = read_samples_metadata(samples_filename)
        if not check_sample_source_ids(new_samples):
            print('Warning: Current Sample Source ID values will be stored in SampleSourceID column')
            new_samples = correct_samples(new_samples)
        study_accession = create_study(study_filename, template_accession, 1, host, token)
        time.sleep(3)
        encoded_samples_parent = get_samples_parent(study_accession, host, token)
        replace_samples(study_accession, encoded_samples_parent, new_samples, host, token)
    return study_accession, encoded_samples_parent, len(new_samples)


def update_expression_metadata(metadata, id, host, token):
    url = get_rest_endpoint(host) + 'expressionCurator/default-released/expression/' + str(id)
    r = requests.patch(url=url, headers=get_request_headers(token), data=json.dumps(metadata))
    if r.status_code != 200:
        print(r.status_code)
        print(r.text)


def create_one_expression_object(expression_metadata, samples_parent, host, token, gct_link, verbose):
    # Call the REST API with default values for creating and linking
    experiment_accession, runs = create_expression_gct(gct_link, DEFAULT_GCT_METADATA_LINK, host, token)
    if verbose:
        print('Expression group {} has been created'.format(experiment_accession))
    # Link to the samples group
    link_expression_group_to_samples(experiment_accession, samples_parent, host, token)
    if verbose:
        print('Linking {} to the samples group {}'.format(experiment_accession, samples_parent))
    # Update the metadata
    update_expression_metadata(expression_metadata, runs[0]['id'], host, token)

def create_expressions(expression_filename, encoded_samples_parent, host, token, gct_link, verbose):
    samples_parent = decode_sample_group(encoded_samples_parent)
    with open(expression_filename) as f:
        expressions = json.load(f)
    for expression in expressions:
        create_one_expression_object(expression, samples_parent, host, token, gct_link, verbose)


def select_template(host, token, template):
    url_authenticate = get_app_endpoint(host) + 'signin/authenticateByApiToken'
    url_get_templates = get_app_endpoint(host) + 'study-metainfotemplateeditor/listTemplates'
    s = requests.Session()
    session = s.post(url_authenticate, json=[token])
    res = json.loads(s.post(url=url_get_templates).text)['result']
    for item in res:
        if template is None and item['isDefault']:
            return item['accession']
        else:
            if template == item['accession']:
                return template
    raise Exception('Unknown template accession: {}'.format(template))

def main():
    parser = argparse.ArgumentParser(prog='upload_local_study_to_dom',
                                     description='Upload study and samples metadata to ODM',
                                     epilog=EXAMPLE_TEXT,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--srv', type=str, help='url of the server', required=True)
    parser.add_argument('--study', type=str, help='Path to the study TSV-file', required=True)
    parser.add_argument('--samples', type=str, help='Path to the samples TSV-file', required=False)
    parser.add_argument('--template', type=str, help='template accession (or default template will be selected)', required=False)
    parser.add_argument('--expression', type=str, help='Path to the expression metadata JSON-file', required=False)
    parser.add_argument('--token', type=str, help='token', required=True)
    parser.add_argument('--verbose', action="store_true")
    args = parser.parse_args()
    host = args.srv[:-1] if args.srv.endswith('/') else args.srv
    token = args.token
    template_accession = select_template(host, token, args.template)
    study_accession, encoded_samples_parent, number_of_samples =create_studies_and_samples(args.study, args.samples, template_accession, host, token)
    if number_of_samples <= 100:
        gct_link = DEFAULT_GCT_100_LINK
    elif number_of_samples <= 1000:
        gct_link = DEFAULT_GCT_1000_LINK
    else:
        gct_link = DEFAULT_GCT_10000_LINK
    if args.expression is not None:
        create_expressions(args.expression, encoded_samples_parent, host, token, gct_link, args.verbose)
    print(study_accession)


if __name__ == "__main__":
    main()
