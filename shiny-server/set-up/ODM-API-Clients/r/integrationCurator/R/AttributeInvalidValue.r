# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


AttributeInvalidValue <- R6::R6Class(
  'AttributeInvalidValue',
  public = list(
    `_raw_json` = NULL,

    `count` = NULL,
    `errors` = NULL,
    `value` = NULL,
    initialize = function(`count`, `errors`, `value`){
      if (!missing(`count`)) {
        stopifnot(is.numeric(`count`), length(`count`) == 1)
        self$`count` <- `count`
      }
      if (!missing(`errors`)) {
        stopifnot(is.list(`errors`), length(`errors`) != 0)
        lapply(`errors`, function(x) stopifnot(R6::is.R6(x)))
        self$`errors` <- `errors`
      }
      if (!missing(`value`)) {
        stopifnot(R6::is.R6(`value`))
        self$`value` <- `value`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      AttributeInvalidValueObject <- list()
      if (!is.null(self$`count`)) {
        AttributeInvalidValueObject[['count']] <- self$`count`
      }
      if (!is.null(self$`errors`)) {
        AttributeInvalidValueObject[['errors']] <- lapply(self$`errors`, function(x) x$toJSON())
      }
      if (!is.null(self$`value`)) {
        AttributeInvalidValueObject[['value']] <- self$`value`$toJSON()
      }

      AttributeInvalidValueObject
    },
    fromJSON = function(AttributeInvalidValueJson) {
      self$`_raw_json` <- AttributeInvalidValueJson

      AttributeInvalidValueObject <- jsonlite::fromJSON(AttributeInvalidValueJson)
      if (!is.null(AttributeInvalidValueObject$`count`)) {
        self$`count` <- AttributeInvalidValueObject$`count`
      }
      if (!is.null(AttributeInvalidValueObject$`errors`)) {
        self$`errors` <- lapply(AttributeInvalidValueObject$`errors`, function(x) {
          errorsObject <- ValidationError$new()
          errorsObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          errorsObject
        })
      }
      if (!is.null(AttributeInvalidValueObject$`value`)) {
        valueObject <- TODO_OBJECT_MAPPING$new()
        valueObject$fromJSON(jsonlite::toJSON(AttributeInvalidValueObject$value, auto_unbox = TRUE))
        self$`value` <- valueObject
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "count": %d,
           "errors": [%s],
           "value": %s
        }',
                if (is.null(self$`count`)) {
                    'null'
                } else {
                        self$`count`
                }
            ,
        lapply(self$`errors`, function(x) paste(x$toJSON(), sep=",")),
                self$`value`$toJSON()
            
      )
    },
    fromJSONString = function(AttributeInvalidValueJson) {
      self$`_raw_json` <- AttributeInvalidValueJson

      AttributeInvalidValueObject <- jsonlite::fromJSON(AttributeInvalidValueJson)
      self$`count` <- AttributeInvalidValueObject$`count`
      self$`errors` <- lapply(AttributeInvalidValueObject$`errors`, function(x) ValidationError$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      TODO_OBJECT_MAPPINGObject <- TODO_OBJECT_MAPPING$new()
      self$`value` <- TODO_OBJECT_MAPPINGObject$fromJSON(jsonlite::toJSON(AttributeInvalidValueObject$value, auto_unbox = TRUE))
    }
  )
)
