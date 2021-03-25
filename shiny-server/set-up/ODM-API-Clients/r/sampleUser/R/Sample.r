# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the sampleUser API endpoints for ODM. These are typically used to find and retrieve sample metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 


Sample <- R6::R6Class(
  'Sample',
  public = list(
    `_raw_json` = NULL,

    initialize = function(){
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      SampleObject <- list()

      SampleObject
    },
    fromJSON = function(SampleJson) {
      self$`_raw_json` <- SampleJson

      SampleObject <- jsonlite::fromJSON(SampleJson)
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
    fromJSONString = function(SampleJson) {
      self$`_raw_json` <- SampleJson

      SampleObject <- jsonlite::fromJSON(SampleJson)
    }
  )
)
