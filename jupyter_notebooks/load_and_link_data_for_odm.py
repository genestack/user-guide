#  Copyright (c) 2011-2023 Genestack Limited
#  All Rights Reserved
#  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF GENESTACK LIMITED
#  The copyright notice above does not evidence any
#  actual or intended publication of such source code.

# !/usr/bin/env python2.7
# coding=utf-8

import requests
import json
import collections
from time import sleep
import argparse
import sys


def green_text(text):
    if sys.platform == 'win32' or not sys.stdout.isatty():
        return text
    else:
        return u"""\u001b[32m""" + text + u"""\u001b[0m"""


def red_text(text):
    if sys.platform == 'win32' or not sys.stdout.isatty():
        return text
    else:
        return u"""\u001b[31m""" + text + u"""\u001b[0m"""


def authenticate():
    aut_url = "/frontend/endpoint/application/invoke/genestack/signin/authenticateByApiToken"
    url_authenticate = SERVER + aut_url
    session = requests.Session()
    result = session.post(url_authenticate, json=[TOKEN])
    if not json.loads(result.text)["result"]["authenticated"]:
        if DEBUG_FLAG:
            print(result, result.text)
        print(red_text("You set invalid token or your license is expired!"))
        sys.exit()
    return session


# TODO: update embeded documentation
def __doc__():
    print (u"""
This script is used for uploading and linking the data from public FTP/HTTP. Script uses 'Default template' if nothing else is specified.
See https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/import-data-using-api.html
* Make sure you have a Genestack API token first.
""" + red_text(u"* Mandatory! ") + u"""You need to provide your token via parameter -t or --token [TOKEN]. 
""" + red_text(u"* Mandatory! ") + u"""Don't forget to provide the link to study file in valid format via -s or --study [URL]
  OR(!) you can provide accession of existing study via parameter -sa or --study_accession [ACCESSION].
  You're allowed to set only one of them (link to study or accession of existing study) 
""" + red_text(u"* Mandatory! ") + u"""Provide link of samples file in valid format via -sm or --samples [URL]. 
* Optional. Provide expression data file and expression metadata file 
  via -e or --expression [URL] and -em or --expression_metadata [URL] respectively. 
""" + green_text(u"* Optional. ") + u"""Provide variant data file and variant metadata file 
  via -v or --variant [URL] and -vm or --variant_metadata [URL] respectively. 
""" + green_text(u"* Optional. ") + u"""Provide flow cytometry data file and flow cytometry metadata file 
  via -f or --flow_cytometry [URL] and -fm or --flow_cytometry_metadata [URL] respectively. 
""" + green_text(u"* Optional. ") + u"""If you need to specify different from Default template, then provide template accession 
via -tmpl or --template [ACCESSION],  Marked as "Default" template will be used, if no specific template accession specified. 
""" + green_text(u"* Optional. ") + u"""You can set server address via -H or--host (by default it is https://odm-demos.genestack.com/)

""" + green_text(u"* Note. ") + u"""Also you can provide several sample files and several signal files for each samples file.
This feature works positionally. This mean you must set signal files parameters after corresponding samples file.

If all data files are correct, files will be uploaded and linked successfully. 
-----------------------------------------------------------------------------
""" + green_text(u"Example 1: ") + u"""In this case will be created study with one samples files. 
For the this samples file will be loaded and linked one variants file, one expression file and one flow cytometry file.
python load_and_link_data_for_odm.py --token [token] \ 
--study http://data_source/study.csv \ 
--samples http://data_source/samples.csv \ 
--expression http://data_source/expression.gct \ 
--expression_metadata http://data_source/expression_metadata.gct.tsv \ 
--variant http://data_source/variations.vcf \ 
--variant_metadata http://data_source/variations_meta.vcf.csv \ 
--flow_cytometry http://data_source/FACS.facs \ 
--flow_cytometry_metadata http://data_source/FACS_meta.facs.csv \ 
--template GSF0000000
""" + green_text(u"Example 2: ") + u"""In this case will be created study with two samples files. 
For the first samples file will be loaded and linked two expression files. 
For the second samples file will be loaded and linked one variants file and one flow cytometry file.
python load_and_link_data_for_odm.py --token [token] \ 
--study http://data_source/study.csv \ 
--samples http://data_source/samples_1.csv \ 
--expression http://data_source/expression_1.gct \ 
--expression_metadata http://data_source/expression_metadata_1.gct.tsv \ 
--expression http://data_source/expression_2.gct \ 
--expression_metadata http://data_source/expression_metadata_2.gct.tsv \ 
--samples http://data_source/samples_2.csv \ 
--variant http://data_source/variations.vcf \ 
--variant_metadata http://data_source/variations_meta.vcf.csv \ 
--flow_cytometry http://data_source/FACS.facs \ 
--flow_cytometry_metadata http://data_source/FACS_meta.facs.csv \ 
--template GSF0000000
""")


