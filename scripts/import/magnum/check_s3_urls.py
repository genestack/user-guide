#!/usr/bin/python3

import argparse
import boto3
import json
import requests
import sys
import time

from urllib.parse import urlparse


MULTI_VALUE_SEPARATOR = '|'
CHUNK_SIZE = 8388608 # 2**23
DEFAULT_FIELDS = ['Data Files / Raw', 'Data Files / Processed']

EXAMPLE_TEXT = '''example:

 python %(prog)s.py --srv https://qa.magnum.genestack.com/ --study_accession GSF000160 --s3 aws_cred.json --token <token>

  python %(prog)s.py --srv https://qa.magnum.genestack.com/ --study_accession GSF000160 --s3 aws_cred.json --token <token> --field 'Data Files / Raw' --field 'Data Files / Processed'

 # where aws_cred.json is
 {
    "s3_bucket_name": "<>",
    "aws_server_public_key": "<>",
    "aws_server_secret_key": "<>",
    "region_name": "eu-central-1"
}
 '''


class AWSCredentials():
    def __init__(self, filename):
        with open(filename, 'r') as f_cred:
            aws_cred = json.load(f_cred)
            self.s3_bucket_name = aws_cred['s3_bucket_name']
            self.server_public_key = aws_cred['aws_server_public_key']
            self.server_secret_key = aws_cred['aws_server_secret_key']
            self.region_name = aws_cred['region_name']


def get_rest_endpoint(host):
    return host + '/frontend/rs/genestack/'


def get_app_endpoint(host):
    return host + '/frontend/endpoint/application/invoke/genestack/'


def get_request_headers(token):
    return {'Genestack-API-Token': token,
            'Accept': 'application/json',
            'Content-Type': 'application/json'}


def get_samples_parent(study_accession, host, token):
    url_authenticate = get_app_endpoint(host) + 'signin/authenticateByApiToken'
    url_get_study_container_descriptor = get_app_endpoint(host) + 'study-metainfo-editor/getStudyContainerDescriptor'

    s = requests.Session()
    session = s.post(url_authenticate, json=[token])
    res = json.loads(s.post(url=url_get_study_container_descriptor, data=json.dumps([study_accession])).text)
    if 'result' not in res:
        print(res)
        raise Exception('There is a problem while invoking getStudyContainerDescriptor')
    check_samples = res['result']['metadataDescriptors']
    return [item['id'] for item in check_samples if item[u'typeId'] == 'sampleGroup'][0]


def get_samples_by_parent_accession(host, token, sample_parent):
    url_authenticate = get_app_endpoint(host) + 'signin/authenticateByApiToken'
    url_get_table_content_view = get_app_endpoint(host) + 'study-metainfo-editor/getTableContentView'
    s = requests.Session()
    session = s.post(url_authenticate, json=[token])
    raw_samples = s.post(
        url=url_get_table_content_view,
        json=[sample_parent, None, 0, 500000, {}])
    samples = json.loads(raw_samples.text)["result"]["fileKinds"][1]["table"]
    # xx[0]['metainfo']['Data Files / Raw']
    # {'key': 'Data Files / Raw', 'displayValues': None, 'metainfoType': 'com.genestack.api.metainfo.ExternalLink'}
    # {'key': 'url', 'displayValues': ['sftp://test.rebex.net:22/pub/example/KeyGenerator.png', 'sftp://test.rebex.net:22/pub/example/mail-editor.png'], 'metainfoType': 'com.genestack.api.metainfo.StringValue'}
    return samples


def check_file_exists_on_s3(s3_url, aws_cred, s3_client=None):
    if s3_client is None:
        s3_client = boto3.client('s3', aws_access_key_id=aws_cred.server_public_key,
                          aws_secret_access_key=aws_cred.server_secret_key)
    rec = urlparse(s3_url)
    key = rec.path[1:] if rec.path.startswith('/') else rec.path
    try:
        # print(aws_cred.s3_bucket_name, key)
        s3_file_obj = s3_client.head_object(Bucket=aws_cred.s3_bucket_name, Key=key)
        return True, int(s3_file_obj["ContentLength"]), s3_client
    except Exception as e:
        # File doesn't exist on S3
        return False, None, None


