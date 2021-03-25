# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the variantUser API endpoints for ODM. These are typically used to find and retrieve variant data and metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 


MetaResponse <- R6::R6Class(
  'MetaResponse',
  public = list(
    `_raw_json` = NULL,

    `pagination` = NULL,
    initialize = function(`pagination`){
      if (!missing(`pagination`)) {
        stopifnot(R6::is.R6(`pagination`))
        self$`pagination` <- `pagination`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      MetaResponseObject <- list()
      if (!is.null(self$`pagination`)) {
        MetaResponseObject[['pagination']] <- self$`pagination`$toJSON()
      }

      MetaResponseObject
    },
    fromJSON = function(MetaResponseJson) {
      self$`_raw_json` <- MetaResponseJson

      MetaResponseObject <- jsonlite::fromJSON(MetaResponseJson)
      if (!is.null(MetaResponseObject$`pagination`)) {
        paginationObject <- PaginationInfo$new()
        paginationObject$fromJSON(jsonlite::toJSON(MetaResponseObject$pagination, auto_unbox = TRUE))
        self$`pagination` <- paginationObject
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "pagination": %s
        }',
                self$`pagination`$toJSON()
            
      )
    },
    fromJSONString = function(MetaResponseJson) {
      self$`_raw_json` <- MetaResponseJson

      MetaResponseObject <- jsonlite::fromJSON(MetaResponseJson)
      PaginationInfoObject <- PaginationInfo$new()
      self$`pagination` <- PaginationInfoObject$fromJSON(jsonlite::toJSON(MetaResponseObject$pagination, auto_unbox = TRUE))
    }
  )
)
