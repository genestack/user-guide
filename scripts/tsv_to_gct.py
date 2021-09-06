import argparse
import csv
import os


GENE_HEADER = 'gene_id'


def create_gct_file(tsv_filename):
    content = dict()
    with open(tsv_filename) as f:
        reader = csv.reader(f, delimiter='\t')
        headers = next(reader)
        line_count = 0
        for row in reader:
            line_count += 1
            for header, value in zip(headers, row):
                vector = content.get(header, list())
                vector.append(value)
                content[header] = vector
    # print(len(content[GENE_HEADER]))
    n_rows = line_count
    n_cols = len(headers) - 2
    filename, file_extension = os.path.splitext(tsv_filename)
    with open(filename + '.gct', 'w') as f:
        f.write('#1.2\n')
        f.write('{rows}\t{samples}\n'.format(rows=n_rows, samples=n_cols))
        f.write('NAME\tDescription\t{}\n'.format('\t'.join(headers[2:])))
        for index in range(0, n_rows):
            name = content[GENE_HEADER][index]
            f.write('{}\t{}\t{}\n'.format(name, '', '\t'.join([content[header][index] for header in headers[2:]])))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--tsv_file', type=str, help='Path to the TSV-file with gene expression values', required=True)
    args = parser.parse_args()
    create_gct_file(args.tsv_file)


if __name__ == "__main__":
    main()
