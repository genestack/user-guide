# Roche pRed Layers 3
# 
# This swagger page describes the preparationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


SampleSource <- R6::R6Class(
  'SampleSource',
  public = list(
    `_raw_json` = NULL,

    `link` = NULL,
    `templateId` = NULL,
    initialize = function(`link`, `templateId`){
      if (!missing(`link`)) {
        stopifnot(is.character(`link`), length(`link`) == 1)
        self$`link` <- `link`
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

      SampleSourceObject <- list()
      if (!is.null(self$`link`)) {
        SampleSourceObject[['link']] <- self$`link`
      }
      if (!is.null(self$`templateId`)) {
        SampleSourceObject[['templateId']] <- self$`templateId`
      }

      SampleSourceObject
    },
    fromJSON = function(SampleSourceJson) {
      self$`_raw_json` <- SampleSourceJson

      SampleSourceObject <- jsonlite::fromJSON(SampleSourceJson)
      if (!is.null(SampleSourceObject$`link`)) {
        self$`link` <- SampleSourceObject$`link`
      }
      if (!is.null(SampleSourceObject$`templateId`)) {
        self$`templateId` <- SampleSourceObject$`templateId`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "link": %s,
           "templateId": %s
        }',
                if (is.null(self$`link`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`link`)
                }
            ,
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            
      )
    },
    fromJSONString = function(SampleSourceJson) {
      self$`_raw_json` <- SampleSourceJson

      SampleSourceObject <- jsonlite::fromJSON(SampleSourceJson)
      self$`link` <- SampleSourceObject$`link`
      self$`templateId` <- SampleSourceObject$`templateId`
    }
  )
)
