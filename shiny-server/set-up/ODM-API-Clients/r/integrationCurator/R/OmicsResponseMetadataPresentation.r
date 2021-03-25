# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


OmicsResponseMetadataPresentation <- R6::R6Class(
  'OmicsResponseMetadataPresentation',
  public = list(
    `_raw_json` = NULL,

    `cursor` = NULL,
    `data` = NULL,
    `log` = NULL,
    `resultsExhausted` = NULL,
    `studiesMatchingQuery` = NULL,
    initialize = function(`cursor`, `data`, `log`, `resultsExhausted`, `studiesMatchingQuery`){
      if (!missing(`cursor`)) {
        stopifnot(is.character(`cursor`), length(`cursor`) == 1)
        self$`cursor` <- `cursor`
      }
      if (!missing(`data`)) {
        stopifnot(is.list(`data`), length(`data`) != 0)
        lapply(`data`, function(x) stopifnot(R6::is.R6(x)))
        self$`data` <- `data`
      }
      if (!missing(`log`)) {
        stopifnot(is.list(`log`), length(`log`) != 0)
        lapply(`log`, function(x) stopifnot(is.character(x)))
        self$`log` <- `log`
      }
      if (!missing(`resultsExhausted`)) {
        self$`resultsExhausted` <- `resultsExhausted`
      }
      if (!missing(`studiesMatchingQuery`)) {
        stopifnot(is.numeric(`studiesMatchingQuery`), length(`studiesMatchingQuery`) == 1)
        self$`studiesMatchingQuery` <- `studiesMatchingQuery`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      OmicsResponseMetadataPresentationObject <- list()
      if (!is.null(self$`cursor`)) {
        OmicsResponseMetadataPresentationObject[['cursor']] <- self$`cursor`
      }
      if (!is.null(self$`data`)) {
        OmicsResponseMetadataPresentationObject[['data']] <- lapply(self$`data`, function(x) x$toJSON())
      }
      if (!is.null(self$`log`)) {
        OmicsResponseMetadataPresentationObject[['log']] <- self$`log`
      }
      if (!is.null(self$`resultsExhausted`)) {
        OmicsResponseMetadataPresentationObject[['resultsExhausted']] <- self$`resultsExhausted`
      }
      if (!is.null(self$`studiesMatchingQuery`)) {
        OmicsResponseMetadataPresentationObject[['studiesMatchingQuery']] <- self$`studiesMatchingQuery`
      }

      OmicsResponseMetadataPresentationObject
    },
    fromJSON = function(OmicsResponseMetadataPresentationJson) {
      self$`_raw_json` <- OmicsResponseMetadataPresentationJson

      OmicsResponseMetadataPresentationObject <- jsonlite::fromJSON(OmicsResponseMetadataPresentationJson)
      if (!is.null(OmicsResponseMetadataPresentationObject$`cursor`)) {
        self$`cursor` <- OmicsResponseMetadataPresentationObject$`cursor`
      }
      if (!is.null(OmicsResponseMetadataPresentationObject$`data`)) {
        self$`data` <- lapply(OmicsResponseMetadataPresentationObject$`data`, function(x) {
          dataObject <- MetadataPresentation$new()
          dataObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          dataObject
        })
      }
      if (!is.null(OmicsResponseMetadataPresentationObject$`log`)) {
        self$`log` <- OmicsResponseMetadataPresentationObject$`log`
      }
      if (!is.null(OmicsResponseMetadataPresentationObject$`resultsExhausted`)) {
        self$`resultsExhausted` <- OmicsResponseMetadataPresentationObject$`resultsExhausted`
      }
      if (!is.null(OmicsResponseMetadataPresentationObject$`studiesMatchingQuery`)) {
        self$`studiesMatchingQuery` <- OmicsResponseMetadataPresentationObject$`studiesMatchingQuery`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "cursor": %s,
           "data": [%s],
           "log": [%s],
           "resultsExhausted": %s,
           "studiesMatchingQuery": %d
        }',
                if (is.null(self$`cursor`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`cursor`)
                }
            ,
        lapply(self$`data`, function(x) paste(x$toJSON(), sep=",")),
        lapply(self$`log`, function(x) paste(paste0('"', x, '"'), sep=",")),
                if (is.null(self$`resultsExhausted`)) {
                    'null'
                } else {
                        self$`resultsExhausted`
                }
            ,
                if (is.null(self$`studiesMatchingQuery`)) {
                    'null'
                } else {
                        self$`studiesMatchingQuery`
                }
            
      )
    },
    fromJSONString = function(OmicsResponseMetadataPresentationJson) {
      self$`_raw_json` <- OmicsResponseMetadataPresentationJson

      OmicsResponseMetadataPresentationObject <- jsonlite::fromJSON(OmicsResponseMetadataPresentationJson)
      self$`cursor` <- OmicsResponseMetadataPresentationObject$`cursor`
      self$`data` <- lapply(OmicsResponseMetadataPresentationObject$`data`, function(x) MetadataPresentation$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      self$`log` <- OmicsResponseMetadataPresentationObject$`log`
      self$`resultsExhausted` <- OmicsResponseMetadataPresentationObject$`resultsExhausted`
      self$`studiesMatchingQuery` <- OmicsResponseMetadataPresentationObject$`studiesMatchingQuery`
    }
  )
)
