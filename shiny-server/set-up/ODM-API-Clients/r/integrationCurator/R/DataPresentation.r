# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


DataPresentation <- R6::R6Class(
  'DataPresentation',
  public = list(
    `_raw_json` = NULL,

    `relationships` = NULL,
    initialize = function(`relationships`){
      if (!missing(`relationships`)) {
        stopifnot(R6::is.R6(`relationships`))
        self$`relationships` <- `relationships`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      DataPresentationObject <- list()
      if (!is.null(self$`relationships`)) {
        DataPresentationObject[['relationships']] <- self$`relationships`$toJSON()
      }

      DataPresentationObject
    },
    fromJSON = function(DataPresentationJson) {
      self$`_raw_json` <- DataPresentationJson

      DataPresentationObject <- jsonlite::fromJSON(DataPresentationJson)
      if (!is.null(DataPresentationObject$`relationships`)) {
        relationshipsObject <- Relationships$new()
        relationshipsObject$fromJSON(jsonlite::toJSON(DataPresentationObject$relationships, auto_unbox = TRUE))
        self$`relationships` <- relationshipsObject
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "relationships": %s
        }',
                self$`relationships`$toJSON()
            
      )
    },
    fromJSONString = function(DataPresentationJson) {
      self$`_raw_json` <- DataPresentationJson

      DataPresentationObject <- jsonlite::fromJSON(DataPresentationJson)
      RelationshipsObject <- Relationships$new()
      self$`relationships` <- RelationshipsObject$fromJSON(jsonlite::toJSON(DataPresentationObject$relationships, auto_unbox = TRUE))
    }
  )
)