LOAD_RETRIES = 60
INTEGRATION_PREFIX = "integrationCurator/%s/integration/link/"
FILE_ENDPOINTS_DICT = {"study": "studyCurator/%s/studies",
                       "samples": "sampleCurator/%s/samples",
                       "variant": "variantCurator/%s/variant/vcf",
                       "expression": "expressionCurator/%s/expression/gct",
                       "facs": "flowCytometryCurator/%s/flow-cytometry/facs"}
LINK_ENDPOINTS_DICT = {"samples_to_study": INTEGRATION_PREFIX + "sample/%s/to/study/%s",
                       "variant_to_sample": INTEGRATION_PREFIX + "variant/%s/to/sample/%s",
                       "facs_to_sample": INTEGRATION_PREFIX + "flow-cytometry/%s/to/sample/%s",
                       "expression_to_sample": INTEGRATION_PREFIX + "expression/%s/to/sample/%s"}  # type: dict
APP_VERSION = "default-released"


def get_template():
    url_request_template = (SERVER +
                            "/frontend/endpoint/application/invoke/genestack/study-metainfotemplateeditor/listTemplates")
    response = SESSION.post(url=url_request_template, json=[])
    assert response.status_code == 200, response.text
    assert "result" in response.text, response.text
    result = json.loads(response.text)["result"]
    accession = [template["accession"] for template in result
                 if template.get("isDefault", False)][0]
    assert accession
    return accession  # type: str


# TODO: implement loop for get samples by pages
def get_samples_by_parent_accession(sample_parent=None):
    if not sample_parent:
        print(red_text("You didn't provide sample parent accession! Exit!"))
        sys.exit()
    raw_samples = SESSION.post(
        url=SERVER + "/frontend/endpoint/application/invoke/genestack/study-metainfo-editor/getTableContentView",
        json=[sample_parent, None, 0, 500000, {}])
    samples = json.loads(raw_samples.text)["result"]["fileKinds"][1]["table"]
    samples_dict = collections.OrderedDict()
    for sample in samples:
        samples_dict[sample["metainfo"]["Sample Source ID"]["displayValues"]] = sample["accession"]
    return samples_dict


def check_access_to_study(study_accession):
    response = SESSION.post(
        url=SERVER + "/frontend/endpoint/application/invoke/genestack/study-metainfo-editor/getMapContentView",
        json=[study_accession, None])
    if response.status_code != 200:
        if DEBUG_FLAG:
            print(response, response.text)
        print(red_text("You haven't access permissions to study: %s or it doesn't exist!") % study_accession)
        sys.exit()


def check_links(response=None, name=None, datafile_url=None, metadata_url=None):
    messages = {"study metadata": " {0} is".format(datafile_url),
                "samples metadata": " {0} is".format(datafile_url),
                "expression signal": "(s) {0} and/or {1} is/are".format(
                    str(datafile_url), str(metadata_url)),
                "variant signal": "(s) {0} and/or {1} is/are".format(
                    str(datafile_url), str(metadata_url)),
                "flow_cytometry signal": "(s) {0} and/or {1} is/are".format(
                    str(datafile_url), str(metadata_url))
                }
    try:
        assert response.status_code == 201
    except AssertionError:
        if DEBUG_FLAG:
            print(response, response.text)
        print(red_text("Cannot proceed because the {0} file{1} not accessible to {2}".format(
            name, messages[name], SERVER)))
        return True
    return False


