# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the sampleUser API endpoints for ODM. These are typically used to find and retrieve sample metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 


CommitInfo <- R6::R6Class(
  'CommitInfo',
  public = list(
    `_raw_json` = NULL,

    `author` = NULL,
    `message` = NULL,
    `timestamp` = NULL,
    `version` = NULL,
    initialize = function(`author`, `message`, `timestamp`, `version`){
      if (!missing(`author`)) {
        stopifnot(is.character(`author`), length(`author`) == 1)
        self$`author` <- `author`
      }
      if (!missing(`message`)) {
        stopifnot(is.character(`message`), length(`message`) == 1)
        self$`message` <- `message`
      }
      if (!missing(`timestamp`)) {
        stopifnot(is.numeric(`timestamp`), length(`timestamp`) == 1)
        self$`timestamp` <- `timestamp`
      }
      if (!missing(`version`)) {
        stopifnot(is.character(`version`), length(`version`) == 1)
        self$`version` <- `version`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      CommitInfoObject <- list()
      if (!is.null(self$`author`)) {
        CommitInfoObject[['author']] <- self$`author`
      }
      if (!is.null(self$`message`)) {
        CommitInfoObject[['message']] <- self$`message`
      }
      if (!is.null(self$`timestamp`)) {
        CommitInfoObject[['timestamp']] <- self$`timestamp`
      }
      if (!is.null(self$`version`)) {
        CommitInfoObject[['version']] <- self$`version`
      }

      CommitInfoObject
    },
    fromJSON = function(CommitInfoJson) {
      self$`_raw_json` <- CommitInfoJson

      CommitInfoObject <- jsonlite::fromJSON(CommitInfoJson)
      if (!is.null(CommitInfoObject$`author`)) {
        self$`author` <- CommitInfoObject$`author`
      }
      if (!is.null(CommitInfoObject$`message`)) {
        self$`message` <- CommitInfoObject$`message`
      }
      if (!is.null(CommitInfoObject$`timestamp`)) {
        self$`timestamp` <- CommitInfoObject$`timestamp`
      }
      if (!is.null(CommitInfoObject$`version`)) {
        self$`version` <- CommitInfoObject$`version`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "author": %s,
           "message": %s,
           "timestamp": %d,
           "version": %s
        }',
                if (is.null(self$`author`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`author`)
                }
            ,
                if (is.null(self$`message`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`message`)
                }
            ,
                if (is.null(self$`timestamp`)) {
                    'null'
                } else {
                        self$`timestamp`
                }
            ,
                if (is.null(self$`version`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`version`)
                }
            
      )
    },
    fromJSONString = function(CommitInfoJson) {
      self$`_raw_json` <- CommitInfoJson

      CommitInfoObject <- jsonlite::fromJSON(CommitInfoJson)
      self$`author` <- CommitInfoObject$`author`
      self$`message` <- CommitInfoObject$`message`
      self$`timestamp` <- CommitInfoObject$`timestamp`
      self$`version` <- CommitInfoObject$`version`
    }
  )
)
