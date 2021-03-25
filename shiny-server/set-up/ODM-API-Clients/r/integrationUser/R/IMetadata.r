# Roche pRed Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationUser APIs. These are typically used to find and retrieve study, sample and processed (signal) data and metadata for a given query.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears   The server response will be in the section that follows.
# 
# API version: v0.1
# 


IMetadata <- R6::R6Class(
  'IMetadata',
  public = list(
    `_raw_json` = NULL,

    `content` = NULL,
    `contentMap` = NULL,
    `dataType` = NULL,
    `id` = NULL,
    `name` = NULL,
    `public` = NULL,
    `source` = NULL,
    initialize = function(`content`, `contentMap`, `dataType`, `id`, `name`, `public`, `source`){
      if (!missing(`content`)) {
        stopifnot(R6::is.R6(`content`))
        self$`content` <- `content`
      }
      if (!missing(`contentMap`)) {
        stopifnot(R6::is.R6(`contentMap`))
        self$`contentMap` <- `contentMap`
      }
      if (!missing(`dataType`)) {
        stopifnot(is.character(`dataType`), length(`dataType`) == 1)
        self$`dataType` <- `dataType`
      }
      if (!missing(`id`)) {
        stopifnot(is.character(`id`), length(`id`) == 1)
        self$`id` <- `id`
      }
      if (!missing(`name`)) {
        stopifnot(is.character(`name`), length(`name`) == 1)
        self$`name` <- `name`
      }
      if (!missing(`public`)) {
        self$`public` <- `public`
      }
      if (!missing(`source`)) {
        stopifnot(is.character(`source`), length(`source`) == 1)
        self$`source` <- `source`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      IMetadataObject <- list()
      if (!is.null(self$`content`)) {
        IMetadataObject[['content']] <- self$`content`$toJSON()
      }
      if (!is.null(self$`contentMap`)) {
        IMetadataObject[['contentMap']] <- self$`contentMap`$toJSON()
      }
      if (!is.null(self$`dataType`)) {
        IMetadataObject[['dataType']] <- self$`dataType`
      }
      if (!is.null(self$`id`)) {
        IMetadataObject[['id']] <- self$`id`
      }
      if (!is.null(self$`name`)) {
        IMetadataObject[['name']] <- self$`name`
      }
      if (!is.null(self$`public`)) {
        IMetadataObject[['public']] <- self$`public`
      }
      if (!is.null(self$`source`)) {
        IMetadataObject[['source']] <- self$`source`
      }

      IMetadataObject
    },
    fromJSON = function(IMetadataJson) {
      self$`_raw_json` <- IMetadataJson

      IMetadataObject <- jsonlite::fromJSON(IMetadataJson)
      if (!is.null(IMetadataObject$`content`)) {
        contentObject <- MetadataContent$new()
        contentObject$fromJSON(jsonlite::toJSON(IMetadataObject$content, auto_unbox = TRUE))
        self$`content` <- contentObject
      }
      if (!is.null(IMetadataObject$`contentMap`)) {
        contentMapObject <- TODO_OBJECT_MAPPING$new()
        contentMapObject$fromJSON(jsonlite::toJSON(IMetadataObject$contentMap, auto_unbox = TRUE))
        self$`contentMap` <- contentMapObject
      }
      if (!is.null(IMetadataObject$`dataType`)) {
        self$`dataType` <- IMetadataObject$`dataType`
      }
      if (!is.null(IMetadataObject$`id`)) {
        self$`id` <- IMetadataObject$`id`
      }
      if (!is.null(IMetadataObject$`name`)) {
        self$`name` <- IMetadataObject$`name`
      }
      if (!is.null(IMetadataObject$`public`)) {
        self$`public` <- IMetadataObject$`public`
      }
      if (!is.null(IMetadataObject$`source`)) {
        self$`source` <- IMetadataObject$`source`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "content": %s,
           "contentMap": %s,
           "dataType": %s,
           "id": %s,
           "name": %s,
           "public": %s,
           "source": %s
        }',
                self$`content`$toJSON()
            ,
                self$`contentMap`$toJSON()
            ,
                if (is.null(self$`dataType`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`dataType`)
                }
            ,
                if (is.null(self$`id`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`id`)
                }
            ,
                if (is.null(self$`name`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`name`)
                }
            ,
                if (is.null(self$`public`)) {
                    'null'
                } else {
                        self$`public`
                }
            ,
                if (is.null(self$`source`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`source`)
                }
            
      )
    },
    fromJSONString = function(IMetadataJson) {
      self$`_raw_json` <- IMetadataJson

      IMetadataObject <- jsonlite::fromJSON(IMetadataJson)
      MetadataContentObject <- MetadataContent$new()
      self$`content` <- MetadataContentObject$fromJSON(jsonlite::toJSON(IMetadataObject$content, auto_unbox = TRUE))
      TODO_OBJECT_MAPPINGObject <- TODO_OBJECT_MAPPING$new()
      self$`contentMap` <- TODO_OBJECT_MAPPINGObject$fromJSON(jsonlite::toJSON(IMetadataObject$contentMap, auto_unbox = TRUE))
      self$`dataType` <- IMetadataObject$`dataType`
      self$`id` <- IMetadataObject$`id`
      self$`name` <- IMetadataObject$`name`
      self$`public` <- IMetadataObject$`public`
      self$`source` <- IMetadataObject$`source`
    }
  )
)
