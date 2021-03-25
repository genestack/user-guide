# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


GroupValidationSummary <- R6::R6Class(
  'GroupValidationSummary',
  public = list(
    `_raw_json` = NULL,

    `attributes` = NULL,
    `groupAccession` = NULL,
    initialize = function(`attributes`, `groupAccession`){
      if (!missing(`attributes`)) {
        stopifnot(is.list(`attributes`), length(`attributes`) != 0)
        lapply(`attributes`, function(x) stopifnot(R6::is.R6(x)))
        self$`attributes` <- `attributes`
      }
      if (!missing(`groupAccession`)) {
        stopifnot(is.character(`groupAccession`), length(`groupAccession`) == 1)
        self$`groupAccession` <- `groupAccession`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      GroupValidationSummaryObject <- list()
      if (!is.null(self$`attributes`)) {
        GroupValidationSummaryObject[['attributes']] <- lapply(self$`attributes`, function(x) x$toJSON())
      }
      if (!is.null(self$`groupAccession`)) {
        GroupValidationSummaryObject[['groupAccession']] <- self$`groupAccession`
      }

      GroupValidationSummaryObject
    },
    fromJSON = function(GroupValidationSummaryJson) {
      self$`_raw_json` <- GroupValidationSummaryJson

      GroupValidationSummaryObject <- jsonlite::fromJSON(GroupValidationSummaryJson)
      if (!is.null(GroupValidationSummaryObject$`attributes`)) {
        self$`attributes` <- lapply(GroupValidationSummaryObject$`attributes`, function(x) {
          attributesObject <- AttributeValidationSummary$new()
          attributesObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          attributesObject
        })
      }
      if (!is.null(GroupValidationSummaryObject$`groupAccession`)) {
        self$`groupAccession` <- GroupValidationSummaryObject$`groupAccession`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "attributes": [%s],
           "groupAccession": %s
        }',
        lapply(self$`attributes`, function(x) paste(x$toJSON(), sep=",")),
                if (is.null(self$`groupAccession`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`groupAccession`)
                }
            
      )
    },
    fromJSONString = function(GroupValidationSummaryJson) {
      self$`_raw_json` <- GroupValidationSummaryJson

      GroupValidationSummaryObject <- jsonlite::fromJSON(GroupValidationSummaryJson)
      self$`attributes` <- lapply(GroupValidationSummaryObject$`attributes`, function(x) AttributeValidationSummary$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      self$`groupAccession` <- GroupValidationSummaryObject$`groupAccession`
    }
  )
)
