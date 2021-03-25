# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


MetadataWithId <- R6::R6Class(
  'MetadataWithId',
  public = list(
    `_raw_json` = NULL,

    `itemId` = NULL,
    `metadata` = NULL,
    initialize = function(`itemId`, `metadata`){
      if (!missing(`itemId`)) {
        stopifnot(is.character(`itemId`), length(`itemId`) == 1)
        self$`itemId` <- `itemId`
      }
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      MetadataWithIdObject <- list()
      if (!is.null(self$`itemId`)) {
        MetadataWithIdObject[['itemId']] <- self$`itemId`
      }
      if (!is.null(self$`metadata`)) {
        MetadataWithIdObject[['metadata']] <- self$`metadata`$toJSON()
      }

      MetadataWithIdObject
    },
    fromJSON = function(MetadataWithIdJson) {
      self$`_raw_json` <- MetadataWithIdJson

      MetadataWithIdObject <- jsonlite::fromJSON(MetadataWithIdJson)
      if (!is.null(MetadataWithIdObject$`itemId`)) {
        self$`itemId` <- MetadataWithIdObject$`itemId`
      }
      if (!is.null(MetadataWithIdObject$`metadata`)) {
        metadataObject <- MetadataContent$new()
        metadataObject$fromJSON(jsonlite::toJSON(MetadataWithIdObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "itemId": %s,
           "metadata": %s
        }',
                if (is.null(self$`itemId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`itemId`)
                }
            ,
                self$`metadata`$toJSON()
            
      )
    },
    fromJSONString = function(MetadataWithIdJson) {
      self$`_raw_json` <- MetadataWithIdJson

      MetadataWithIdObject <- jsonlite::fromJSON(MetadataWithIdJson)
      self$`itemId` <- MetadataWithIdObject$`itemId`
      MetadataContentObject <- MetadataContent$new()
      self$`metadata` <- MetadataContentObject$fromJSON(jsonlite::toJSON(MetadataWithIdObject$metadata, auto_unbox = TRUE))
    }
  )
)
