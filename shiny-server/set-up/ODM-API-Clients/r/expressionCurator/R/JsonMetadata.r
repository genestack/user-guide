# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the expressionCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


JsonMetadata <- R6::R6Class(
  'JsonMetadata',
  public = list(
    `_raw_json` = NULL,

    `attributes` = NULL,
    initialize = function(`attributes`){
      if (!missing(`attributes`)) {
        stopifnot(R6::is.R6(`attributes`))
        self$`attributes` <- `attributes`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      JsonMetadataObject <- list()
      if (!is.null(self$`attributes`)) {
        JsonMetadataObject[['attributes']] <- self$`attributes`$toJSON()
      }

      JsonMetadataObject
    },
    fromJSON = function(JsonMetadataJson) {
      self$`_raw_json` <- JsonMetadataJson

      JsonMetadataObject <- jsonlite::fromJSON(JsonMetadataJson)
      if (!is.null(JsonMetadataObject$`attributes`)) {
        attributesObject <- TODO_OBJECT_MAPPING$new()
        attributesObject$fromJSON(jsonlite::toJSON(JsonMetadataObject$attributes, auto_unbox = TRUE))
        self$`attributes` <- attributesObject
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "attributes": %s
        }',
                self$`attributes`$toJSON()
            
      )
    },
    fromJSONString = function(JsonMetadataJson) {
      self$`_raw_json` <- JsonMetadataJson

      JsonMetadataObject <- jsonlite::fromJSON(JsonMetadataJson)
      TODO_OBJECT_MAPPINGObject <- TODO_OBJECT_MAPPING$new()
      self$`attributes` <- TODO_OBJECT_MAPPINGObject$fromJSON(jsonlite::toJSON(JsonMetadataObject$attributes, auto_unbox = TRUE))
    }
  )
)
