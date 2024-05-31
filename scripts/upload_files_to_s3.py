#!/usr/bin/python3

import argparse
import boto3
import json
import os
import sys
from botocore.exceptions import NoCredentialsError


class AWSCredentials():
    def __init__(self, filename):
        with open(filename, 'r') as f_cred:
            aws_cred = json.load(f_cred)
            self.s3_bucket_name = aws_cred['s3_bucket_name']
            self.server_public_key = aws_cred['aws_server_public_key']
            self.server_secret_key = aws_cred['aws_server_secret_key']
            self.region_name = aws_cred['region_name']


def remove_file_from_aws(aws_cred, s3_file):
    s3 = boto3.client('s3', aws_access_key_id=aws_cred.server_public_key,
                      aws_secret_access_key=aws_cred.server_secret_key)
    try:
        s3.delete_object(Bucket=aws_cred.s3_bucket_name, Key=s3_file)
        return True
    except NoCredentialsError:
        print("Credentials not available")
        return False


def upload_to_aws(local_file, aws_cred, s3_file):
    s3 = boto3.client('s3', aws_access_key_id=aws_cred.server_public_key,
                      aws_secret_access_key=aws_cred.server_secret_key)

    try:
        s3.upload_file(local_file, aws_cred.s3_bucket_name, s3_file)
        return True
    except FileNotFoundError:
        print("The file was not found", file=sys.stderr)
        return False
    except NoCredentialsError:
        print("Credentials not available", file=sys.stderr)
        return False


def upload_one_file(folder, filepath, aws_cred):
    basename = os.path.basename(filepath)
    s3_key = folder + '/' + basename
    s3_url = "s3://{bucket}/{s3_key}".format(bucket=aws_cred.s3_bucket_name, s3_key=s3_key)
    if upload_to_aws(filepath, aws_cred, s3_key):
        print(s3_url)
    else:
        print('Upload failed for the file {}'.format(filepath))


def upload_all_files(folder, filepath_list, aws_cred):
    for filepath in filepath_list:
        upload_one_file(folder, filepath, aws_cred)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--folder', type=str, help='S3 folder for the uploading', required=True)
    parser.add_argument('--aws_cred', type=str, help='Path to the AWS credentials file', required=True)
    parser.add_argument('--file', type=str, action='append', help='Path to the file for uploading to S3', required=True)
    args = parser.parse_args()
    folder = args.folder[:-1] if args.folder.endswith('/') else args.folder
    aws_cred = AWSCredentials(args.aws_cred)
    upload_all_files(folder, args.file, aws_cred)


if __name__ == "__main__":
    main()
