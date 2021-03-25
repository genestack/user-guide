# Roche pRed Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationUser APIs. These are typically used to find and retrieve study, sample and processed (signal) data and metadata for a given query.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears   The server response will be in the section that follows.
# 
# API version: v0.1
# 

LinkageApi <- R6::R6Class(
  'LinkageApi',
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
    get_data_types = function(...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/data-types"
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
    get_data_types_links = function(type, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`type`)) {
        queryParams['type'] <- type
      }

      body <- NULL
      urlPath <- "/data-types/links"
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
    get_links_by_ids = function(request, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`request`)) {
        body <- `request`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/links/get-batch"
      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
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
    get_links_by_params = function(first_id, first_type, second_id, second_type, offset, limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`first_id`)) {
        queryParams['firstId'] <- first_id
      }

      if (!missing(`first_type`)) {
        queryParams['firstType'] <- first_type
      }

      if (!missing(`second_id`)) {
        queryParams['secondId'] <- second_id
      }

      if (!missing(`second_type`)) {
        queryParams['secondType'] <- second_type
      }

      if (!missing(`offset`)) {
        queryParams['offset'] <- offset
      }

      if (!missing(`limit`)) {
        queryParams['limit'] <- limit
      }

      body <- NULL
      urlPath <- "/links"
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

#' Lists all available data types.
#'
#'
#' @export LinkageApi_get_data_types
#'
LinkageApi_get_data_types <- function(...) {
  LinkageApi$new()$get_data_types(...)
}

#' List all possible links between data types that match the specified criteria.
#'
#' @param type Return only links with the specified data type.
#'
#' @export LinkageApi_get_data_types_links
#'
LinkageApi_get_data_types_links <- function(type, ...) {
  LinkageApi$new()$get_data_types_links(type, ...)
}

#' Finds existing links by passing many IDs.  Pagination goes through all links matched the criteria.
#'
#' @param request 
#'
#' @export LinkageApi_get_links_by_ids
#'
LinkageApi_get_links_by_ids <- function(request, ...) {
  LinkageApi$new()$get_links_by_ids(request, ...)
}

#' Finds existing links matching the specified criteria.
#'
#' @param first_id Object ID (accession) (e.g. accession of study)
#' @param first_type Type of the object (e.g. study)
#' @param second_id Object ID (accession) (e.g. accession of study)
#' @param second_type Type of the object (e.g. study)
#' @param offset Param says to skip that many links before beginning to return links.
#' @param limit Param says to limit the count of returned links.
#'
#' @export LinkageApi_get_links_by_params
#'
LinkageApi_get_links_by_params <- function(first_id, first_type, second_id, second_type, offset, limit, ...) {
  LinkageApi$new()$get_links_by_params(first_id, first_type, second_id, second_type, offset, limit, ...)
}

