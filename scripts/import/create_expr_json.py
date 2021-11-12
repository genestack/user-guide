import csv
import json
import sys


def read_one_tsv_file(filename):
    with open(filename) as f:
        reader = csv.reader(f, delimiter='\t')
        headers = next(reader)
        row = next(reader)
        result = dict()
        for key, value in zip(headers, row):
            result[key] = value
    return result


def read_tsv_files(tsv_files):
    result = list()
    for tsv_file in tsv_files:
        tsv_dict = read_one_tsv_file(tsv_file)
        result.append(tsv_dict)
    return result


def main():
    tsv_files = sys.argv[1:]
    content = read_tsv_files(tsv_files)
    print(json.dumps(content, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
