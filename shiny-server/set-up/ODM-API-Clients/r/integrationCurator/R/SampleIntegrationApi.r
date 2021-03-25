# Roche pRed Curator Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationCurator APIs.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software.  To try out calls in this swagger page:  1. Click the 'Authorize' button below to enter your API token 2. Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3. Enter parameter values that you wish to try 4. Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears  The server response will be in the section that follows.
# 
# API version: v0.1
# 

SampleIntegrationApi <- R6::R6Class(
  'SampleIntegrationApi',
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
    create_sample_group_study_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/sample/group/{sourceId}/to/study/{targetId}"
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
    create_sample_study_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/sample/{sourceId}/to/study/{targetId}"
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
    delete_sample_group_study_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/sample/group/{sourceId}/to/study/{targetId}"
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
    delete_sample_study_link = function(source_id, target_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/integration/link/sample/{sourceId}/to/study/{targetId}"
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
    get_samples_by_libraries = function(filter, query, search_specific_terms, page_limit, page_offset, returned_metadata_fields, ...){
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

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/integration/link/samples/by/libraries"
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
    get_samples_by_preparations = function(filter, query, search_specific_terms, page_limit, page_offset, returned_metadata_fields, ...){
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

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/integration/link/samples/by/preparations"
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
    get_samples_by_study = function(id, page_limit, page_offset, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/integration/link/samples/by/study/{id}"
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

#' Create a link between a group of sample objects and a study
#'
#' @param source_id The ID (accession) of the sample group object
#' @param target_id The ID (accession) of the study object
#'
#' @export SampleIntegrationApi_create_sample_group_study_link
#'
SampleIntegrationApi_create_sample_group_study_link <- function(source_id, target_id, ...) {
  SampleIntegrationApi$new()$create_sample_group_study_link(source_id, target_id, ...)
}

#' Create a link between a sample and a study
#'
#' @param source_id The ID (accession) of the sample object
#' @param target_id The ID (accession) of the study object
#'
#' @export SampleIntegrationApi_create_sample_study_link
#'
SampleIntegrationApi_create_sample_study_link <- function(source_id, target_id, ...) {
  SampleIntegrationApi$new()$create_sample_study_link(source_id, target_id, ...)
}

#' Delete link between a group of sample objects and a study
#'
#' @param source_id The ID (accession) of the sample group object
#' @param target_id The ID (accession) of the study object
#'
#' @export SampleIntegrationApi_delete_sample_group_study_link
#'
SampleIntegrationApi_delete_sample_group_study_link <- function(source_id, target_id, ...) {
  SampleIntegrationApi$new()$delete_sample_group_study_link(source_id, target_id, ...)
}

#' Delete link between a sample and a study
#'
#' @param source_id The ID (accession) of the sample object
#' @param target_id The ID (accession) of the study object
#'
#' @export SampleIntegrationApi_delete_sample_study_link
#'
SampleIntegrationApi_delete_sample_study_link <- function(source_id, target_id, ...) {
  SampleIntegrationApi$new()$delete_sample_study_link(source_id, target_id, ...)
}

#' Retrieve sample metadata by querying related libraries
#'
#' @param filter Filter by library metadata (key-value metadata pair(s)). E.g. "Species or strain"="Homo sapiens"
#' @param query Search for objects via a full-text query over all library metadata fields. E.g. "RNA-Seq of human dendritic cells"
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export SampleIntegrationApi_get_samples_by_libraries
#'
SampleIntegrationApi_get_samples_by_libraries <- function(filter, query, search_specific_terms, page_limit, page_offset, returned_metadata_fields, ...) {
  SampleIntegrationApi$new()$get_samples_by_libraries(filter, query, search_specific_terms, page_limit, page_offset, returned_metadata_fields, ...)
}

#' Retrieve sample metadata by querying related preparations
#'
#' @param filter Filter by preparation metadata (key-value metadata pair(s)). E.g. "Species or strain"="Homo sapiens"
#' @param query Search for study metadata objects via a full-text query over all preparation metadata fields. E.g. "RNA-Seq of human dendritic cells"
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export SampleIntegrationApi_get_samples_by_preparations
#'
SampleIntegrationApi_get_samples_by_preparations <- function(filter, query, search_specific_terms, page_limit, page_offset, returned_metadata_fields, ...) {
  SampleIntegrationApi$new()$get_samples_by_preparations(filter, query, search_specific_terms, page_limit, page_offset, returned_metadata_fields, ...)
}

#' Retrieve sample metadata by querying related study ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_limit Maximum number of results to return. This value must be between 0 and 2000 (inclusive).
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export SampleIntegrationApi_get_samples_by_study
#'
SampleIntegrationApi_get_samples_by_study <- function(id, page_limit, page_offset, returned_metadata_fields, ...) {
  SampleIntegrationApi$new()$get_samples_by_study(id, page_limit, page_offset, returned_metadata_fields, ...)
}

