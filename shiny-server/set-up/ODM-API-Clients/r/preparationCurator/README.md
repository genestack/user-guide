# R library for preparationCurator

This swagger page describes the preparationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.

This package is a library, which allows clients to access the pRed SPoTs and Integration Layer REST APIs from R code.
Please see below for details of how to install and get started.

- API version: v0.1
- Package version: 1.36.0-1

## Installation

### Requirements

You'll need the `devtools` package in order to build the API.
Make sure you have a proper CRAN repository from which you can download packages.

Install the `devtools` package with the following command.
```R
if(!require(devtools)) { install.packages("devtools") }
```

The API client depends on the `httr` package. We support version `3.2.1`.

Install the `httr` package with the following command.
```R
if(!require(httr)) { install.packages("httr") }
```

### Installation of the API package
Make sure you set the working directory to where the API code is located.
Then execute
```R
devtools::document()
devtools::install()
```

## Getting Started
Please follow the [installation procedure](#installation).
Configure your environment variables:

- `PRED_SPOT_HOST` spot host, required
- `PRED_SPOT_TOKEN` access token, required
- `PRED_SPOT_SCHEME` host scheme, default is `https`
- `PRED_SPOT_VERSION` spot version, default is `v0.1`


The package can be loaded for development using:
```R
devtools::load_all()
```

Then you can use APIs as follows:
```R
# Either explicitly set client configuration in R, or use environment variables as described above
host = 'inception-dev.genestack.com'
token = '[API token]'

# Create a client object and an object representing the study SPoT
client  = ApiClient$new(host = host, token = token)
study_api = StudySPoTApi$new(client)
```

We may add a new study:
```R
source = StudySource$new(name = 'R client study',
                         description = 'My programmatically-added study')
response = study_api$add_study(source)

# And check that we receive HTTP CREATED status (201)
require(httr)
print(http_status(response$response)$message)

# And view the added study
print(response$content)
```

And search for it (please allow time for indexing):
```R
queryResult <- study_api$search_objects(query = 'programmatically')

# We may view the response as a parsed R object
print(queryResult$content)

# Or we may view the raw JSON
print(queryResult$json)
```

## Generating documentation/manual
Generate `*.Rd` files with:

```bash
R -e "devtools::document()"
```

and then generate the PDF manual with:

```bash
R CMD Rd2pdf ./ --output=manual.pdf --no-index --no-preview --force
```

## Author



