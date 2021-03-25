# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the studyCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 

StudySPoTApi <- R6::R6Class(
  'StudySPoTApi',
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
    add_atomic_study = function(source, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`source`)) {
        body <- `source`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/studies/atomic"
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
    add_study = function(source, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`source`)) {
        body <- `source`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/studies"
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
    delete_study = function(id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/studies/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
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
    get_study = function(id, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/studies/{id}"
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
    get_study_by_version = function(id, version, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/studies/{id}/versions/{version}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      if (!missing(`version`)) {
        urlPath <- gsub(paste0("\\{", "version", "\\}"), `version`, urlPath)
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
    get_study_versions = function(id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/studies/{id}/versions"
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
    search_studies = function(filter, query, search_specific_terms, returned_metadata_fields, sort, page_limit, page_offset, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`filter`)) {
        queryParams['filter'] <- filter
      }

      if (!missing(`query`)) {
        queryParams['query'] <- query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      if (!missing(`sort`)) {
        queryParams['sort'] <- sort
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      body <- NULL
      urlPath <- "/studies"
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
    update_atomic_metadata = function(id, body, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`body`)) {
        body <- `body`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/studies/atomic/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "PATCH",
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
    update_study = function(id, body, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`body`)) {
        body <- `body`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/studies/{id}"
      if (!missing(`id`)) {
        urlPath <- gsub(paste0("\\{", "id", "\\}"), `id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "PATCH",
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

#' Create a single new object from a given data file with optional supplied metadata.
#'
#' @param source ## Data
#' \describe See the VariantSource model for details of the data fields.}
#' \item{Metadata:}{The supplied metadata object must be a JSON _object_ with non-empty strings as keys. These are interpreted as attribute names. The values should be either scalar JSON values (null, boolean, number or string), or an type-homogenous array of scalar values.}
#' }
#'
#' @export StudySPoTApi_add_atomic_study
#'
StudySPoTApi_add_atomic_study <- function(source, ...) {
  StudySPoTApi$new()$add_atomic_study(source, ...)
}

#' Add new study object
#'
#' @param source 
#'
#' @export StudySPoTApi_add_study
#'
StudySPoTApi_add_study <- function(source, ...) {
  StudySPoTApi$new()$add_study(source, ...)
}

#' Delete a given study object. This will not delete related objects or links to related objects.
#'
#' @param id Unique identifier (accession) of the object.
#'
#' @export StudySPoTApi_delete_study
#'
StudySPoTApi_delete_study <- function(id, ...) {
  StudySPoTApi$new()$delete_study(id, ...)
}

#' Retrieve a single study object by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export StudySPoTApi_get_study
#'
StudySPoTApi_get_study <- function(id, returned_metadata_fields, ...) {
  StudySPoTApi$new()$get_study(id, returned_metadata_fields, ...)
}

#' Retrieve a single study object by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param version Unique version of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export StudySPoTApi_get_study_by_version
#'
StudySPoTApi_get_study_by_version <- function(id, version, returned_metadata_fields, ...) {
  StudySPoTApi$new()$get_study_by_version(id, version, returned_metadata_fields, ...)
}

#' Retrieve a list of object versions by ID
#'
#' @param id Unique identifier (accession) of the object.
#'
#' @export StudySPoTApi_get_study_versions
#'
StudySPoTApi_get_study_versions <- function(id, ...) {
  StudySPoTApi$new()$get_study_versions(id, ...)
}

#' List or search for study metadata objects
#'
#' @param filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress}   
#' @param query Search for study objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param search_specific_terms If the full-text query term is present in an ODM dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders" in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#' @param sort Attribute to sort by, with optional ascending/descending marker, of the form \code{"[+|-]<key_name>"}.  No marker or \code{"+"} indicates ascending sort, and \code{"-"} indicates descending sort.  *Default:* sort by ID in ascending order.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 100 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#'
#' @export StudySPoTApi_search_studies
#'
StudySPoTApi_search_studies <- function(filter, query, search_specific_terms, returned_metadata_fields, sort, page_limit, page_offset, ...) {
  StudySPoTApi$new()$search_studies(filter, query, search_specific_terms, returned_metadata_fields, sort, page_limit, page_offset, ...)
}

#' Update object metadata
#'
#' @param id Unique identifier (accession) of the object.
#' @param body Metadata in the form of \code{{key: value, key2: value2, ...}}
#'
#' @export StudySPoTApi_update_atomic_metadata
#'
StudySPoTApi_update_atomic_metadata <- function(id, body, ...) {
  StudySPoTApi$new()$update_atomic_metadata(id, body, ...)
}

#' Update a study object
#'
#' @param id Unique identifier (accession) of the object.
#' @param body Metadata in the form of \code{{key: value, key2: value2, ...}}
#'
#' @export StudySPoTApi_update_study
#'
StudySPoTApi_update_study <- function(id, body, ...) {
  StudySPoTApi$new()$update_study(id, body, ...)
}

