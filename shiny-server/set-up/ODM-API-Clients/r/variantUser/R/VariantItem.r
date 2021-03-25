# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the variantUser API endpoints for ODM. These are typically used to find and retrieve variant data and metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 


VariantItem <- R6::R6Class(
  'VariantItem',
  public = list(
    `_raw_json` = NULL,

    `alteration` = NULL,
    `contig` = NULL,
    `genotype` = NULL,
    `groupId` = NULL,
    `info` = NULL,
    `itemId` = NULL,
    `metadata` = NULL,
    `reference` = NULL,
    `runId` = NULL,
    `start` = NULL,
    `variationId` = NULL,
    initialize = function(`alteration`, `contig`, `genotype`, `groupId`, `info`, `itemId`, `metadata`, `reference`, `runId`, `start`, `variationId`){
      if (!missing(`alteration`)) {
        stopifnot(is.list(`alteration`), length(`alteration`) != 0)
        lapply(`alteration`, function(x) stopifnot(is.character(x)))
        self$`alteration` <- `alteration`
      }
      if (!missing(`contig`)) {
        stopifnot(is.character(`contig`), length(`contig`) == 1)
        self$`contig` <- `contig`
      }
      if (!missing(`genotype`)) {
        self$`genotype` <- `genotype`
      }
      if (!missing(`groupId`)) {
        stopifnot(is.character(`groupId`), length(`groupId`) == 1)
        self$`groupId` <- `groupId`
      }
      if (!missing(`info`)) {
        stopifnot(R6::is.R6(`info`))
        self$`info` <- `info`
      }
      if (!missing(`itemId`)) {
        stopifnot(is.character(`itemId`), length(`itemId`) == 1)
        self$`itemId` <- `itemId`
      }
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
      }
      if (!missing(`reference`)) {
        stopifnot(is.character(`reference`), length(`reference`) == 1)
        self$`reference` <- `reference`
      }
      if (!missing(`runId`)) {
        stopifnot(is.character(`runId`), length(`runId`) == 1)
        self$`runId` <- `runId`
      }
      if (!missing(`start`)) {
        stopifnot(is.numeric(`start`), length(`start`) == 1)
        self$`start` <- `start`
      }
      if (!missing(`variationId`)) {
        stopifnot(is.list(`variationId`), length(`variationId`) != 0)
        lapply(`variationId`, function(x) stopifnot(is.character(x)))
        self$`variationId` <- `variationId`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      VariantItemObject <- list()
      if (!is.null(self$`alteration`)) {
        VariantItemObject[['alteration']] <- self$`alteration`
      }
      if (!is.null(self$`contig`)) {
        VariantItemObject[['contig']] <- self$`contig`
      }
      if (!is.null(self$`genotype`)) {
        VariantItemObject[['genotype']] <- self$`genotype`
      }
      if (!is.null(self$`groupId`)) {
        VariantItemObject[['groupId']] <- self$`groupId`
      }
      if (!is.null(self$`info`)) {
        VariantItemObject[['info']] <- self$`info`$toJSON()
      }
      if (!is.null(self$`itemId`)) {
        VariantItemObject[['itemId']] <- self$`itemId`
      }
      if (!is.null(self$`metadata`)) {
        VariantItemObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`reference`)) {
        VariantItemObject[['reference']] <- self$`reference`
      }
      if (!is.null(self$`runId`)) {
        VariantItemObject[['runId']] <- self$`runId`
      }
      if (!is.null(self$`start`)) {
        VariantItemObject[['start']] <- self$`start`
      }
      if (!is.null(self$`variationId`)) {
        VariantItemObject[['variationId']] <- self$`variationId`
      }

      VariantItemObject
    },
    fromJSON = function(VariantItemJson) {
      self$`_raw_json` <- VariantItemJson

      VariantItemObject <- jsonlite::fromJSON(VariantItemJson)
      if (!is.null(VariantItemObject$`alteration`)) {
        self$`alteration` <- VariantItemObject$`alteration`
      }
      if (!is.null(VariantItemObject$`contig`)) {
        self$`contig` <- VariantItemObject$`contig`
      }
      if (!is.null(VariantItemObject$`genotype`)) {
        self$`genotype` <- VariantItemObject$`genotype`
      }
      if (!is.null(VariantItemObject$`groupId`)) {
        self$`groupId` <- VariantItemObject$`groupId`
      }
      if (!is.null(VariantItemObject$`info`)) {
        infoObject <- Character$new()
        infoObject$fromJSON(jsonlite::toJSON(VariantItemObject$info, auto_unbox = TRUE))
        self$`info` <- infoObject
      }
      if (!is.null(VariantItemObject$`itemId`)) {
        self$`itemId` <- VariantItemObject$`itemId`
      }
      if (!is.null(VariantItemObject$`metadata`)) {
        metadataObject <- MetadataContent$new()
        metadataObject$fromJSON(jsonlite::toJSON(VariantItemObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(VariantItemObject$`reference`)) {
        self$`reference` <- VariantItemObject$`reference`
      }
      if (!is.null(VariantItemObject$`runId`)) {
        self$`runId` <- VariantItemObject$`runId`
      }
      if (!is.null(VariantItemObject$`start`)) {
        self$`start` <- VariantItemObject$`start`
      }
      if (!is.null(VariantItemObject$`variationId`)) {
        self$`variationId` <- VariantItemObject$`variationId`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "alteration": [%s],
           "contig": %s,
           "genotype": %s,
           "groupId": %s,
           "info": %s,
           "itemId": %s,
           "metadata": %s,
           "reference": %s,
           "runId": %s,
           "start": %d,
           "variationId": [%s]
        }',
        lapply(self$`alteration`, function(x) paste(paste0('"', x, '"'), sep=",")),
                if (is.null(self$`contig`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`contig`)
                }
            ,
                if (is.null(self$`genotype`)) {
                    'null'
                } else {
                        self$`genotype`
                }
            ,
                if (is.null(self$`groupId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`groupId`)
                }
            ,
                self$`info`$toJSON()
            ,
                if (is.null(self$`itemId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`itemId`)
                }
            ,
                self$`metadata`$toJSON()
            ,
                if (is.null(self$`reference`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`reference`)
                }
            ,
                if (is.null(self$`runId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`runId`)
                }
            ,
                if (is.null(self$`start`)) {
                    'null'
                } else {
                        self$`start`
                }
            ,
        lapply(self$`variationId`, function(x) paste(paste0('"', x, '"'), sep=","))
      )
    },
    fromJSONString = function(VariantItemJson) {
      self$`_raw_json` <- VariantItemJson

      VariantItemObject <- jsonlite::fromJSON(VariantItemJson)
      self$`alteration` <- VariantItemObject$`alteration`
      self$`contig` <- VariantItemObject$`contig`
      self$`genotype` <- VariantItemObject$`genotype`
      self$`groupId` <- VariantItemObject$`groupId`
      CharacterObject <- Character$new()
      self$`info` <- CharacterObject$fromJSON(jsonlite::toJSON(VariantItemObject$info, auto_unbox = TRUE))
      self$`itemId` <- VariantItemObject$`itemId`
      MetadataContentObject <- MetadataContent$new()
      self$`metadata` <- MetadataContentObject$fromJSON(jsonlite::toJSON(VariantItemObject$metadata, auto_unbox = TRUE))
      self$`reference` <- VariantItemObject$`reference`
      self$`runId` <- VariantItemObject$`runId`
      self$`start` <- VariantItemObject$`start`
      self$`variationId` <- VariantItemObject$`variationId`
    }
  )
)
