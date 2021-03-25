# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the variantCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


VariantSource <- R6::R6Class(
  'VariantSource',
  public = list(
    `_raw_json` = NULL,

    `alteration` = NULL,
    `contig` = NULL,
    `genotype` = NULL,
    `locus` = NULL,
    `metadata` = NULL,
    `reference` = NULL,
    `templateId` = NULL,
    `variationId` = NULL,
    initialize = function(`alteration`, `contig`, `genotype`, `locus`, `metadata`, `reference`, `templateId`, `variationId`){
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
        stopifnot(is.character(`genotype`), length(`genotype`) == 1)
        self$`genotype` <- `genotype`
      }
      if (!missing(`locus`)) {
        stopifnot(is.numeric(`locus`), length(`locus`) == 1)
        self$`locus` <- `locus`
      }
      if (!missing(`metadata`)) {
        stopifnot(R6::is.R6(`metadata`))
        self$`metadata` <- `metadata`
      }
      if (!missing(`reference`)) {
        stopifnot(is.character(`reference`), length(`reference`) == 1)
        self$`reference` <- `reference`
      }
      if (!missing(`templateId`)) {
        stopifnot(is.character(`templateId`), length(`templateId`) == 1)
        self$`templateId` <- `templateId`
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

      VariantSourceObject <- list()
      if (!is.null(self$`alteration`)) {
        VariantSourceObject[['alteration']] <- self$`alteration`
      }
      if (!is.null(self$`contig`)) {
        VariantSourceObject[['contig']] <- self$`contig`
      }
      if (!is.null(self$`genotype`)) {
        VariantSourceObject[['genotype']] <- self$`genotype`
      }
      if (!is.null(self$`locus`)) {
        VariantSourceObject[['locus']] <- self$`locus`
      }
      if (!is.null(self$`metadata`)) {
        VariantSourceObject[['metadata']] <- self$`metadata`$toJSON()
      }
      if (!is.null(self$`reference`)) {
        VariantSourceObject[['reference']] <- self$`reference`
      }
      if (!is.null(self$`templateId`)) {
        VariantSourceObject[['templateId']] <- self$`templateId`
      }
      if (!is.null(self$`variationId`)) {
        VariantSourceObject[['variationId']] <- self$`variationId`
      }

      VariantSourceObject
    },
    fromJSON = function(VariantSourceJson) {
      self$`_raw_json` <- VariantSourceJson

      VariantSourceObject <- jsonlite::fromJSON(VariantSourceJson)
      if (!is.null(VariantSourceObject$`alteration`)) {
        self$`alteration` <- VariantSourceObject$`alteration`
      }
      if (!is.null(VariantSourceObject$`contig`)) {
        self$`contig` <- VariantSourceObject$`contig`
      }
      if (!is.null(VariantSourceObject$`genotype`)) {
        self$`genotype` <- VariantSourceObject$`genotype`
      }
      if (!is.null(VariantSourceObject$`locus`)) {
        self$`locus` <- VariantSourceObject$`locus`
      }
      if (!is.null(VariantSourceObject$`metadata`)) {
        metadataObject <- JsonMetadata$new()
        metadataObject$fromJSON(jsonlite::toJSON(VariantSourceObject$metadata, auto_unbox = TRUE))
        self$`metadata` <- metadataObject
      }
      if (!is.null(VariantSourceObject$`reference`)) {
        self$`reference` <- VariantSourceObject$`reference`
      }
      if (!is.null(VariantSourceObject$`templateId`)) {
        self$`templateId` <- VariantSourceObject$`templateId`
      }
      if (!is.null(VariantSourceObject$`variationId`)) {
        self$`variationId` <- VariantSourceObject$`variationId`
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
           "locus": %d,
           "metadata": %s,
           "reference": %s,
           "templateId": %s,
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
                        sprintf('"%s"', self$`genotype`)
                }
            ,
                if (is.null(self$`locus`)) {
                    'null'
                } else {
                        self$`locus`
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
                if (is.null(self$`templateId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`templateId`)
                }
            ,
        lapply(self$`variationId`, function(x) paste(paste0('"', x, '"'), sep=","))
      )
    },
    fromJSONString = function(VariantSourceJson) {
      self$`_raw_json` <- VariantSourceJson

      VariantSourceObject <- jsonlite::fromJSON(VariantSourceJson)
      self$`alteration` <- VariantSourceObject$`alteration`
      self$`contig` <- VariantSourceObject$`contig`
      self$`genotype` <- VariantSourceObject$`genotype`
      self$`locus` <- VariantSourceObject$`locus`
      JsonMetadataObject <- JsonMetadata$new()
      self$`metadata` <- JsonMetadataObject$fromJSON(jsonlite::toJSON(VariantSourceObject$metadata, auto_unbox = TRUE))
      self$`reference` <- VariantSourceObject$`reference`
      self$`templateId` <- VariantSourceObject$`templateId`
      self$`variationId` <- VariantSourceObject$`variationId`
    }
  )
)
