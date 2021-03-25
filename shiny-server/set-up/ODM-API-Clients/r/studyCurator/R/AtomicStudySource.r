# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the studyCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


AtomicStudySource <- R6::R6Class(
  'AtomicStudySource',
  public = list(
    `_raw_json` = NULL,

    `metadata` = NULL,
    `templateId` = NULL,
    initialize = function(`metadata`, `templateId`){
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
      }
      if (!missing(`templateId`)) {
        stopifnot(is.character(`templateId`), length(`templateId`) == 1)
        self$`templateId` <- `templateId`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      AtomicStudySourceObject <- list()
      if (!is.null(self$`metadata`)) {
        AtomicStudySourceObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`templateId`)) {
        AtomicStudySourceObject[['templateId']] <- self$`templateId`
      }

      AtomicStudySourceObject
    },
    fromJSON = function(AtomicStudySourceJson) {
      self$`_raw_json` <- AtomicStudySourceJson

      AtomicStudySourceObject <- jsonlite::fromJSON(AtomicStudySourceJson)
      if (!is.null(AtomicStudySourceObject$`metadata`)) {
        metadataObject <- JsonMetadata$new()
        metadataObject$fromJSON(jsonlite::toJSON(AtomicStudySourceObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(AtomicStudySourceObject$`templateId`)) {
        self$`templateId` <- AtomicStudySourceObject$`templateId`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "metadata": %s,
           "templateId": %s
        }',
                self$`metadata`$toJSON()
            ,
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            
      )
    },
    fromJSONString = function(AtomicStudySourceJson) {
      self$`_raw_json` <- AtomicStudySourceJson

      AtomicStudySourceObject <- jsonlite::fromJSON(AtomicStudySourceJson)
      JsonMetadataObject <- JsonMetadata$new()
      self$`metadata` <- JsonMetadataObject$fromJSON(jsonlite::toJSON(AtomicStudySourceObject$metadata, auto_unbox = TRUE))
      self$`templateId` <- AtomicStudySourceObject$`templateId`
    }
  )
)
