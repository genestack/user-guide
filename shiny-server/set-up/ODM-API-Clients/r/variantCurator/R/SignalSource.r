# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the variantCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


SignalSource <- R6::R6Class(
  'SignalSource',
  public = list(
    `_raw_json` = NULL,

    `link` = NULL,
    `metadataLink` = NULL,
    `previousVersion` = NULL,
    `templateId` = NULL,
    initialize = function(`link`, `metadataLink`, `previousVersion`, `templateId`){
      if (!missing(`link`)) {
        stopifnot(is.character(`link`), length(`link`) == 1)
        self$`link` <- `link`
      }
      if (!missing(`metadataLink`)) {
        stopifnot(is.character(`metadataLink`), length(`metadataLink`) == 1)
        self$`metadataLink` <- `metadataLink`
      }
      if (!missing(`previousVersion`)) {
        stopifnot(is.character(`previousVersion`), length(`previousVersion`) == 1)
        self$`previousVersion` <- `previousVersion`
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

      SignalSourceObject <- list()
      if (!is.null(self$`link`)) {
        SignalSourceObject[['link']] <- self$`link`
      }
      if (!is.null(self$`metadataLink`)) {
        SignalSourceObject[['metadataLink']] <- self$`metadataLink`
      }
      if (!is.null(self$`previousVersion`)) {
        SignalSourceObject[['previousVersion']] <- self$`previousVersion`
      }
      if (!is.null(self$`templateId`)) {
        SignalSourceObject[['templateId']] <- self$`templateId`
      }

      SignalSourceObject
    },
    fromJSON = function(SignalSourceJson) {
      self$`_raw_json` <- SignalSourceJson

      SignalSourceObject <- jsonlite::fromJSON(SignalSourceJson)
      if (!is.null(SignalSourceObject$`link`)) {
        self$`link` <- SignalSourceObject$`link`
      }
      if (!is.null(SignalSourceObject$`metadataLink`)) {
        self$`metadataLink` <- SignalSourceObject$`metadataLink`
      }
      if (!is.null(SignalSourceObject$`previousVersion`)) {
        self$`previousVersion` <- SignalSourceObject$`previousVersion`
      }
      if (!is.null(SignalSourceObject$`templateId`)) {
        self$`templateId` <- SignalSourceObject$`templateId`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "link": %s,
           "metadataLink": %s,
           "previousVersion": %s,
           "templateId": %s
        }',
                if (is.null(self$`link`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`link`)
                }
            ,
                if (is.null(self$`metadataLink`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`metadataLink`)
                }
            ,
                if (is.null(self$`previousVersion`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`previousVersion`)
                }
            ,
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            
      )
    },
    fromJSONString = function(SignalSourceJson) {
      self$`_raw_json` <- SignalSourceJson

      SignalSourceObject <- jsonlite::fromJSON(SignalSourceJson)
      self$`link` <- SignalSourceObject$`link`
      self$`metadataLink` <- SignalSourceObject$`metadataLink`
      self$`previousVersion` <- SignalSourceObject$`previousVersion`
      self$`templateId` <- SignalSourceObject$`templateId`
    }
  )
)
