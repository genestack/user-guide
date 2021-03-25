# Roche pRed Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationUser APIs. These are typically used to find and retrieve study, sample and processed (signal) data and metadata for a given query.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears   The server response will be in the section that follows.
# 
# API version: v0.1
# 


SourceTypePair <- R6::R6Class(
  'SourceTypePair',
  public = list(
    `_raw_json` = NULL,

    `firstType` = NULL,
    `secondType` = NULL,
    initialize = function(`firstType`, `secondType`){
      if (!missing(`firstType`)) {
        stopifnot(is.character(`firstType`), length(`firstType`) == 1)
        self$`firstType` <- `firstType`
      }
      if (!missing(`secondType`)) {
        stopifnot(is.character(`secondType`), length(`secondType`) == 1)
        self$`secondType` <- `secondType`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      SourceTypePairObject <- list()
      if (!is.null(self$`firstType`)) {
        SourceTypePairObject[['firstType']] <- self$`firstType`
      }
      if (!is.null(self$`secondType`)) {
        SourceTypePairObject[['secondType']] <- self$`secondType`
      }

      SourceTypePairObject
    },
    fromJSON = function(SourceTypePairJson) {
      self$`_raw_json` <- SourceTypePairJson

      SourceTypePairObject <- jsonlite::fromJSON(SourceTypePairJson)
      if (!is.null(SourceTypePairObject$`firstType`)) {
        self$`firstType` <- SourceTypePairObject$`firstType`
      }
      if (!is.null(SourceTypePairObject$`secondType`)) {
        self$`secondType` <- SourceTypePairObject$`secondType`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "firstType": %s,
           "secondType": %s
        }',
                if (is.null(self$`firstType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`firstType`)
                }
            ,
                if (is.null(self$`secondType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`secondType`)
                }
            
      )
    },
    fromJSONString = function(SourceTypePairJson) {
      self$`_raw_json` <- SourceTypePairJson

      SourceTypePairObject <- jsonlite::fromJSON(SourceTypePairJson)
      self$`firstType` <- SourceTypePairObject$`firstType`
      self$`secondType` <- SourceTypePairObject$`secondType`
    }
  )
)
