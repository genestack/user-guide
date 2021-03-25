# Roche pRed Layers 3
# 
# This swagger page describes the libraryCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


PaginationInfo <- R6::R6Class(
  'PaginationInfo',
  public = list(
    `_raw_json` = NULL,

    `count` = NULL,
    `limit` = NULL,
    `offset` = NULL,
    `total` = NULL,
    initialize = function(`count`, `limit`, `offset`, `total`){
      if (!missing(`count`)) {
        stopifnot(is.numeric(`count`), length(`count`) == 1)
        self$`count` <- `count`
      }
      if (!missing(`limit`)) {
        stopifnot(is.numeric(`limit`), length(`limit`) == 1)
        self$`limit` <- `limit`
      }
      if (!missing(`offset`)) {
        stopifnot(is.numeric(`offset`), length(`offset`) == 1)
        self$`offset` <- `offset`
      }
      if (!missing(`total`)) {
        stopifnot(is.numeric(`total`), length(`total`) == 1)
        self$`total` <- `total`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      PaginationInfoObject <- list()
      if (!is.null(self$`count`)) {
        PaginationInfoObject[['count']] <- self$`count`
      }
      if (!is.null(self$`limit`)) {
        PaginationInfoObject[['limit']] <- self$`limit`
      }
      if (!is.null(self$`offset`)) {
        PaginationInfoObject[['offset']] <- self$`offset`
      }
      if (!is.null(self$`total`)) {
        PaginationInfoObject[['total']] <- self$`total`
      }

      PaginationInfoObject
    },
    fromJSON = function(PaginationInfoJson) {
      self$`_raw_json` <- PaginationInfoJson

      PaginationInfoObject <- jsonlite::fromJSON(PaginationInfoJson)
      if (!is.null(PaginationInfoObject$`count`)) {
        self$`count` <- PaginationInfoObject$`count`
      }
      if (!is.null(PaginationInfoObject$`limit`)) {
        self$`limit` <- PaginationInfoObject$`limit`
      }
      if (!is.null(PaginationInfoObject$`offset`)) {
        self$`offset` <- PaginationInfoObject$`offset`
      }
      if (!is.null(PaginationInfoObject$`total`)) {
        self$`total` <- PaginationInfoObject$`total`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "count": %d,
           "limit": %d,
           "offset": %d,
           "total": %d
        }',
                if (is.null(self$`count`)) {
                    'null'
                } else {
                        self$`count`
                }
            ,
                if (is.null(self$`limit`)) {
                    'null'
                } else {
                        self$`limit`
                }
            ,
                if (is.null(self$`offset`)) {
                    'null'
                } else {
                        self$`offset`
                }
            ,
                if (is.null(self$`total`)) {
                    'null'
                } else {
                        self$`total`
                }
            
      )
    },
    fromJSONString = function(PaginationInfoJson) {
      self$`_raw_json` <- PaginationInfoJson

      PaginationInfoObject <- jsonlite::fromJSON(PaginationInfoJson)
      self$`count` <- PaginationInfoObject$`count`
      self$`limit` <- PaginationInfoObject$`limit`
      self$`offset` <- PaginationInfoObject$`offset`
      self$`total` <- PaginationInfoObject$`total`
    }
  )
)
