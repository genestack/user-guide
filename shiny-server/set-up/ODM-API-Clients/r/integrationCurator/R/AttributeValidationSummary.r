# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


AttributeValidationSummary <- R6::R6Class(
  'AttributeValidationSummary',
  public = list(
    `_raw_json` = NULL,

    `attributeInvalidValues` = NULL,
    `attributeName` = NULL,
    initialize = function(`attributeInvalidValues`, `attributeName`){
      if (!missing(`attributeInvalidValues`)) {
        stopifnot(is.list(`attributeInvalidValues`), length(`attributeInvalidValues`) != 0)
        lapply(`attributeInvalidValues`, function(x) stopifnot(R6::is.R6(x)))
        self$`attributeInvalidValues` <- `attributeInvalidValues`
      }
      if (!missing(`attributeName`)) {
        stopifnot(is.character(`attributeName`), length(`attributeName`) == 1)
        self$`attributeName` <- `attributeName`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      AttributeValidationSummaryObject <- list()
      if (!is.null(self$`attributeInvalidValues`)) {
        AttributeValidationSummaryObject[['attributeInvalidValues']] <- lapply(self$`attributeInvalidValues`, function(x) x$toJSON())
      }
      if (!is.null(self$`attributeName`)) {
        AttributeValidationSummaryObject[['attributeName']] <- self$`attributeName`
      }

      AttributeValidationSummaryObject
    },
    fromJSON = function(AttributeValidationSummaryJson) {
      self$`_raw_json` <- AttributeValidationSummaryJson

      AttributeValidationSummaryObject <- jsonlite::fromJSON(AttributeValidationSummaryJson)
      if (!is.null(AttributeValidationSummaryObject$`attributeInvalidValues`)) {
        self$`attributeInvalidValues` <- lapply(AttributeValidationSummaryObject$`attributeInvalidValues`, function(x) {
          attributeInvalidValuesObject <- AttributeInvalidValue$new()
          attributeInvalidValuesObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          attributeInvalidValuesObject
        })
      }
      if (!is.null(AttributeValidationSummaryObject$`attributeName`)) {
        self$`attributeName` <- AttributeValidationSummaryObject$`attributeName`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "attributeInvalidValues": [%s],
           "attributeName": %s
        }',
        lapply(self$`attributeInvalidValues`, function(x) paste(x$toJSON(), sep=",")),
                if (is.null(self$`attributeName`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`attributeName`)
                }
            
      )
    },
    fromJSONString = function(AttributeValidationSummaryJson) {
      self$`_raw_json` <- AttributeValidationSummaryJson

      AttributeValidationSummaryObject <- jsonlite::fromJSON(AttributeValidationSummaryJson)
      self$`attributeInvalidValues` <- lapply(AttributeValidationSummaryObject$`attributeInvalidValues`, function(x) AttributeInvalidValue$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      self$`attributeName` <- AttributeValidationSummaryObject$`attributeName`
    }
  )
)
