#!/usr/bin/python3

import argparse
import csv
import json
import paramiko
import sys
import time


from urllib.parse import urlparse


MULTI_VALUE_SEPARATOR = '|'
DEFAULT_FIELDS = ['Data Files / Raw', 'Data Files / Processed']

EXAMPLE_TEXT = '''example:

 python %(prog)s.py --metadata samples.tsv --sftp sftp_cred.json
 
 python %(prog)s.py --metadata samples.tsv --sftp sftp_cred.json --field 'Data Files / Raw' --field 'Data Files / Processed'
 
# sftp_cred.json is
{
    "username": "demo",
    "password": "password"
}
 '''


class FTPCredentials():
    def __init__(self, filename):
        with open(filename, 'r') as f_cred:
            ftp_cred = json.load(f_cred)
            self.ftp_username = ftp_cred['username']
            self.ftp_password = ftp_cred['password']


def open_ftp_connection_raw(ftp_host, ftp_port, ftp_username, ftp_password):
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


def read_metadata_file(metadata_filename):
    new_samples = []
    with open(metadata_filename) as f:
        reader = csv.reader(f, delimiter='\t')
        headers = next(reader)
        for row in reader:
            new_sample = dict()
            for key, value in zip(headers, row):
                values = value.split(MULTI_VALUE_SEPARATOR)
                # new_sample.append({"attributeName": key, "values": values})
                new_sample[key] = values
            if len(new_sample) > 0:
                new_samples.append(new_sample)
    return headers, new_samples


def calc_all_sftp_links(fields, line_dicts):
    sftp_values = set()
    for line_dict in line_dicts:
        for field in fields:
            values = line_dict[field]
            for value in values:
                if value.startswith('sftp://'):
                    sftp_values.add(value)
    return len(sftp_values)


def check_sftp_links(metadata_filename, fields, ftp_cred):
    headers, line_dicts = read_metadata_file(metadata_filename)
    missing_fields = [field for field in fields if field not in headers]
    if len(missing_fields) > 0:
        print('There are no columns with the following names: {}'.format(str(missing_fields)))
    fields_to_check = [field for field in fields if field in headers]
    if len(fields_to_check) == 0:
        print('There are no columns to check')
        return

    print('The following columns will be checked: {}'.format(str(fields_to_check)))
    count_all_sftp_links = calc_all_sftp_links(fields_to_check, line_dicts)
    non_sftp_values = []
    sftp_values_status = dict()
    ftp_conn = None
    total_size = 0
    start_time = time.perf_counter()
    for count, line_dict in enumerate(line_dicts):
        for field in fields_to_check:
            values = line_dict[field]
            for value in values:
                if value.startswith('sftp://'):
                    if value in sftp_values_status:
                        exists, size = sftp_values_status[value]
                    else:
                        exists, size, ftp_conn = check_file_exist_on_sftp(value, ftp_cred, ftp_conn)
                        sftp_values_status[value] = (exists, size)
                        time_spent = time.perf_counter() - start_time
                        sftp_count = len(sftp_values_status)
                        done =  sftp_count / count_all_sftp_links
                        end = '\n' if sftp_count == count_all_sftp_links else '\r'
                        print(f" sftp-links={sftp_count} all sftp-links={count_all_sftp_links} time={time_spent:.2f}"
                              f" sftp-links processed/sec={sftp_count/time_spent:.2f} done={done:.2f}", end=end, file=sys.stderr)
                    if exists:
                        total_size += size
                    else:
                        print('\nLine: {} Column: {} File not found: {}'.format(str(count+2), field, value), file=sys.stderr)
                else:
                    non_sftp_values.append(value)

    total_files_count = len({ value for value in sftp_values_status.keys() if sftp_values_status[value][0] })
    print('There are {} files on sftp with total size {} ({:.2f}Mb/{:.2f}Gb)'.format(
        total_files_count, total_size, total_size / 1024**2, total_size / 1024**3))
    if len(non_sftp_values) > 0:
        print('There are {} non sftp-links in the given columns: {}'.format(len(non_sftp_values), non_sftp_values[0:5]))
    bad_sftp_count = len({ value for value in sftp_values_status.keys() if not sftp_values_status[value][0] })
    if bad_sftp_count > 0:
        print('{} of sftp-links are broken'.format(bad_sftp_count))
        sys.exit(2)


def main():
    parser = argparse.ArgumentParser(prog='check_sftp_links',
                                     description='Check existence of files using sftp-links in metadata',
                                     epilog=EXAMPLE_TEXT,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--metadata', type=str, help='Path to the metadata TSV-file', required=True)
    parser.add_argument('--sftp', type=str, help='Path to the SFTP credentials file, if needed', required=True)
    parser.add_argument('--field', type=str, action='append', help='Name of the column with sftp-links to check', required=False)
    args = parser.parse_args()
    # logging.basicConfig(stream=sys.stderr, format='%(asctime)s %(levelname)s: %(message)s', level=logging.WARNING)
    ftp_cred = FTPCredentials(args.sftp) if args.sftp is not None else None
    metadata_filename = args.metadata
    fields = args.field if args.field is not None else DEFAULT_FIELDS
    check_sftp_links(metadata_filename, fields, ftp_cred)


if __name__ == "__main__":
    main()
