# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


Link <- R6::R6Class(
  'Link',
  public = list(
    `_raw_json` = NULL,

    `firstId` = NULL,
    `firstType` = NULL,
    `secondId` = NULL,
    `secondType` = NULL,
    initialize = function(`firstId`, `firstType`, `secondId`, `secondType`){
      if (!missing(`firstId`)) {
        stopifnot(is.character(`firstId`), length(`firstId`) == 1)
        self$`firstId` <- `firstId`
      }
      if (!missing(`firstType`)) {
        stopifnot(is.character(`firstType`), length(`firstType`) == 1)
        self$`firstType` <- `firstType`
      }
      if (!missing(`secondId`)) {
        stopifnot(is.character(`secondId`), length(`secondId`) == 1)
        self$`secondId` <- `secondId`
      }
      if (!missing(`secondType`)) {
        stopifnot(is.character(`secondType`), length(`secondType`) == 1)
        self$`secondType` <- `secondType`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      LinkObject <- list()
      if (!is.null(self$`firstId`)) {
        LinkObject[['firstId']] <- self$`firstId`
      }
      if (!is.null(self$`firstType`)) {
        LinkObject[['firstType']] <- self$`firstType`
      }
      if (!is.null(self$`secondId`)) {
        LinkObject[['secondId']] <- self$`secondId`
      }
      if (!is.null(self$`secondType`)) {
        LinkObject[['secondType']] <- self$`secondType`
      }

      LinkObject
    },
    fromJSON = function(LinkJson) {
      self$`_raw_json` <- LinkJson

      LinkObject <- jsonlite::fromJSON(LinkJson)
      if (!is.null(LinkObject$`firstId`)) {
        self$`firstId` <- LinkObject$`firstId`
      }
      if (!is.null(LinkObject$`firstType`)) {
        self$`firstType` <- LinkObject$`firstType`
      }
      if (!is.null(LinkObject$`secondId`)) {
        self$`secondId` <- LinkObject$`secondId`
      }
      if (!is.null(LinkObject$`secondType`)) {
        self$`secondType` <- LinkObject$`secondType`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "firstId": %s,
           "firstType": %s,
           "secondId": %s,
           "secondType": %s
        }',
                if (is.null(self$`firstId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`firstId`)
                }
            ,
                if (is.null(self$`firstType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`firstType`)
                }
            ,
                if (is.null(self$`secondId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`secondId`)
                }
            ,
                if (is.null(self$`secondType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`secondType`)
                }
            
      )
    },
    fromJSONString = function(LinkJson) {
      self$`_raw_json` <- LinkJson

      LinkObject <- jsonlite::fromJSON(LinkJson)
      self$`firstId` <- LinkObject$`firstId`
      self$`firstType` <- LinkObject$`firstType`
      self$`secondId` <- LinkObject$`secondId`
      self$`secondType` <- LinkObject$`secondType`
    }
  )
)
