# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


Relationships <- R6::R6Class(
  'Relationships',
  public = list(
    `_raw_json` = NULL,

    `cell` = NULL,
    `sample` = NULL,
    initialize = function(`cell`, `sample`){
      if (!missing(`cell`)) {
        stopifnot(is.character(`cell`), length(`cell`) == 1)
        self$`cell` <- `cell`
      }
      if (!missing(`sample`)) {
        stopifnot(is.character(`sample`), length(`sample`) == 1)
        self$`sample` <- `sample`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      RelationshipsObject <- list()
      if (!is.null(self$`cell`)) {
        RelationshipsObject[['cell']] <- self$`cell`
      }
      if (!is.null(self$`sample`)) {
        RelationshipsObject[['sample']] <- self$`sample`
      }

      RelationshipsObject
    },
    fromJSON = function(RelationshipsJson) {
      self$`_raw_json` <- RelationshipsJson

      RelationshipsObject <- jsonlite::fromJSON(RelationshipsJson)
      if (!is.null(RelationshipsObject$`cell`)) {
        self$`cell` <- RelationshipsObject$`cell`
      }
      if (!is.null(RelationshipsObject$`sample`)) {
        self$`sample` <- RelationshipsObject$`sample`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "cell": %s,
           "sample": %s
        }',
                if (is.null(self$`cell`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`cell`)
                }
            ,
                if (is.null(self$`sample`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`sample`)
                }
            
      )
    },
    fromJSONString = function(RelationshipsJson) {
      self$`_raw_json` <- RelationshipsJson

      RelationshipsObject <- jsonlite::fromJSON(RelationshipsJson)
      self$`cell` <- RelationshipsObject$`cell`
      self$`sample` <- RelationshipsObject$`sample`
    }
  )
)
