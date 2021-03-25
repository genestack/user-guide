# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


StudyValidationSummary <- R6::R6Class(
  'StudyValidationSummary',
  public = list(
    `_raw_json` = NULL,

    `samples` = NULL,
    initialize = function(`samples`){
      if (!missing(`samples`)) {
        stopifnot(is.list(`samples`), length(`samples`) != 0)
        lapply(`samples`, function(x) stopifnot(R6::is.R6(x)))
        self$`samples` <- `samples`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      StudyValidationSummaryObject <- list()
      if (!is.null(self$`samples`)) {
        StudyValidationSummaryObject[['samples']] <- lapply(self$`samples`, function(x) x$toJSON())
      }

      StudyValidationSummaryObject
    },
    fromJSON = function(StudyValidationSummaryJson) {
      self$`_raw_json` <- StudyValidationSummaryJson

      StudyValidationSummaryObject <- jsonlite::fromJSON(StudyValidationSummaryJson)
      if (!is.null(StudyValidationSummaryObject$`samples`)) {
        self$`samples` <- lapply(StudyValidationSummaryObject$`samples`, function(x) {
          samplesObject <- GroupValidationSummary$new()
          samplesObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          samplesObject
        })
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "samples": [%s]
        }',
        lapply(self$`samples`, function(x) paste(x$toJSON(), sep=","))
      )
    },
    fromJSONString = function(StudyValidationSummaryJson) {
      self$`_raw_json` <- StudyValidationSummaryJson

      StudyValidationSummaryObject <- jsonlite::fromJSON(StudyValidationSummaryJson)
      self$`samples` <- lapply(StudyValidationSummaryObject$`samples`, function(x) GroupValidationSummary$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
    }
  )
)