def add_odm_project(sample_accessions=None,
                    signals_list=None):
    expression_file_signal, expression_metadata_file_metadata = None, None
    variant_file_signal, variant_metadata_file_metadata = None, None
    flow_cytometry_file_signal, flow_cytometry_metadata_file_metadata = None, None
    clear_list = []
    pointer = 0
    while pointer < len(signals_list)-1:
        check = {list(signals_list[pointer].keys())[0], list(signals_list[pointer + 1].keys())[0]}
        if check in [{"expression", "expression_metadata"},
                     {"variant", "variant_metadata"},
                     {"flow_cytometry", "flow_cytometry_metadata"}]:
            clear_list.append(signals_list[pointer])
            clear_list.append(signals_list[pointer + 1])
            pointer += 2
        else:
            print(red_text("You can't upload only " +
                           list(signals_list[pointer].keys())[0].replace('_', ' ') + " " +
                           list(signals_list[pointer].values())[0] +
                           " file. Please provide URLs for both."))
            pointer += 1
    for signal in clear_list:
        if list(signal.keys())[0] == "expression":
            expression_file_signal = list(signal.values())[0]
        if list(signal.keys())[0] == "expression_metadata":
            expression_metadata_file_metadata = list(signal.values())[0]
        if expression_file_signal and expression_metadata_file_metadata:
            expression = add_signals(file_signal=expression_file_signal,
                                     file_metadata=expression_metadata_file_metadata,
                                     file_type="expression")
            if expression:
                link_signals(signal_accessions=expression,
                             sample_accessions=sample_accessions,
                             what="expression_to_sample")
            expression_file_signal, expression_metadata_file_metadata = None, None
        if list(signal.keys())[0] == "variant":
            variant_file_signal = list(signal.values())[0]
        if list(signal.keys())[0] == "variant_metadata":
            variant_metadata_file_metadata = list(signal.values())[0]
        if variant_file_signal and variant_metadata_file_metadata:
            variant = add_signals(file_signal=variant_file_signal,
                                  file_metadata=variant_metadata_file_metadata,
                                  file_type="variant")
            if variant:
                link_signals(signal_accessions=variant,
                             sample_accessions=sample_accessions,
                             what="variant_to_sample")
            variant_file_signal, variant_metadata_file_metadata = None, None
        if list(signal.keys())[0] == "flow_cytometry":
            flow_cytometry_file_signal = list(signal.values())[0]
        if list(signal.keys())[0] == "flow_cytometry_metadata":
            flow_cytometry_metadata_file_metadata = list(signal.values())[0]
        if flow_cytometry_file_signal and flow_cytometry_metadata_file_metadata:
            flow_cytometry = add_signals(file_signal=flow_cytometry_file_signal,
                                         file_metadata=flow_cytometry_metadata_file_metadata,
                                         file_type="flow_cytometry")
            if flow_cytometry:
                link_signals(signal_accessions=flow_cytometry,
                             sample_accessions=sample_accessions,
                             what="facs_to_sample")
            flow_cytometry_file_signal, flow_cytometry_metadata_file_metadata = None, None


def get_endpoint(endpoint, child_accession=None, parent_accession=None):
    names_endpoints = {"study": "study",
                       "samples": "samples",
                       "variant": "variant", "expression": "expression",
                       "flow_cytometry": "facs"}
    if endpoint in names_endpoints:
        url = SERVER + "/frontend/rs/genestack/%s/" % (FILE_ENDPOINTS_DICT.get(names_endpoints[endpoint]) % APP_VERSION)
    else:
        url = SERVER + "/frontend/rs/genestack/%s/" % (
                LINK_ENDPOINTS_DICT.get(endpoint) % (APP_VERSION, child_accession, parent_accession))
    return url  # type: str


def add_study(study_link=None, study_accession=None):
    if study_accession:
        check_access_to_study(study_accession)
        return study_accession
    resp = requests.post(
        get_endpoint("study"), headers=HEADERS, json={"link": study_link,
                                                      "templateId": TEMPLATE_ACCESSION})
    if check_links(response=resp,
                   name="study metadata",
                   datafile_url=study_link):
        print(red_text("Mandatory file: study metadata wasn't loaded. Uploading is stopped!"))
        sys.exit()
    data = json.loads(resp.text)
    accession = data.get("data").get("genestack:accession")  # type: str
    if not accession:
        print(red_text("Mandatory file: study metadata wasn't loaded. Uploading is stopped!"))
        sys.exit()
    print("study " + accession + " was added successfully")
    return accession  # type: str


