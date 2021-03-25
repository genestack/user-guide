# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the expressionCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


AtomicExpressionSource <- R6::R6Class(
  'AtomicExpressionSource',
  public = list(
    `_raw_json` = NULL,

    `description` = NULL,
    `expression` = NULL,
    `feature` = NULL,
    `metadata` = NULL,
    `templateId` = NULL,
    initialize = function(`description`, `expression`, `feature`, `metadata`, `templateId`){
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

      AtomicExpressionSourceObject <- list()
      if (!is.null(self$`description`)) {
        AtomicExpressionSourceObject[['description']] <- self$`description`
      }
      if (!is.null(self$`expression`)) {
        AtomicExpressionSourceObject[['expression']] <- self$`expression`
      }
      if (!is.null(self$`feature`)) {
        AtomicExpressionSourceObject[['feature']] <- self$`feature`
      }
      if (!is.null(self$`metadata`)) {
        AtomicExpressionSourceObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`templateId`)) {
        AtomicExpressionSourceObject[['templateId']] <- self$`templateId`
      }

      AtomicExpressionSourceObject
    },
    fromJSON = function(AtomicExpressionSourceJson) {
      self$`_raw_json` <- AtomicExpressionSourceJson

      AtomicExpressionSourceObject <- jsonlite::fromJSON(AtomicExpressionSourceJson)
      if (!is.null(AtomicExpressionSourceObject$`description`)) {
        self$`description` <- AtomicExpressionSourceObject$`description`
      }
      if (!is.null(AtomicExpressionSourceObject$`expression`)) {
        self$`expression` <- AtomicExpressionSourceObject$`expression`
      }
      if (!is.null(AtomicExpressionSourceObject$`feature`)) {
        self$`feature` <- AtomicExpressionSourceObject$`feature`
      }
      if (!is.null(AtomicExpressionSourceObject$`metadata`)) {
        metadataObject <- JsonMetadata$new()
        metadataObject$fromJSON(jsonlite::toJSON(AtomicExpressionSourceObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(AtomicExpressionSourceObject$`templateId`)) {
        self$`templateId` <- AtomicExpressionSourceObject$`templateId`
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
           "metadata": %s,
           "templateId": %s
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
                self$`metadata`$toJSON()
            ,
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            
      )
    },
    fromJSONString = function(AtomicExpressionSourceJson) {
      self$`_raw_json` <- AtomicExpressionSourceJson

      AtomicExpressionSourceObject <- jsonlite::fromJSON(AtomicExpressionSourceJson)
      self$`description` <- AtomicExpressionSourceObject$`description`
      self$`expression` <- AtomicExpressionSourceObject$`expression`
      self$`feature` <- AtomicExpressionSourceObject$`feature`
      JsonMetadataObject <- JsonMetadata$new()
      self$`metadata` <- JsonMetadataObject$fromJSON(jsonlite::toJSON(AtomicExpressionSourceObject$metadata, auto_unbox = TRUE))
      self$`templateId` <- AtomicExpressionSourceObject$`templateId`
    }
  )
)
