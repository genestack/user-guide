#!/usr/bin/python

#  Copyright (c) 2011-2024 Genestack Limited
#  All Rights Reserved
#  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF GENESTACK LIMITED
#  The copyright notice above does not evidence any
#  actual or intended publication of such source code.

import argparse
import requests

BASE_URL = '/frontend/rs/genestack/studyCurator/default-released'

EXAMPLE_TEXT = '''example:

 python %(prog)s.py --srv https://qa.magnum.genestack.com --study GSF010529 --token <token>
 '''

def delete_study(study_accession, srv, token):
    app_endpoint = srv + '/frontend/endpoint/application/invoke/genestack/'
    url_authenticate = app_endpoint + 'signin/authenticateByApiToken'
    s = requests.Session()
    s.post(url_authenticate, json=[token])
    url_delete_object = app_endpoint + 'study-metainfo-editor/wipeStudy'
    header = {'Genestack-API-Token': token}
    response = s.post(url=url_delete_object, json=[study_accession], headers=header)
    print(response.status_code)


def main():
    parser = argparse.ArgumentParser(prog='delete_study_via_api',
                                 description='Delete study',
                                 epilog=EXAMPLE_TEXT,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--srv', type=str, help='url of the server', required=True)
    parser.add_argument('--study', type=str, help='study accession', required=True)
    parser.add_argument('--token', type=str, help='token', required=True)
    args = parser.parse_args()
    host = args.srv[:-1] if args.srv.endswith('/') else args.srv
    delete_study(args.study, host, args.token)


if __name__ == "__main__":
    main()