def add_and_link_samples(sample_link):
    resp = requests.post(get_endpoint("samples"),
                         headers=HEADERS,
                         json={"link": sample_link, "templateId": TEMPLATE_ACCESSION})
    if check_links(response=resp,
                   name="samples metadata",
                   datafile_url=sample_link):
        return False
    data = json.loads(resp.text)
    sample_accessions = collections.OrderedDict()
    for item in data:
        sample_accessions[item.get("data").get("Sample Source ID")] = item.get("data").get("genestack:accession")
    if sample_accessions:
        print("samples were added successfully")
    else:
        print(red_text("Mandatory file: samples metadata wasn't loaded. "
                       "Without samples metadata file, linking of signals to samples are impossible. "
                       "Uploading of signals files are stopped!"))
        sys.exit()
    for sample_accession in list(sample_accessions.values()):
        link_objects(what="samples_to_study",
                     accession_from=sample_accession,
                     accession_to=STUDY)
    return sample_accessions  # type: dict


def add_signals(file_signal, file_metadata, file_type):
    resp = requests.post(url=get_endpoint(file_type),
                         headers=HEADERS,
                         json={"link": file_signal,
                               "metadataLink": file_metadata,
                               "templateId": TEMPLATE_ACCESSION})
    if check_links(response=resp,
                   name=file_type + " signal",
                   datafile_url=file_signal,
                   metadata_url=file_metadata):
        return False
    data = json.loads(resp.text)
    result = collections.OrderedDict()
    for item in data.get("runs"):
        result[item.get("Sample Source ID")] = item.get("genestack:accession")
    print(file_type.replace('_', ' ') + " data were added successfully")
    return result  # type: dict


def link_signals(signal_accessions, sample_accessions, what):
    for sample_source_id, signal_accession in list(signal_accessions.items()):
        link_objects(what=what,
                     accession_from=signal_accession,
                     accession_to=sample_accessions.get(sample_source_id))


def link_objects(what, accession_from, accession_to):
    response = None
    if accession_from is None or accession_to is None:
        return None
    assert what in ["samples_to_study",
                    "expression_to_sample",
                    "variant_to_sample",
                    "facs_to_sample"], "You try to link wrong objects"
    for _ in range(LOAD_RETRIES):
        try:
            response = requests.post(get_endpoint(what, accession_from, accession_to), headers=HEADERS)
            assert response.status_code == 204
            return None
        except AssertionError as e:
            if DEBUG_FLAG:
                print(e)
                print(response, response.text)
            sleep(1)
    print("Linking of " + what.replace('_', ' ') + " is failed! Exit!")
    if what == "samples_to_study":
        sys.exit()


def create_signal_file_dict(all_args=None, data=None):
    all_args = [arg.replace('--', '') if arg.startswith('--') else arg for arg in all_args]
    tags = {"-sm": "samples",
            "-f": "flow_cytometry",
            "-fm": "flow_cytometry_metadata",
            "-v": "variant",
            "-vm": "variant_metadata",
            "-e": "expression",
            "-em": "expression_metadata"}

    sample_validation = "-sm" in all_args or "samples" in all_args

    if not sample_validation:
        print(red_text("You didn't provide sample(s) file(s) or sample parent accession! Exit!"))
        sys.exit()
    result = collections.OrderedDict()
    signal_args = data + list(tags.keys()) + list(tags.values())
    signal_args = [arg for arg in all_args if arg in signal_args]
    signal_args = [tags[val] if val in tags.keys() else val for val in signal_args]
    current_sample = None
    for idx, arg in enumerate(signal_args):
        if arg == "samples":
            result[signal_args[idx + 1]] = []
            current_sample = signal_args[idx + 1]
        elif arg in tags.values() and arg != "samples":
            try:
                if signal_args[idx + 1] not in tags.values():
                    result[current_sample].append({arg: signal_args[idx + 1]})
                else:
                    raise IndexError
            except KeyError:
                print(red_text("You provide " + signal_args[idx].replace('_', ' ') +
                               " before sample file. Exit!"))
                sys.exit()
            except IndexError:
                print(red_text("You didn't provide " + signal_args[idx].replace('_', ' ') +
                               " file URL! Exit!"))
                sys.exit()
    return result


