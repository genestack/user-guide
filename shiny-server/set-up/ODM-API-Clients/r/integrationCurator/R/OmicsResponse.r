# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


OmicsResponse <- R6::R6Class(
  'OmicsResponse',
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

      OmicsResponseObject <- list()
      if (!is.null(self$`cursor`)) {
        OmicsResponseObject[['cursor']] <- self$`cursor`
      }
      if (!is.null(self$`data`)) {
        OmicsResponseObject[['data']] <- lapply(self$`data`, function(x) x$toJSON())
      }
      if (!is.null(self$`log`)) {
        OmicsResponseObject[['log']] <- self$`log`
      }
      if (!is.null(self$`resultsExhausted`)) {
        OmicsResponseObject[['resultsExhausted']] <- self$`resultsExhausted`
      }
      if (!is.null(self$`studiesMatchingQuery`)) {
        OmicsResponseObject[['studiesMatchingQuery']] <- self$`studiesMatchingQuery`
      }

      OmicsResponseObject
    },
    fromJSON = function(OmicsResponseJson) {
      self$`_raw_json` <- OmicsResponseJson

      OmicsResponseObject <- jsonlite::fromJSON(OmicsResponseJson)
      if (!is.null(OmicsResponseObject$`cursor`)) {
        self$`cursor` <- OmicsResponseObject$`cursor`
      }
      if (!is.null(OmicsResponseObject$`data`)) {
        self$`data` <- lapply(OmicsResponseObject$`data`, function(x) {
          dataObject <- TODO_OBJECT_MAPPING$new()
          dataObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          dataObject
        })
      }
      if (!is.null(OmicsResponseObject$`log`)) {
        self$`log` <- OmicsResponseObject$`log`
      }
      if (!is.null(OmicsResponseObject$`resultsExhausted`)) {
        self$`resultsExhausted` <- OmicsResponseObject$`resultsExhausted`
      }
      if (!is.null(OmicsResponseObject$`studiesMatchingQuery`)) {
        self$`studiesMatchingQuery` <- OmicsResponseObject$`studiesMatchingQuery`
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
    fromJSONString = function(OmicsResponseJson) {
      self$`_raw_json` <- OmicsResponseJson

      OmicsResponseObject <- jsonlite::fromJSON(OmicsResponseJson)
      self$`cursor` <- OmicsResponseObject$`cursor`
      self$`data` <- lapply(OmicsResponseObject$`data`, function(x) TODO_OBJECT_MAPPING$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      self$`log` <- OmicsResponseObject$`log`
      self$`resultsExhausted` <- OmicsResponseObject$`resultsExhausted`
      self$`studiesMatchingQuery` <- OmicsResponseObject$`studiesMatchingQuery`
    }
  )
)
