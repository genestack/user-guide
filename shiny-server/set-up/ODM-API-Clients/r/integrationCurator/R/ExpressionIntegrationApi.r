# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 

ExpressionIntegrationApi <- R6::R6Class(
  'ExpressionIntegrationApi',
  public = list(
    userAgent = "Swagger-Codegen/1.36.0-1/r",
    apiClient = NULL,
    initialize = function(apiClient){
      if (!missing(apiClient)) {
        self$apiClient <- apiClient
      }
      else {
        self$apiClient <- ApiClient$new()
      }
    },
    create_expression_group_library_group_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/group/{sourceId}/to/library/group/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    create_expression_group_preparation_group_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/group/{sourceId}/to/preparation/group/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    create_expression_group_sample_group_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/group/{sourceId}/to/sample/group/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    create_expression_library_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/{sourceId}/to/library/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    create_expression_preparation_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/{sourceId}/to/preparation/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    create_expression_sample_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/{sourceId}/to/sample/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    delete_expression_group_library_group_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/group/{sourceId}/to/library/group/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    delete_expression_group_preparation_group_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/group/{sourceId}/to/preparation/group/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    delete_expression_group_sample_group_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/group/{sourceId}/to/sample/group/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    delete_expression_library_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/{sourceId}/to/library/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    delete_expression_preparation_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/{sourceId}/to/preparation/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    delete_expression_sample_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/expression/{sourceId}/to/sample/{targetId}"
      if (!missing(`source_id`)) {
        urlPath <- gsub(paste0("\\{", "sourceId", "\\}"), `source_id`, urlPath)
      }

      if (!missing(`target_id`)) {
        urlPath <- gsub(paste0("\\{", "targetId", "\\}"), `target_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        # void response, no need to return anything
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_expression_by_library = function(id, page_limit, page_offset, use_versions, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      body <- NULL
      urlPath <- "/integration/link/expression/by/library/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_expression_by_preparation = function(id, page_limit, page_offset, use_versions, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      body <- NULL
      urlPath <- "/integration/link/expression/by/preparation/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_expression_by_sample = function(id, page_limit, page_offset, use_versions, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/integration/link/expression/by/sample/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_parents_by_study = function(id, use_versions, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/integration/link/expression/group/by/study/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_run_to_library_pairs = function(id, page_limit, page_offset, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      body <- NULL
      urlPath <- "/integration/link/expression/run-to-libraries/by/group/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_run_to_preparation_pairs = function(id, page_limit, page_offset, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      body <- NULL
      urlPath <- "/integration/link/expression/run-to-preparations/by/group/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    },
    get_run_to_sample_pairs = function(id, page_limit, page_offset, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      body <- NULL
      urlPath <- "/integration/link/expression/run-to-samples/by/group/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)
      
      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        json <- httr::content(resp, "text", encoding = "UTF-8")
        if (json == "") {
          responseObject <- NULL
        } else {
          responseObject <- tryCatch(jsonlite::fromJSON(json), error=function(cond) { return(NULL) })
        }
        Response$new(responseObject, json, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", "null", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", "null", resp)
      }

    }
  )
)

#' Create a link between a group of expression objects and a group of library objects
#'
#' @param source_id The ID (accession) of the group of run-level objects (corresponding to a GCT file)
#' @param target_id The ID (accession) of the library group object
#'
#' @export ExpressionIntegrationApi_create_expression_group_library_group_link
#'
ExpressionIntegrationApi_create_expression_group_library_group_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$create_expression_group_library_group_link(source_id, target_id, ...)
}

#' Create a link between a group of expression objects and a group of preparation objects
#'
#' @param source_id The ID (accession) of the group of run-level objects (corresponding to a GCT file)
#' @param target_id The ID (accession) of the preparation group object
#'
#' @export ExpressionIntegrationApi_create_expression_group_preparation_group_link
#'
ExpressionIntegrationApi_create_expression_group_preparation_group_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$create_expression_group_preparation_group_link(source_id, target_id, ...)
}

#' Create a link between a group of expression objects and a group of sample objects
#'
#' @param source_id The ID (accession) of the group of run-level objects (corresponding to a GCT file)
#' @param target_id The ID (accession) of the sample group object
#'
#' @export ExpressionIntegrationApi_create_expression_group_sample_group_link
#'
ExpressionIntegrationApi_create_expression_group_sample_group_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$create_expression_group_sample_group_link(source_id, target_id, ...)
}

#' Create a link between an expression object and a library
#'
#' @param source_id The ID (accession) of the run-level object (corresponding to the column in a VCG/GCT file)
#' @param target_id The ID (accession) of the library object
#'
#' @export ExpressionIntegrationApi_create_expression_library_link
#'
ExpressionIntegrationApi_create_expression_library_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$create_expression_library_link(source_id, target_id, ...)
}

#' Create a link between an expression object and a preparation
#'
#' @param source_id The ID (accession) of the run-level object (corresponding to the column in a VCG/GCT file)
#' @param target_id The ID (accession) of the preparation object
#'
#' @export ExpressionIntegrationApi_create_expression_preparation_link
#'
ExpressionIntegrationApi_create_expression_preparation_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$create_expression_preparation_link(source_id, target_id, ...)
}

#' Create a link between an expression object and a sample
#'
#' @param source_id The ID (accession) of the run-level object (corresponding to the column in a VCG/GCT file)
#' @param target_id The ID (accession) of the sample object
#'
#' @export ExpressionIntegrationApi_create_expression_sample_link
#'
ExpressionIntegrationApi_create_expression_sample_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$create_expression_sample_link(source_id, target_id, ...)
}

#' Delete link between a group of expression objects and a group of library objects
#'
#' @param source_id The ID (accession) of the group of run-level objects (corresponding to a GCT file)
#' @param target_id The ID (accession) of the library group object
#'
#' @export ExpressionIntegrationApi_delete_expression_group_library_group_link
#'
ExpressionIntegrationApi_delete_expression_group_library_group_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$delete_expression_group_library_group_link(source_id, target_id, ...)
}

#' Delete link between a group of expression objects and a group of preparation objects
#'
#' @param source_id The ID (accession) of the group of run-level objects (corresponding to a GCT file)
#' @param target_id The ID (accession) of the preparation group object
#'
#' @export ExpressionIntegrationApi_delete_expression_group_preparation_group_link
#'
ExpressionIntegrationApi_delete_expression_group_preparation_group_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$delete_expression_group_preparation_group_link(source_id, target_id, ...)
}

#' Delete link between a group of expression objects and a group of sample objects
#'
#' @param source_id The ID (accession) of the group of run-level objects (corresponding to a GCT file)
#' @param target_id The ID (accession) of the sample group object
#'
#' @export ExpressionIntegrationApi_delete_expression_group_sample_group_link
#'
ExpressionIntegrationApi_delete_expression_group_sample_group_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$delete_expression_group_sample_group_link(source_id, target_id, ...)
}

#' Delete link between an expression object and a library
#'
#' @param source_id The ID (accession) of the run-level object (corresponding to the column in a VCG/GCT file)
#' @param target_id The ID (accession) of the library object
#'
#' @export ExpressionIntegrationApi_delete_expression_library_link
#'
ExpressionIntegrationApi_delete_expression_library_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$delete_expression_library_link(source_id, target_id, ...)
}

#' Delete link between an expression object and a preparation
#'
#' @param source_id The ID (accession) of the run-level object (corresponding to the column in a VCG/GCT file)
#' @param target_id The ID (accession) of the preparation object
#'
#' @export ExpressionIntegrationApi_delete_expression_preparation_link
#'
ExpressionIntegrationApi_delete_expression_preparation_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$delete_expression_preparation_link(source_id, target_id, ...)
}

#' Delete link between an expression object and a sample
#'
#' @param source_id The ID (accession) of the run-level object (corresponding to the column in a VCG/GCT file)
#' @param target_id The ID (accession) of the sample object
#'
#' @export ExpressionIntegrationApi_delete_expression_sample_link
#'
ExpressionIntegrationApi_delete_expression_sample_link <- function(source_id, target_id, ...) {
  ExpressionIntegrationApi$new()$delete_expression_sample_link(source_id, target_id, ...)
}

#' Retrieve expression run-level data by querying related library ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#'
#' @export ExpressionIntegrationApi_get_expression_by_library
#'
ExpressionIntegrationApi_get_expression_by_library <- function(id, page_limit, page_offset, use_versions, ...) {
  ExpressionIntegrationApi$new()$get_expression_by_library(id, page_limit, page_offset, use_versions, ...)
}

#' Retrieve expression run-level data by querying related preparation ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#'
#' @export ExpressionIntegrationApi_get_expression_by_preparation
#'
ExpressionIntegrationApi_get_expression_by_preparation <- function(id, page_limit, page_offset, use_versions, ...) {
  ExpressionIntegrationApi$new()$get_expression_by_preparation(id, page_limit, page_offset, use_versions, ...)
}

#' Retrieve expression run-level data by querying related sample ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export ExpressionIntegrationApi_get_expression_by_sample
#'
ExpressionIntegrationApi_get_expression_by_sample <- function(id, page_limit, page_offset, use_versions, returned_metadata_fields, ...) {
  ExpressionIntegrationApi$new()$get_expression_by_sample(id, page_limit, page_offset, use_versions, returned_metadata_fields, ...)
}

#' Retrieve group metadata by querying study ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export ExpressionIntegrationApi_get_parents_by_study
#'
ExpressionIntegrationApi_get_parents_by_study <- function(id, use_versions, returned_metadata_fields, ...) {
  ExpressionIntegrationApi$new()$get_parents_by_study(id, use_versions, returned_metadata_fields, ...)
}

#' Retrieve run-library pairs by group id. Pagination is based on unique runs, not unique pairs.
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#'
#' @export ExpressionIntegrationApi_get_run_to_library_pairs
#'
ExpressionIntegrationApi_get_run_to_library_pairs <- function(id, page_limit, page_offset, ...) {
  ExpressionIntegrationApi$new()$get_run_to_library_pairs(id, page_limit, page_offset, ...)
}

#' Retrieve run-preparation pairs by group id. Pagination is based on unique runs, not unique pairs.
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#'
#' @export ExpressionIntegrationApi_get_run_to_preparation_pairs
#'
ExpressionIntegrationApi_get_run_to_preparation_pairs <- function(id, page_limit, page_offset, ...) {
  ExpressionIntegrationApi$new()$get_run_to_preparation_pairs(id, page_limit, page_offset, ...)
}

#' Retrieve run-sample pairs by group id. Pagination is based on unique runs, not unique pairs.
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#'
#' @export ExpressionIntegrationApi_get_run_to_sample_pairs
#'
ExpressionIntegrationApi_get_run_to_sample_pairs <- function(id, page_limit, page_offset, ...) {
  ExpressionIntegrationApi$new()$get_run_to_sample_pairs(id, page_limit, page_offset, ...)
}

