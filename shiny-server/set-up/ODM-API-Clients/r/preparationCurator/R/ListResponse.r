# Roche pRed Layers 3
# 
# This swagger page describes the preparationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


ListResponse <- R6::R6Class(
  'ListResponse',
  public = list(
    `_raw_json` = NULL,

    `data` = NULL,
    `meta` = NULL,
    initialize = function(`data`, `meta`){
      if (!missing(`data`)) {
        stopifnot(is.list(`data`), length(`data`) != 0)
        lapply(`data`, function(x) stopifnot(R6::is.R6(x)))
        self$`data` <- `data`
      }
      if (!missing(`meta`)) {
        stopifnot(R6::is.R6(`meta`))
        self$`meta` <- `meta`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      ListResponseObject <- list()
      if (!is.null(self$`data`)) {
        ListResponseObject[['data']] <- lapply(self$`data`, function(x) x$toJSON())
      }
      if (!is.null(self$`meta`)) {
        ListResponseObject[['meta']] <- self$`meta`$toJSON()
      }

      ListResponseObject
    },
    fromJSON = function(ListResponseJson) {
      self$`_raw_json` <- ListResponseJson

      ListResponseObject <- jsonlite::fromJSON(ListResponseJson)
      if (!is.null(ListResponseObject$`data`)) {
        self$`data` <- lapply(ListResponseObject$`data`, function(x) {
          dataObject <- TODO_OBJECT_MAPPING$new()
          dataObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          dataObject
        })
      }
      if (!is.null(ListResponseObject$`meta`)) {
        metaObject <- MetaResponse$new()
        metaObject$fromJSON(jsonlite::toJSON(ListResponseObject$meta, auto_unbox = TRUE))
        self$`meta` <- metaObject
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "data": [%s],
           "meta": %s
        }',
        lapply(self$`data`, function(x) paste(x$toJSON(), sep=",")),
                self$`meta`$toJSON()
            
      )
    },
    fromJSONString = function(ListResponseJson) {
      self$`_raw_json` <- ListResponseJson

      ListResponseObject <- jsonlite::fromJSON(ListResponseJson)
      self$`data` <- lapply(ListResponseObject$`data`, function(x) TODO_OBJECT_MAPPING$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      MetaResponseObject <- MetaResponse$new()
      self$`meta` <- MetaResponseObject$fromJSON(jsonlite::toJSON(ListResponseObject$meta, auto_unbox = TRUE))
    }
  )
)
