# Script for uploading data and metadata to ODM and S3 storage

## Install dependencies

You need to install boto3 & paramiko.

## Prepare study and samples metadata

Study and sample metadata files should be prepared as described in ODM documentation.
It is expected that study metadata contains `Study Source ID`, `Study Source`, `Study Title`,
`Study Type` and `Study Description` columns.

Example:
```
>cat 300460.study.tsv
Study Source	Study Source ID	Study Description	Study Type
Source	Study ID 1	Just an example	Unknown
```
Samples metadata should contain `Sample Source ID` column.
Sftp urls should use the prefix `sftp://`. You can put several values in one cell,
using `|` as a delimiter. By default we assume that sftp links for the raw data are in the column `Data Files / Raw`.

Example:
```
>cat 300460.samples.10.tsv
Sample Source ID	Sample Source	Data Files / Raw
A1	300460	sftp://185.106.248.149:2222/300460/trimming/A1/R1.fastq.gz
A2	300460	sftp://185.106.248.149:2222/300460/trimming/A2/R1.fastq.gz
A3	300460	sftp://185.106.248.149:2222/300460/trimming/A3/R1.fastq.gz
A4	300460	sftp://185.106.248.149:2222/300460/trimming/A4/R1.fastq.gz
B1	300460	sftp://185.106.248.149:2222/300460/trimming/B1/R1.fastq.gz
B2	300460	sftp://185.106.248.149:2222/300460/trimming/B2/R1.fastq.gz
B3	300460	sftp://185.106.248.149:2222/300460/trimming/B3/R1.fastq.gz
B4	300460	sftp://185.106.248.149:2222/300460/trimming/B4/R1.fastq.gz
C1	300460	sftp://185.106.248.149:2222/300460/trimming/C1/R1.fastq.gz
C2	300460	sftp://185.106.248.149:2222/300460/trimming/C2/R1.fastq.gz
```

You can use another name for the column with your links, if you want, but in that case you need explicitly specify the name
when you are invoking the script (see examples later).

```
>cat sftp_example.samples.tsv
Sample Source ID	genestack.bio:hasPairedReads	url
Example Source ID 1	False	sftp://test.rebex.net:22/pub/example/KeyGenerator.png|sftp://test.rebex.net:22/pub/example/mail-editor.png
Example Source ID 2	False	sftp://test.rebex.net:22/pub/example/mail-editor.png
Example Source ID 3	False	sftp://test.rebex.net:22/pub/example/mail-send-winforms.png
Example Source ID 4	False	sftp://test.rebex.net:22/pub/example/pocketftp.png
Example Source ID 5	False	sftp://test.rebex.net:22/pub/example/pocketftpSmall.png|sftp://test.rebex.net:22/pub/example/pocketftp.png
```

## Check all the sftp urls in the metadata using `check_sftp_links.py`

You need to specify SFTP credentials in a JSON-file, let's name it `sftp_cred.json`

```bash
cat sftp_cred.json
{
	"username": "demo",
	"password": "password"
}
```

The script reads sftp urls from the specified columns (by default it takes 'Data Files / Raw' and 'Data Files / Processed' columns) and
checks that the corresponding files exist on the sftp-server.

```
>python check_sftp_links.py --metadata 300460.samples.10.tsv --sftp ftp_cred.json
There are no columns with the following names: ['Data Files / Processed']
The following columns will be checked: ['Data Files / Raw']
 sftp-links=10 all sftp-links=10 time=1.60 sftp-links processed/sec=6.25 done=1.00
There are 10 files on sftp with total size 4449709431 (4243.57Mb/4.14Gb)
```

If you use a custom name for you column with sftp links, you need to provide the name as an argument.
```
>python check_sftp_links.py --metadata samples_example_sftp.tsv --sftp ftp_cred.json --field 'url'
The following columns will be checked: ['url']
 sftp-links=5 all sftp-links=5 time=1.56 sftp-links processed/sec=3.21 done=1.00
There are 5 files on sftp with total size 241273
```

## Upload study and samples metadata to ODM using `upload_local_study_to_odm.py`

Thuis script will create a study, uploads and links samples metadata to the study and return the accession
of the newly created study.
Example:
```bash
>python upload_local_study_to_odm.py --srv https://qa.magnum.genestack.com/ --study study_example_sftp.tsv --samples samples_example_sftp.tsv --token <token>
GSF013296
```
NB: The samples metadata still contains sftp urls at this point.

## Move files from sftp-server to S3 storage and replace the urls in the metadata

You need to specify AWS credentials in a JSON-file, let's name it `aws_cred.json`
There are two S3 buckets: `gs-saas-magnum-qa` and `gs-saas-magnum-qa`. It make sense to have
two separated files.

```bash
cat aws_cred.qa.json
{
	"s3_bucket_name": "gs-saas-magnum-qa",
	"aws_server_public_key": "<Public Key>",
	"aws_server_secret_key": "<Secret Key>",
	"region_name": "eu-central-1"
}
```

```bash
cat aws_cred.prod.json
{
	"s3_bucket_name": "gs-saas-magnum-prod",
	"aws_server_public_key": "<Public Key>",
	"aws_server_secret_key": "<Secret Key>",
	"region_name": "eu-central-1"
}
```

The script `sftp2s3_odm.py` will select column with the given name and for each sftp-links in that column copies the corresponding file
to S3 storage and replace the link with a new link to S3 storage.
The S3 key is constructed using the accession of the study and the file path on the sftp server.
For example, for the sftp url `sftp://host.com:1234/dirA/dirB/fileC` and for the study `GSF013296`
the corresponding s3 url will be `s3://<bucket>/GSF013296/dirA/dirB/fileC`.

This script can take a long time to finish the execution and in case of network problems, for example,
it is safe to restart the script with the same arguments several times until there will be no sftp urls to process.

```
>python sftp2s3_odm.py --srv  https://qa.magnum.genestack.com/ --study_accession GSF013296 --s3 aws_cred.qa.json --sftp ftp_cred.json --token <token> --field 'url'
There are 5 sftp urls in 5 samples to process
 processed: 5 of 5 samples, time=20.60 samples/sec=0.24 done=1.00 /pub/example/pocketftpSmall.png speed 4.21 kb/sb
The number of changed sftp urls: 7
```
## Check s3 urls in the samples metadata in ODM
The script `check_s3_urls.py` will inspect all the s3 urls in the specified columns and will check the existence of the corresponding files.
```
>python check_s3_urls.py --srv  https://qa.magnum.genestack.com/ --study_accession GSF013296 --s3 aws_cred.qa.json  --token tknPublic123 --field 'url'
There are 5 s3 urls in 5 samples to process
 processed: 5 of 5 samples, time=1.89 samples/sec=2.64 done=1.00
There are 5 s3 urls with total size 241273
```

```
>python check_s3_urls.py --srv  https://prod.magnum.genestack.com/ --study_accession GSF000652 --s3 aws_cred.prod.json  --token <token>
There are 2055 s3 urls in 2055 samples to process
 processed: 2055 of 2055 samples, time=743.78 samples/sec=2.76 done=1.00
There are 2055 s3 urls with total size 498217096548 (475136.85Mb/464.00Gb)
```

## Some notes on the implementation
By default, script will download one file a time to a temporary file in the working directory and then immediately upload it to S3.
It means that you need to be sure that the working directory has a free space (at least about 0.5Gb).
The other options to use fully in-memory solution (see `--in_memory` flag for `sftp2s3_odm`), but it is slower by a factor of 5.

For 40 files with total size 16.82Gb it takes approximately 1 hour 40 minutes to copy files from sftp to s3.