class SaneArgumentParser(argparse.ArgumentParser):
    """Disables prefix matching in ArgumentParser."""

    def _get_option_tuples(self, option_string):
        """Prevent argument parsing from looking for prefix matches."""
        return []


parser = SaneArgumentParser(description=__doc__())
parser.add_argument("-t", "--token",
                    action="store",
                    dest="TOKEN",
                    nargs="?",
                    help="API_TOKEN")
parser.add_argument("-H", "--host", "-srv", "--server",
                    action="store",
                    const="https://odm-demos.genestack.com/",
                    default="https://odm-demos.genestack.com/",
                    nargs="?",
                    dest="SERVER",
                    help="URL of the instance data is being loaded to")
parser.add_argument("-tmpl", "--template",
                    action="store",
                    const=None,
                    default=None,
                    nargs="?",
                    dest="TEMPLATE_ACCESSION",
                    help="Accession of the template, by default will use template marked as default.")
parser.add_argument("--debug",
                    action="store",
                    const=True,
                    default=False,
                    nargs="?",
                    dest="debug",
                    help="Enable debug mode.")
parser.add_argument("-s", "--study",
                    action="store",
                    dest="study_link",
                    nargs="?",
                    help="link to study file")
parser.add_argument("-sa", "--study_accession",
                    action="store",
                    dest="study_accession",
                    help="accession of existing study")
parser.add_argument("-sm", "--samples",
                    action="append",
                    dest="data",
                    nargs="?",
                    help="link to sample file")
parser.add_argument("-e", "--expression",
                    action="append",
                    dest="data",
                    help="link to expression data file",
                    nargs="?")
parser.add_argument("-em", "--expression_metadata",
                    action="append",
                    dest="data",
                    help="link to expression metadata file",
                    nargs="?")
parser.add_argument("-v", "--variant",
                    action="append",
                    dest="data",
                    help="link to variants data file",
                    nargs="?")
parser.add_argument("-vm", "--variant_metadata",
                    action="append",
                    dest="data",
                    help="link to variant metadata file",
                    nargs="?")
parser.add_argument("-f", "--flow_cytometry",
                    action="append",
                    dest="data",
                    help="link to flow cytometry data file",
                    nargs="?")
parser.add_argument("-fm", "--flow_cytometry_metadata",
                    action="append",
                    dest="data",
                    help="link to flow cytometry metadata file",
                    nargs="?")
args = parser.parse_args()

if args.study_link and args.study_accession:
    print(red_text("You set accession of existing study (-sa/--study_accession) and link on new study (-s/--study)."
                   "Please set only one of that and run script again. Exit!"))
    sys.exit()
elif not (args.study_link or args.study_accession):
    print(red_text("You shall set accession of existing study OR link on new study! Exit!"))
    sys.exit()
if not args.TOKEN:
    print(red_text("You didn't provide API token! Exit!"))
    sys.exit()

DEBUG_FLAG = args.debug
SERVER = args.SERVER[:-1] if args.SERVER[-1:] == "/" else args.SERVER
TOKEN = args.TOKEN
HEADERS = {"Genestack-API-Token": TOKEN,
           "accept": "application/json",
           "Content-Type": "application/json"}
SESSION = authenticate()
TEMPLATE_ACCESSION = args.TEMPLATE_ACCESSION if args.TEMPLATE_ACCESSION else get_template()
STUDY = add_study(study_link=args.study_link, study_accession=args.study_accession)

signals = create_signal_file_dict(sys.argv, args.data)
for sample, signals in signals.items():
    if sample.find("GSF") == -1:
        samples = add_and_link_samples(sample_link=sample)
    else:
        samples = get_samples_by_parent_accession(sample)
    if samples:
        add_odm_project(sample_accessions=samples,
                        signals_list=signals)

print(green_text(u"Execution is finished!"))
