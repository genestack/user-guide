# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the flowCytometryUser API endpoints for ODM. These are typically used to find and retrieve flow cytometry data and metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 


FlowCytometryItem <- R6::R6Class(
  'FlowCytometryItem',
  public = list(
    `_raw_json` = NULL,

    `cellPopulation` = NULL,
    `expression` = NULL,
    `groupId` = NULL,
    `itemId` = NULL,
    `marker` = NULL,
    `metadata` = NULL,
    `readoutType` = NULL,
    `runId` = NULL,
    initialize = function(`cellPopulation`, `expression`, `groupId`, `itemId`, `marker`, `metadata`, `readoutType`, `runId`){
      if (!missing(`cellPopulation`)) {
        stopifnot(is.character(`cellPopulation`), length(`cellPopulation`) == 1)
        self$`cellPopulation` <- `cellPopulation`
      }
      if (!missing(`expression`)) {
        self$`expression` <- `expression`
      }
      if (!missing(`groupId`)) {
        stopifnot(is.character(`groupId`), length(`groupId`) == 1)
        self$`groupId` <- `groupId`
      }
      if (!missing(`itemId`)) {
        stopifnot(is.character(`itemId`), length(`itemId`) == 1)
        self$`itemId` <- `itemId`
      }
      if (!missing(`marker`)) {
        stopifnot(is.character(`marker`), length(`marker`) == 1)
        self$`marker` <- `marker`
      }
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
      }
      if (!missing(`readoutType`)) {
        stopifnot(is.character(`readoutType`), length(`readoutType`) == 1)
        self$`readoutType` <- `readoutType`
      }
      if (!missing(`runId`)) {
        stopifnot(is.character(`runId`), length(`runId`) == 1)
        self$`runId` <- `runId`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      FlowCytometryItemObject <- list()
      if (!is.null(self$`cellPopulation`)) {
        FlowCytometryItemObject[['cellPopulation']] <- self$`cellPopulation`
      }
      if (!is.null(self$`expression`)) {
        FlowCytometryItemObject[['expression']] <- self$`expression`
      }
      if (!is.null(self$`groupId`)) {
        FlowCytometryItemObject[['groupId']] <- self$`groupId`
      }
      if (!is.null(self$`itemId`)) {
        FlowCytometryItemObject[['itemId']] <- self$`itemId`
      }
      if (!is.null(self$`marker`)) {
        FlowCytometryItemObject[['marker']] <- self$`marker`
      }
      if (!is.null(self$`metadata`)) {
        FlowCytometryItemObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`readoutType`)) {
        FlowCytometryItemObject[['readoutType']] <- self$`readoutType`
      }
      if (!is.null(self$`runId`)) {
        FlowCytometryItemObject[['runId']] <- self$`runId`
      }

      FlowCytometryItemObject
    },
    fromJSON = function(FlowCytometryItemJson) {
      self$`_raw_json` <- FlowCytometryItemJson

      FlowCytometryItemObject <- jsonlite::fromJSON(FlowCytometryItemJson)
      if (!is.null(FlowCytometryItemObject$`cellPopulation`)) {
        self$`cellPopulation` <- FlowCytometryItemObject$`cellPopulation`
      }
      if (!is.null(FlowCytometryItemObject$`expression`)) {
        self$`expression` <- FlowCytometryItemObject$`expression`
      }
      if (!is.null(FlowCytometryItemObject$`groupId`)) {
        self$`groupId` <- FlowCytometryItemObject$`groupId`
      }
      if (!is.null(FlowCytometryItemObject$`itemId`)) {
        self$`itemId` <- FlowCytometryItemObject$`itemId`
      }
      if (!is.null(FlowCytometryItemObject$`marker`)) {
        self$`marker` <- FlowCytometryItemObject$`marker`
      }
      if (!is.null(FlowCytometryItemObject$`metadata`)) {
        metadataObject <- MetadataContent$new()
        metadataObject$fromJSON(jsonlite::toJSON(FlowCytometryItemObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(FlowCytometryItemObject$`readoutType`)) {
        self$`readoutType` <- FlowCytometryItemObject$`readoutType`
      }
      if (!is.null(FlowCytometryItemObject$`runId`)) {
        self$`runId` <- FlowCytometryItemObject$`runId`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "cellPopulation": %s,
           "expression": %s,
           "groupId": %s,
           "itemId": %s,
           "marker": %s,
           "metadata": %s,
           "readoutType": %s,
           "runId": %s
        }',
                if (is.null(self$`cellPopulation`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`cellPopulation`)
                }
            ,
                if (is.null(self$`expression`)) {
                    'null'
                } else {
                        self$`expression`
                }
            ,
                if (is.null(self$`groupId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`groupId`)
                }
            ,
                if (is.null(self$`itemId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`itemId`)
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
                if (is.null(self$`readoutType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`readoutType`)
                }
            ,
                if (is.null(self$`runId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`runId`)
                }
            
      )
    },
    fromJSONString = function(FlowCytometryItemJson) {
      self$`_raw_json` <- FlowCytometryItemJson

      FlowCytometryItemObject <- jsonlite::fromJSON(FlowCytometryItemJson)
      self$`cellPopulation` <- FlowCytometryItemObject$`cellPopulation`
      self$`expression` <- FlowCytometryItemObject$`expression`
      self$`groupId` <- FlowCytometryItemObject$`groupId`
      self$`itemId` <- FlowCytometryItemObject$`itemId`
      self$`marker` <- FlowCytometryItemObject$`marker`
      MetadataContentObject <- MetadataContent$new()
      self$`metadata` <- MetadataContentObject$fromJSON(jsonlite::toJSON(FlowCytometryItemObject$metadata, auto_unbox = TRUE))
      self$`readoutType` <- FlowCytometryItemObject$`readoutType`
      self$`runId` <- FlowCytometryItemObject$`runId`
    }
  )
)
