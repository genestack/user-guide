# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the variantCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


VariantResponse <- R6::R6Class(
  'VariantResponse',
  public = list(
    `_raw_json` = NULL,

    `cursor` = NULL,
    `data` = NULL,
    initialize = function(`cursor`, `data`){
      if (!missing(`cursor`)) {
        stopifnot(is.character(`cursor`), length(`cursor`) == 1)
        self$`cursor` <- `cursor`
      }
      if (!missing(`data`)) {
        stopifnot(is.list(`data`), length(`data`) != 0)
        lapply(`data`, function(x) stopifnot(R6::is.R6(x)))
        self$`data` <- `data`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      VariantResponseObject <- list()
      if (!is.null(self$`cursor`)) {
        VariantResponseObject[['cursor']] <- self$`cursor`
      }
      if (!is.null(self$`data`)) {
        VariantResponseObject[['data']] <- lapply(self$`data`, function(x) x$toJSON())
      }

      VariantResponseObject
    },
    fromJSON = function(VariantResponseJson) {
      self$`_raw_json` <- VariantResponseJson

      VariantResponseObject <- jsonlite::fromJSON(VariantResponseJson)
      if (!is.null(VariantResponseObject$`cursor`)) {
        self$`cursor` <- VariantResponseObject$`cursor`
      }
      if (!is.null(VariantResponseObject$`data`)) {
        self$`data` <- lapply(VariantResponseObject$`data`, function(x) {
          dataObject <- VariantItem$new()
          dataObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          dataObject
        })
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "cursor": %s,
           "data": [%s]
        }',
                if (is.null(self$`cursor`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`cursor`)
                }
            ,
        lapply(self$`data`, function(x) paste(x$toJSON(), sep=","))
      )
    },
    fromJSONString = function(VariantResponseJson) {
      self$`_raw_json` <- VariantResponseJson

      VariantResponseObject <- jsonlite::fromJSON(VariantResponseJson)
      self$`cursor` <- VariantResponseObject$`cursor`
      self$`data` <- lapply(VariantResponseObject$`data`, function(x) VariantItem$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
    }
  )
)