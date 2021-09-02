#!/usr/bin/python3

import argparse
import boto3
import io
import json
import logging
import math
import paramiko
import requests
import sys
import time

from urllib.parse import urlparse


MULTI_VALUE_SEPARATOR = '|'
CHUNK_SIZE = 8388608 # 2**23
DEFAULT_FIELDS = ['Data Files / Raw', 'Data Files / Processed']

EXAMPLE_TEXT = '''example:

 python %(prog)s.py --srv https://qa.magnum.genestack.com/ --study_accession GSF000160 --s3 aws_cred.json --sftp ftp_cred.json --token <token>
 
 python %(prog)s.py --srv https://qa.magnum.genestack.com/ --study_accession GSF000160 --s3 aws_cred.json --sftp ftp_cred.json --token <token> --field 'Data Files / Raw' --field 'Data Files / Processed'
 
 # where aws_cred.json is
 {
    "s3_bucket_name": "<>",
    "aws_server_public_key": "<>",
    "aws_server_secret_key": "<>",
    "region_name": "eu-central-1"
}

# and ftp_cred.json is
{
    "username": "demo",
    "password": "password"
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


class FTPCredentials():
    def __init__(self, filename):
        with open(filename, 'r') as f_cred:
            ftp_cred = json.load(f_cred)
            self.ftp_username = ftp_cred['username']
            self.ftp_password = ftp_cred['password']


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


def update_sample(sample_accession, sample_metadata, host, token):
    url = get_rest_endpoint(host) + 'sampleCurator/default-released/samples/' + sample_accession
    r = requests.patch(url=url, headers=get_request_headers(token), data=json.dumps(sample_metadata))
    # print(r)


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


def open_ftp_connection_raw(ftp_host, ftp_port, ftp_username, ftp_password):
    """
    Opens ftp connection and returns connection object

    """
    try:
        transport = paramiko.Transport((ftp_host, int(ftp_port)))
    except Exception as e:
        return "conn_error {}".format(e)
    try:
        transport.connect(username=ftp_username, password=ftp_password)
    except Exception as identifier:
        return "auth_error"
    ftp_connection = paramiko.SFTPClient.from_transport(transport)
    return ftp_connection


def get_ftp_connection(ftp_url, ftp_cred):
    rec_ftp = urlparse(ftp_url)
    if rec_ftp.port is None:
        ftp_port = 22
        ftp_host = rec_ftp.netloc
    else:
        ftp_port = rec_ftp.port
        ftp_host = rec_ftp.netloc[:rec_ftp.netloc.index(':')]
    ftp_connection = open_ftp_connection_raw(
        ftp_host, int(ftp_port), ftp_cred.ftp_username, ftp_cred.ftp_password
    )
    if ftp_connection == "conn_error":
        print("Failed to connect FTP Server!")
        return False, None, None
    elif ftp_connection == "auth_error":
        print("Incorrect username or password!")
        return False, None, None
    else:
        return ftp_connection


def check_file_exist_on_sftp(sftp_url, ftp_cred, ftp_conn=None):
    rec = urlparse(sftp_url)
    if rec.scheme != 'sftp':
        raise Exception('Scheme {} is not supported'.format(rec.scheme))

    if ftp_conn is None:
        ftp_rec = rec._replace(scheme='ftp')
        ftp_url = ftp_rec.geturl()
        ftp_conn = get_ftp_connection(ftp_url, ftp_cred)

    ftp_file_path = rec.path
    try:
        ftp_file_stat = ftp_conn.stat(ftp_file_path)
        return True, ftp_file_stat.st_size, ftp_conn
    except Exception as e:
        # print("File does not exists on FTP Server! {}".format(e))
        return False, None, None


def transfer_chunk_from_ftp_to_s3(
        ftp_file,
        s3_connection,
        multipart_upload,
        bucket_name,
        ftp_file_path,
        s3_file_path,
        part_number,
        chunk_size,
        progress_information
):
    start_time = time.time()
    chunk = ftp_file.read(int(chunk_size))
    part = s3_connection.upload_part(
        Bucket=bucket_name,
        Key=s3_file_path,
        PartNumber=part_number,
        UploadId=multipart_upload["UploadId"],
        Body=chunk,
    )
    end_time = time.time()
    total_seconds = end_time - start_time
    # print(
    #    "speed is {} kb/s total seconds taken {}".format(
    #        math.ceil((int(chunk_size) / 1024) / total_seconds), total_seconds
    #    )
    #)
    progress_information.speed = math.ceil((int(chunk_size) / 1024) / total_seconds)

    part_output = {"PartNumber": part_number, "ETag": part["ETag"]}
    return part_output


def transfer_file_from_ftp_to_s3(
        bucket_name, ftp_file_path, s3_file_path, aws_cred, chunk_size, ftp_connection, force_rewrite,progress_information
):
    ftp_file = ftp_connection.file(ftp_file_path, "r")
    s3_connection = boto3.client('s3',
                                 aws_access_key_id=aws_cred.server_public_key,
                                 aws_secret_access_key=aws_cred.server_secret_key,
                                 region_name=aws_cred.region_name
                                 )
    ftp_file_size = ftp_file._get_size()
    try:
        s3_file_obj = s3_connection.head_object(Bucket=bucket_name, Key=s3_file_path)
        # logging.info('s3_file["ContentLength"]={} ftp_file_size={}'.format(s3_file["ContentLength"], ftp_file_size))
        if int(s3_file_obj["ContentLength"]) == int(ftp_file_size):
            if force_rewrite:
                logging.warning("Rewriting existing file {} in S3 bucket with the same length".format(ftp_file_path))
            else:
                logging.warning("Skipping existing file {} in S3 bucket".format(ftp_file_path))
                ftp_file.close()
                return
        else:
            logging.warning("Rewriting existing file {} in S3 bucket".format(ftp_file_path))
    except Exception as e:
        pass
    if ftp_file_size <= int(chunk_size):
        # upload file in one go
        logging.debug("Transferring complete File {} from FTP to S3...".format(ftp_file_path))
        progress_information.report_transfer_in_chunks(1, 1, ftp_file_path)
        ftp_file_data = ftp_file.read()
        ftp_file_data_bytes = io.BytesIO(ftp_file_data)
        s3_connection.upload_fileobj(ftp_file_data_bytes, bucket_name, s3_file_path)
        logging.debug("Successfully Transferred file from FTP to S3!")
        ftp_file.close()

    else:
        msg = "Transferring File {} from FTP to S3 in chunks...".format(ftp_file_path)
        logging.debug(msg)
        # print(msg)
        # upload file in chunks
        chunk_count = int(math.ceil(ftp_file_size / float(chunk_size)))
        multipart_upload = s3_connection.create_multipart_upload(
            Bucket=bucket_name, Key=s3_file_path
        )
        parts = []
        for i in range(chunk_count):
            # print("Transferring chunk {}...".format(i + 1))
            progress_information.report_transfer_in_chunks(i+1, chunk_count, ftp_file_path)
            part = transfer_chunk_from_ftp_to_s3(
                ftp_file,
                s3_connection,
                multipart_upload,
                bucket_name,
                ftp_file_path,
                s3_file_path,
                i + 1,
                chunk_size,
                progress_information
                )
            parts.append(part)
            msg = "Chunk {} Transferred Successfully!".format(i + 1)
            logging.debug(msg)
            # print(msg)

        part_info = {"Parts": parts}
        s3_connection.complete_multipart_upload(
            Bucket=bucket_name,
            Key=s3_file_path,
            UploadId=multipart_upload["UploadId"],
            MultipartUpload=part_info,
        )
        msg = "All chunks Transferred to S3 bucket! File Transfer successful!"
        logging.debug(msg)
        # print(msg)
        ftp_file.close()


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


def convert_url(sftp_url, study_accession, s3_bucket_name):
    rec = urlparse(sftp_url)
    path = rec.path[1:] if rec.path.startswith('/') else rec.path
    return 's3://' + s3_bucket_name + '/' + study_accession + '/' + path


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


def copy_one_file_sftp2s3(sftp_url, s3_url, aws_cred, ftp_connection, progress_information):
    ftp_file_path = get_file_path_from_sftp_link(sftp_url)
    s3_key = get_s3_key_from_s3_url(s3_url)
    transfer_file_from_ftp_to_s3(
        aws_cred.s3_bucket_name,
        ftp_file_path,
        s3_key,
        aws_cred,
        CHUNK_SIZE,
        ftp_connection,
        True,
        progress_information
    )


def collect_sftp_links_for_one_sample(sample_record, fields):
    metainfo = sample_record['metainfo']
    sftp_links = set()
    for field in fields:
        values = metainfo[field]['displayValues']
        values = values if values is not None else []
        values = values if isinstance(values, list) else [values]
        for value in values:
            if value.startswith('sftp://'):
                sftp_links.add(value)
    return sftp_links


def copy_sftp_links(sftp_links, all_s3_links, study_accession, ftp_cred, aws_cred, progress_information):
    ftp_conn = None
    s3_client = None
    for sftp_link in sftp_links:
        s3_link = convert_url(sftp_link, study_accession, aws_cred.s3_bucket_name)
        if s3_link in all_s3_links:
            # The file is already there
            continue
        # Check that the file exists on S3 and copy if not
        exists_on_sftp, size_on_sftp, ftp_conn = check_file_exist_on_sftp(sftp_link, ftp_cred, ftp_conn)
        if not exists_on_sftp:
            print('File not found: {}'.format(sftp_link))
            continue
        exists_on_s3, size_on_s3, s3_client = check_file_exists_on_s3(s3_link, aws_cred, s3_client)
        if exists_on_s3 and size_on_sftp == size_on_s3:
            # File is already there
            all_s3_links.add(s3_link)
        else:
            copy_one_file_sftp2s3(sftp_link, s3_link, aws_cred, ftp_conn, progress_information)
            all_s3_links.add(s3_link)


def update_sample_metainfo(sample_record, fields, study_accession, aws_cred, host, token):
    metainfo = sample_record['metainfo']
    sample_accession = metainfo['genestack:accession']['displayValues']
    sftp_links = set()
    update_dict = dict()
    for field in fields:
        values = metainfo[field]['displayValues']
        if values is None:
            continue
        new_values = list()
        if isinstance(values, list):
            for value in values:
                if value.startswith('sftp://'):
                    s3_url = convert_url(value, study_accession, aws_cred.s3_bucket_name)
                    new_values.append(s3_url)
                else:
                    new_values.append(value)
            update_dict[field] = new_values
        else:
            if values.startswith('sftp://'):
                s3_url = convert_url(values, study_accession, aws_cred.s3_bucket_name)
                update_dict[field] = s3_url
    update_sample(sample_accession, update_dict, host, token)


def check_and_copy_sftp_for_one_sample(sample_record, fields, all_s3_links, study_accession, ftp_cred, aws_cred,
                                       host, token,
                                       progress_information):
    sftp_urls = collect_sftp_links_for_one_sample(sample_record, fields)
    if len(sftp_urls) > 0:
        copy_sftp_links(sftp_urls, all_s3_links, study_accession, ftp_cred, aws_cred, progress_information)
        # Update sample metainfo
        update_sample_metainfo(sample_record, fields, study_accession, aws_cred, host, token)
    return len(sftp_urls)


def main():
    parser = argparse.ArgumentParser(prog='sftp2s3_odm',
                                     description='Copy files from SFTP-server to S3 storage and replace links in Samples metadata',
                                     epilog=EXAMPLE_TEXT,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--srv', type=str, help='url of the server', required=True)
    parser.add_argument('--study_accession', type=str, help='Study accession', required=True)
    parser.add_argument('--s3', type=str, help='Path to the AWS credentials file', required=True)
    parser.add_argument('--sftp', type=str, help='Path to the SFTP credentials file, if needed', required=True)
    parser.add_argument('--token', type=str, help='token', required=True)
    parser.add_argument('--field', type=str, action='append', help='Name of the column with sftp-links to check', required=False)
    args = parser.parse_args()
    # logging.basicConfig(stream=sys.stderr, format='%(asctime)s %(levelname)s: %(message)s', level=logging.WARNING)
    host = args.srv[:-1] if args.srv.endswith('/') else args.srv
    aws_cred = AWSCredentials(args.s3)
    ftp_cred = FTPCredentials(args.sftp) if args.sftp is not None else None
    study_accession = args.study_accession
    token = args.token
    fields = args.field if args.field is not None else DEFAULT_FIELDS
    sample_parent = get_samples_parent(study_accession, host, token)
    samples = get_samples_by_parent_accession(host, token, sample_parent)
    total = len(samples)
    all_sftp_links, all_s3_links = collect_all_sftp_s3_links(samples, fields)
    print('There are {} sftp urls in {} samples to process'.format(len(all_sftp_links), total))
    if len(all_sftp_links) == 0:
        return

    start_time = time.perf_counter()
    total_changed_sftp_links = 0
    for index, sample_record in enumerate(samples):
        progress_information = ProgressInformation(index, total, start_time)
        changed_sftp_links_count = check_and_copy_sftp_for_one_sample(sample_record, fields, all_s3_links,
                                                                      study_accession, ftp_cred, aws_cred,
                                                                      host, token, progress_information)
        total_changed_sftp_links += changed_sftp_links_count
        count = index + 1
        end = '\n' if count == total else '\r'
        progress_information.update(end)
    print('The number of changed sftp urls: {}'.format(total_changed_sftp_links))


class ProgressInformation(object):
    def __init__(self, sample_index, total_number_of_samples, start_time):
        self.sample_index = sample_index
        self.total_number_of_samples = total_number_of_samples
        self.start_time = start_time
        self.speed = None

    def update(self, end='\r'):
        time_spent = time.perf_counter() - self.start_time
        done = (self.sample_index+1) / self.total_number_of_samples
        print(f" processed: {self.sample_index+1} of {self.total_number_of_samples} samples, time={time_spent:.2f}"
              f" samples/sec={(self.sample_index+1)/time_spent:.2f} done={done:.2f}", end=end, file=sys.stderr)

    def report_transfer_in_chunks(self, chunk_number, chunk_total, ftp_file_path, end='\r'):
        time_spent = time.perf_counter() - self.start_time
        header = f" processed: {self.sample_index+1} of {self.total_number_of_samples} samples, time={time_spent:.2f}" +\
                 f" chunk {chunk_number} of {chunk_total}: {ftp_file_path}"
        if self.speed is not None:
            header += f" speed {self.speed} kb/s"
        print(header, end=end, file=sys.stderr)

if __name__ == "__main__":
    main()
