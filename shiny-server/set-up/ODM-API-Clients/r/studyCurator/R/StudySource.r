# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the studyCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


StudySource <- R6::R6Class(
  'StudySource',
  public = list(
    `_raw_json` = NULL,

    `link` = NULL,
    `metadataLink` = NULL,
    `templateId` = NULL,
    initialize = function(`link`, `metadataLink`, `templateId`){
      if (!missing(`link`)) {
        stopifnot(is.character(`link`), length(`link`) == 1)
        self$`link` <- `link`
      }
      if (!missing(`metadataLink`)) {
        stopifnot(is.character(`metadataLink`), length(`metadataLink`) == 1)
        self$`metadataLink` <- `metadataLink`
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

      StudySourceObject <- list()
      if (!is.null(self$`link`)) {
        StudySourceObject[['link']] <- self$`link`
      }
      if (!is.null(self$`metadataLink`)) {
        StudySourceObject[['metadataLink']] <- self$`metadataLink`
      }
      if (!is.null(self$`templateId`)) {
        StudySourceObject[['templateId']] <- self$`templateId`
      }

      StudySourceObject
    },
    fromJSON = function(StudySourceJson) {
      self$`_raw_json` <- StudySourceJson

      StudySourceObject <- jsonlite::fromJSON(StudySourceJson)
      if (!is.null(StudySourceObject$`link`)) {
        self$`link` <- StudySourceObject$`link`
      }
      if (!is.null(StudySourceObject$`metadataLink`)) {
        self$`metadataLink` <- StudySourceObject$`metadataLink`
      }
      if (!is.null(StudySourceObject$`templateId`)) {
        self$`templateId` <- StudySourceObject$`templateId`
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
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            
      )
    },
    fromJSONString = function(StudySourceJson) {
      self$`_raw_json` <- StudySourceJson

      StudySourceObject <- jsonlite::fromJSON(StudySourceJson)
      self$`link` <- StudySourceObject$`link`
      self$`metadataLink` <- StudySourceObject$`metadataLink`
      self$`templateId` <- StudySourceObject$`templateId`
    }
  )
)
