# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the flowCytometryCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


AtomicFlowCytometrySource <- R6::R6Class(
  'AtomicFlowCytometrySource',
  public = list(
    `_raw_json` = NULL,

    `cell-population` = NULL,
    `marker` = NULL,
    `metadata` = NULL,
    `readout-type` = NULL,
    `templateId` = NULL,
    `value` = NULL,
    initialize = function(`cell-population`, `marker`, `metadata`, `readout-type`, `templateId`, `value`){
      if (!missing(`cell-population`)) {
        stopifnot(is.character(`cell-population`), length(`cell-population`) == 1)
        self$`cell-population` <- `cell-population`
      }
      if (!missing(`marker`)) {
        stopifnot(is.character(`marker`), length(`marker`) == 1)
        self$`marker` <- `marker`
      }
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
      }
      if (!missing(`readout-type`)) {
        stopifnot(is.character(`readout-type`), length(`readout-type`) == 1)
        self$`readout-type` <- `readout-type`
      }
      if (!missing(`templateId`)) {
        stopifnot(is.character(`templateId`), length(`templateId`) == 1)
        self$`templateId` <- `templateId`
      }
      if (!missing(`value`)) {
        stopifnot(is.numeric(`value`), length(`value`) == 1)
        self$`value` <- `value`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      AtomicFlowCytometrySourceObject <- list()
      if (!is.null(self$`cell-population`)) {
        AtomicFlowCytometrySourceObject[['cell-population']] <- self$`cell-population`
      }
      if (!is.null(self$`marker`)) {
        AtomicFlowCytometrySourceObject[['marker']] <- self$`marker`
      }
      if (!is.null(self$`metadata`)) {
        AtomicFlowCytometrySourceObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`readout-type`)) {
        AtomicFlowCytometrySourceObject[['readout-type']] <- self$`readout-type`
      }
      if (!is.null(self$`templateId`)) {
        AtomicFlowCytometrySourceObject[['templateId']] <- self$`templateId`
      }
      if (!is.null(self$`value`)) {
        AtomicFlowCytometrySourceObject[['value']] <- self$`value`
      }

      AtomicFlowCytometrySourceObject
    },
    fromJSON = function(AtomicFlowCytometrySourceJson) {
      self$`_raw_json` <- AtomicFlowCytometrySourceJson

      AtomicFlowCytometrySourceObject <- jsonlite::fromJSON(AtomicFlowCytometrySourceJson)
      if (!is.null(AtomicFlowCytometrySourceObject$`cell-population`)) {
        self$`cell-population` <- AtomicFlowCytometrySourceObject$`cell-population`
      }
      if (!is.null(AtomicFlowCytometrySourceObject$`marker`)) {
        self$`marker` <- AtomicFlowCytometrySourceObject$`marker`
      }
      if (!is.null(AtomicFlowCytometrySourceObject$`metadata`)) {
        metadataObject <- JsonMetadata$new()
        metadataObject$fromJSON(jsonlite::toJSON(AtomicFlowCytometrySourceObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(AtomicFlowCytometrySourceObject$`readout-type`)) {
        self$`readout-type` <- AtomicFlowCytometrySourceObject$`readout-type`
      }
      if (!is.null(AtomicFlowCytometrySourceObject$`templateId`)) {
        self$`templateId` <- AtomicFlowCytometrySourceObject$`templateId`
      }
      if (!is.null(AtomicFlowCytometrySourceObject$`value`)) {
        self$`value` <- AtomicFlowCytometrySourceObject$`value`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "cell-population": %s,
           "marker": %s,
           "metadata": %s,
           "readout-type": %s,
           "templateId": %s,
           "value": %d
        }',
                if (is.null(self$`cell-population`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`cell-population`)
                }
            ,
                if (is.null(self$`marker`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`marker`)
                }
            ,
                self$`metadata`$toJSON()
            ,
                if (is.null(self$`readout-type`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`readout-type`)
                }
            ,
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            ,
                if (is.null(self$`value`)) {
                    'null'
                } else {
                        self$`value`
                }
            
      )
    },
    fromJSONString = function(AtomicFlowCytometrySourceJson) {
      self$`_raw_json` <- AtomicFlowCytometrySourceJson

      AtomicFlowCytometrySourceObject <- jsonlite::fromJSON(AtomicFlowCytometrySourceJson)
      self$`cell-population` <- AtomicFlowCytometrySourceObject$`cell-population`
      self$`marker` <- AtomicFlowCytometrySourceObject$`marker`
      JsonMetadataObject <- JsonMetadata$new()
      self$`metadata` <- JsonMetadataObject$fromJSON(jsonlite::toJSON(AtomicFlowCytometrySourceObject$metadata, auto_unbox = TRUE))
      self$`readout-type` <- AtomicFlowCytometrySourceObject$`readout-type`
      self$`templateId` <- AtomicFlowCytometrySourceObject$`templateId`
      self$`value` <- AtomicFlowCytometrySourceObject$`value`
    }
  )
)
