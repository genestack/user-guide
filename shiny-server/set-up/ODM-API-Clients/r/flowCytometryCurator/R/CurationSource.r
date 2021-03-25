# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the flowCytometryCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


CurationSource <- R6::R6Class(
  'CurationSource',
  public = list(
    `_raw_json` = NULL,

    `curated` = NULL,
    initialize = function(`curated`){
      if (!missing(`curated`)) {
        self$`curated` <- `curated`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      CurationSourceObject <- list()
      if (!is.null(self$`curated`)) {
        CurationSourceObject[['curated']] <- self$`curated`
      }

      CurationSourceObject
    },
    fromJSON = function(CurationSourceJson) {
      self$`_raw_json` <- CurationSourceJson

      CurationSourceObject <- jsonlite::fromJSON(CurationSourceJson)
      if (!is.null(CurationSourceObject$`curated`)) {
        self$`curated` <- CurationSourceObject$`curated`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "curated": %s
        }',
                if (is.null(self$`curated`)) {
                    'null'
                } else {
                        self$`curated`
                }
            
      )
    },
    fromJSONString = function(CurationSourceJson) {
      self$`_raw_json` <- CurationSourceJson

      CurationSourceObject <- jsonlite::fromJSON(CurationSourceJson)
      self$`curated` <- CurationSourceObject$`curated`
    }
  )
)
