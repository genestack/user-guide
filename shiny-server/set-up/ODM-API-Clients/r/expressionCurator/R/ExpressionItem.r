# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the expressionCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


ExpressionItem <- R6::R6Class(
  'ExpressionItem',
  public = list(
    `_raw_json` = NULL,

    `description` = NULL,
    `expression` = NULL,
    `feature` = NULL,
    `gene` = NULL,
    `groupId` = NULL,
    `itemId` = NULL,
    `metadata` = NULL,
    `runId` = NULL,
    initialize = function(`description`, `expression`, `feature`, `gene`, `groupId`, `itemId`, `metadata`, `runId`){
      if (!missing(`description`)) {
        stopifnot(is.character(`description`), length(`description`) == 1)
        self$`description` <- `description`
      }
      if (!missing(`expression`)) {
        stopifnot(is.numeric(`expression`), length(`expression`) == 1)
        self$`expression` <- `expression`
      }
      if (!missing(`feature`)) {
        stopifnot(is.character(`feature`), length(`feature`) == 1)
        self$`feature` <- `feature`
      }
      if (!missing(`gene`)) {
        stopifnot(is.character(`gene`), length(`gene`) == 1)
        self$`gene` <- `gene`
      }
      if (!missing(`groupId`)) {
        stopifnot(is.character(`groupId`), length(`groupId`) == 1)
        self$`groupId` <- `groupId`
      }
      if (!missing(`itemId`)) {
        stopifnot(is.character(`itemId`), length(`itemId`) == 1)
        self$`itemId` <- `itemId`
      }
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
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

      ExpressionItemObject <- list()
      if (!is.null(self$`description`)) {
        ExpressionItemObject[['description']] <- self$`description`
      }
      if (!is.null(self$`expression`)) {
        ExpressionItemObject[['expression']] <- self$`expression`
      }
      if (!is.null(self$`feature`)) {
        ExpressionItemObject[['feature']] <- self$`feature`
      }
      if (!is.null(self$`gene`)) {
        ExpressionItemObject[['gene']] <- self$`gene`
      }
      if (!is.null(self$`groupId`)) {
        ExpressionItemObject[['groupId']] <- self$`groupId`
      }
      if (!is.null(self$`itemId`)) {
        ExpressionItemObject[['itemId']] <- self$`itemId`
      }
      if (!is.null(self$`metadata`)) {
        ExpressionItemObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`runId`)) {
        ExpressionItemObject[['runId']] <- self$`runId`
      }

      ExpressionItemObject
    },
    fromJSON = function(ExpressionItemJson) {
      self$`_raw_json` <- ExpressionItemJson

      ExpressionItemObject <- jsonlite::fromJSON(ExpressionItemJson)
      if (!is.null(ExpressionItemObject$`description`)) {
        self$`description` <- ExpressionItemObject$`description`
      }
      if (!is.null(ExpressionItemObject$`expression`)) {
        self$`expression` <- ExpressionItemObject$`expression`
      }
      if (!is.null(ExpressionItemObject$`feature`)) {
        self$`feature` <- ExpressionItemObject$`feature`
      }
      if (!is.null(ExpressionItemObject$`gene`)) {
        self$`gene` <- ExpressionItemObject$`gene`
      }
      if (!is.null(ExpressionItemObject$`groupId`)) {
        self$`groupId` <- ExpressionItemObject$`groupId`
      }
      if (!is.null(ExpressionItemObject$`itemId`)) {
        self$`itemId` <- ExpressionItemObject$`itemId`
      }
      if (!is.null(ExpressionItemObject$`metadata`)) {
        metadataObject <- MetadataContent$new()
        metadataObject$fromJSON(jsonlite::toJSON(ExpressionItemObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(ExpressionItemObject$`runId`)) {
        self$`runId` <- ExpressionItemObject$`runId`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "description": %s,
           "expression": %d,
           "feature": %s,
           "gene": %s,
           "groupId": %s,
           "itemId": %s,
           "metadata": %s,
           "runId": %s
        }',
                if (is.null(self$`description`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`description`)
                }
            ,
                if (is.null(self$`expression`)) {
                    'null'
                } else {
                        self$`expression`
                }
            ,
                if (is.null(self$`feature`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`feature`)
                }
            ,
                if (is.null(self$`gene`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`gene`)
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
                self$`metadata`$toJSON()
            ,
                if (is.null(self$`runId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`runId`)
                }
            
      )
    },
    fromJSONString = function(ExpressionItemJson) {
      self$`_raw_json` <- ExpressionItemJson

      ExpressionItemObject <- jsonlite::fromJSON(ExpressionItemJson)
      self$`description` <- ExpressionItemObject$`description`
      self$`expression` <- ExpressionItemObject$`expression`
      self$`feature` <- ExpressionItemObject$`feature`
      self$`gene` <- ExpressionItemObject$`gene`
      self$`groupId` <- ExpressionItemObject$`groupId`
      self$`itemId` <- ExpressionItemObject$`itemId`
      MetadataContentObject <- MetadataContent$new()
      self$`metadata` <- MetadataContentObject$fromJSON(jsonlite::toJSON(ExpressionItemObject$metadata, auto_unbox = TRUE))
      self$`runId` <- ExpressionItemObject$`runId`
    }
  )
)
