#!/usr/bin/python

import argparse
import csv
import json
import requests
import time


MULTI_VALUE_SEPARATOR = '|'

EXAMPLE_TEXT = '''example:

 python %(prog)s.py --srv https://qa.magnum.genestack.com/ --study study_metadata.tsv --samples samples_metadata.tsv --token <token>

 python %(prog)s.py --srv https://qa.magnum.genestack.com/ --study study_metadata.tsv --samples samples_metadata.tsv --template GSF000065 --token <token>
 '''

def get_rest_endpoint(host):
    return host + '/frontend/rs/genestack/'


def get_app_endpoint(host):
    return host + '/frontend/endpoint/application/invoke/genestack/'


def get_request_headers(token):
    return {'Genestack-API-Token': token,
                   'Accept': 'application/json',
                   'Content-Type': 'application/json'}


def update_study(study_accession, study_metadata, host, token):
    url = get_rest_endpoint(host) + 'studyCurator/default-released/studies/' + study_accession
    r = requests.patch(url=url, headers=get_request_headers(token), data=json.dumps(study_metadata))
    # print(r)


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


def create_studies_and_samples(study_filename, samples_filename, template_accession, host, token):
    if samples_filename is None:
        study_accession = create_study(study_filename, template_accession, 0, host, token)
    else:
        new_samples = read_samples_metadata(samples_filename)
        study_accession = create_study(study_filename, template_accession, 1, host, token)
        time.sleep(3)
        samples_parent = get_samples_parent(study_accession, host, token)
        replace_samples(study_accession, samples_parent, new_samples, host, token)
    return study_accession


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
    parser.add_argument('--token', type=str, help='token', required=True)
    args = parser.parse_args()
    host = args.srv[:-1] if args.srv.endswith('/') else args.srv
    template_accession = select_template(host, args.token, args.template)
    study_accession =create_studies_and_samples(args.study, args.samples, template_accession, host, args.token)
    print(study_accession)


if __name__ == "__main__":
    main()
