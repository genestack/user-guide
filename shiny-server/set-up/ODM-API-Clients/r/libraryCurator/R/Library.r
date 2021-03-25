# Roche pRed Layers 3
# 
# This swagger page describes the libraryCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


Library <- R6::R6Class(
  'Library',
  public = list(
    `_raw_json` = NULL,

    initialize = function(){
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      LibraryObject <- list()

      LibraryObject
    },
    fromJSON = function(LibraryJson) {
      self$`_raw_json` <- LibraryJson

      LibraryObject <- jsonlite::fromJSON(LibraryJson)
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
        }',
      )
    },
    fromJSONString = function(LibraryJson) {
      self$`_raw_json` <- LibraryJson

      LibraryObject <- jsonlite::fromJSON(LibraryJson)
    }
  )
)
