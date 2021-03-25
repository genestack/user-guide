# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the flowCytometryCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 


RunsResponse <- R6::R6Class(
  'RunsResponse',
  public = list(
    `_raw_json` = NULL,

    `experiment` = NULL,
    `runs` = NULL,
    `versionChainId` = NULL,
    `warnings` = NULL,
    initialize = function(`experiment`, `runs`, `versionChainId`, `warnings`){
      if (!missing(`experiment`)) {
        stopifnot(is.character(`experiment`), length(`experiment`) == 1)
        self$`experiment` <- `experiment`
      }
      if (!missing(`runs`)) {
        stopifnot(is.list(`runs`), length(`runs`) != 0)
        lapply(`runs`, function(x) stopifnot(R6::is.R6(x)))
        self$`runs` <- `runs`
      }
      if (!missing(`versionChainId`)) {
        stopifnot(is.character(`versionChainId`), length(`versionChainId`) == 1)
        self$`versionChainId` <- `versionChainId`
      }
      if (!missing(`warnings`)) {
        stopifnot(is.list(`warnings`), length(`warnings`) != 0)
        lapply(`warnings`, function(x) stopifnot(is.character(x)))
        self$`warnings` <- `warnings`
      }
    },
    toJSON = function() {
      if (!is.null(self$`_raw_json`)) {
        return(jsonlite::fromJSON(self$`_raw_json`))
      }

      RunsResponseObject <- list()
      if (!is.null(self$`experiment`)) {
        RunsResponseObject[['experiment']] <- self$`experiment`
      }
      if (!is.null(self$`runs`)) {
        RunsResponseObject[['runs']] <- lapply(self$`runs`, function(x) x$toJSON())
      }
      if (!is.null(self$`versionChainId`)) {
        RunsResponseObject[['versionChainId']] <- self$`versionChainId`
      }
      if (!is.null(self$`warnings`)) {
        RunsResponseObject[['warnings']] <- self$`warnings`
      }

      RunsResponseObject
    },
    fromJSON = function(RunsResponseJson) {
      self$`_raw_json` <- RunsResponseJson

      RunsResponseObject <- jsonlite::fromJSON(RunsResponseJson)
      if (!is.null(RunsResponseObject$`experiment`)) {
        self$`experiment` <- RunsResponseObject$`experiment`
      }
      if (!is.null(RunsResponseObject$`runs`)) {
        self$`runs` <- lapply(RunsResponseObject$`runs`, function(x) {
          runsObject <- SignalRun$new()
          runsObject$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE))
          runsObject
        })
      }
      if (!is.null(RunsResponseObject$`versionChainId`)) {
        self$`versionChainId` <- RunsResponseObject$`versionChainId`
      }
      if (!is.null(RunsResponseObject$`warnings`)) {
        self$`warnings` <- RunsResponseObject$`warnings`
      }
    },
    toJSONString = function() {
       if (!is.null(self$`_raw_json`)) {
         return(self$`_raw_json`)
       }

       sprintf(
        '{
           "experiment": %s,
           "runs": [%s],
           "versionChainId": %s,
           "warnings": [%s]
        }',
                if (is.null(self$`experiment`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`experiment`)
                }
            ,
        lapply(self$`runs`, function(x) paste(x$toJSON(), sep=",")),
                if (is.null(self$`versionChainId`)) {
                    'null'
                } else {
                        sprintf('"%s"', self$`versionChainId`)
                }
            ,
        lapply(self$`warnings`, function(x) paste(paste0('"', x, '"'), sep=","))
      )
    },
    fromJSONString = function(RunsResponseJson) {
      self$`_raw_json` <- RunsResponseJson

      RunsResponseObject <- jsonlite::fromJSON(RunsResponseJson)
      self$`experiment` <- RunsResponseObject$`experiment`
      self$`runs` <- lapply(RunsResponseObject$`runs`, function(x) SignalRun$new()$fromJSON(jsonlite::toJSON(x, auto_unbox = TRUE)))
      self$`versionChainId` <- RunsResponseObject$`versionChainId`
      self$`warnings` <- RunsResponseObject$`warnings`
    }
  )
)
