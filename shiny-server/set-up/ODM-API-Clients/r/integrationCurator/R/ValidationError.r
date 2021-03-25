# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


ValidationError <- R6::R6Class(
  'ValidationError',
  public = list(
    `_raw_json` = NULL,

    `errorMessage` = NULL,
    `errorType` = NULL,
    initialize = function(`errorMessage`, `errorType`){
      if (!missing(`errorMessage`)) {
        stopifnot(is.character(`errorMessage`), length(`errorMessage`) == 1)
        self$`errorMessage` <- `errorMessage`
      }
      if (!missing(`errorType`)) {
        stopifnot(is.character(`errorType`), length(`errorType`) == 1)
        self$`errorType` <- `errorType`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      ValidationErrorObject <- list()
      if (!is.null(self$`errorMessage`)) {
        ValidationErrorObject[['errorMessage']] <- self$`errorMessage`
      }
      if (!is.null(self$`errorType`)) {
        ValidationErrorObject[['errorType']] <- self$`errorType`
      }

      ValidationErrorObject
    },
    fromJSON = function(ValidationErrorJson) {
      self$`_raw_json` <- ValidationErrorJson

      ValidationErrorObject <- jsonlite::fromJSON(ValidationErrorJson)
      if (!is.null(ValidationErrorObject$`errorMessage`)) {
        self$`errorMessage` <- ValidationErrorObject$`errorMessage`
      }
      if (!is.null(ValidationErrorObject$`errorType`)) {
        self$`errorType` <- ValidationErrorObject$`errorType`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "errorMessage": %s,
           "errorType": %s
        }',
                if (is.null(self$`errorMessage`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`errorMessage`)
                }
            ,
                if (is.null(self$`errorType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`errorType`)
                }
            
      )
    },
    fromJSONString = function(ValidationErrorJson) {
      self$`_raw_json` <- ValidationErrorJson

      ValidationErrorObject <- jsonlite::fromJSON(ValidationErrorJson)
      self$`errorMessage` <- ValidationErrorObject$`errorMessage`
      self$`errorType` <- ValidationErrorObject$`errorType`
    }
  )
)