def collect_all_sftp_s3_links(samples, fields):
    sftp_links = set()
    s3_links = set()
    for sample_record in samples:
        metainfo = sample_record['metainfo']
        for field in fields:
            values = metainfo[field]['displayValues']
            values = values if values is not None else []
            values = values if isinstance(values, list) else [values]
            for value in values:
                if value.startswith('sftp://'):
                    sftp_links.add(value)
                elif value.startswith('s3://'):
                    s3_links.add(value)
    return sftp_links, s3_links


def get_file_path_from_sftp_link(sftp_url):
    rec_ftp = urlparse(sftp_url)
    return rec_ftp.path


def get_s3_key_from_s3_url(s3_url):
    rec_s3 = urlparse(s3_url)
    s3_file_path = rec_s3.path
    s3_key = s3_file_path[1:] if s3_file_path.startswith('/') else s3_file_path
    return s3_key


def collect_s3_links_for_one_sample(sample_record, fields):
    metainfo = sample_record['metainfo']
    urls = set()
    for field in fields:
        values = metainfo[field]['displayValues']
        values = values if values is not None else []
        values = values if isinstance(values, list) else [values]
        for value in values:
            if value.startswith('s3://'):
                urls.add(value)
    return urls


def check_s3_urls(s3_urls, aws_cred):
    s3_client = None
    total = 0
    for s3_url in s3_urls:
        exists_on_s3, size_on_s3, s3_client = check_file_exists_on_s3(s3_url, aws_cred, s3_client)
        if not exists_on_s3:
            print('File not found: {}'.format(s3_url))
            continue
        else:
            total += size_on_s3
    return total


def check_s3_urls_for_one_sample(sample_record, fields, aws_cred):
    s3_urls = collect_s3_links_for_one_sample(sample_record, fields)
    return check_s3_urls(s3_urls, aws_cred)

def main():
    parser = argparse.ArgumentParser(prog='check_s3_urls',
                                     description='Copy files from SFTP-server to S3 storage and replace links in Samples metadata',
                                     epilog=EXAMPLE_TEXT,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--srv', type=str, help='url of the server', required=True)
    parser.add_argument('--study_accession', type=str, help='Study accession', required=True)
    parser.add_argument('--s3', type=str, help='Path to the AWS credentials file', required=True)
    parser.add_argument('--token', type=str, help='token', required=True)
    parser.add_argument('--field', type=str, action='append', help='Name of the column with sftp-links to check', required=False)
    args = parser.parse_args()
    # logging.basicConfig(stream=sys.stderr, format='%(asctime)s %(levelname)s: %(message)s', level=logging.WARNING)
    host = args.srv[:-1] if args.srv.endswith('/') else args.srv
    aws_cred = AWSCredentials(args.s3)
    study_accession = args.study_accession
    token = args.token
    fields = args.field if args.field is not None else DEFAULT_FIELDS
    sample_parent = get_samples_parent(study_accession, host, token)
    samples = get_samples_by_parent_accession(host, token, sample_parent)
    total = len(samples)
    all_sftp_links, all_s3_links = collect_all_sftp_s3_links(samples, fields)
    print('There are {} s3 urls in {} samples to process'.format(len(all_s3_links), total))
    if len(all_s3_links) == 0:
        return

    start_time = time.perf_counter()
    total_size = 0
    for index, sample_record in enumerate(samples):
        total_size += check_s3_urls_for_one_sample(sample_record, fields, aws_cred)
        time_spent = time.perf_counter() - start_time
        count = index + 1
        done =  count / total
        end = '\n' if count == total else '\r'
        print(f" processed: {count} of {total} samples, time={time_spent:.2f}"
              f" samples/sec={count/time_spent:.2f} done={done:.2f}", end=end, file=sys.stderr)
    print('There are {} s3 urls with total size {} ({:.2f}Mb/{:.2f}Gb)'.format(
        len(all_s3_links), total_size, total_size / 1024**2, total_size / 1024**3))


if __name__ == "__main__":
    main()
