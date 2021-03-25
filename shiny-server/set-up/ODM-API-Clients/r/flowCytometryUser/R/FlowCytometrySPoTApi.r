# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the flowCytometryUser API endpoints for ODM. These are typically used to find and retrieve flow cytometry data and metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 

FlowCytometrySPoTApi <- R6::R6Class(
  'FlowCytometrySPoTApi',
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
    get_flow_cytometry = function(id, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/flow-cytometry/{id}"
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
    get_flow_cytometry_by_version = function(id, version, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/flow-cytometry/{id}/versions/{version}"
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
    get_flow_cytometry_data = function(filter, query, search_specific_terms, run_filter, readout_type, population, marker, min_value, use_versions, returned_metadata_fields, page_limit, cursor, ...){
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

      if (!missing(`run_filter`)) {
        queryParams['runFilter'] <- run_filter
      }

      if (!missing(`readout_type`)) {
        queryParams['readoutType'] <- readout_type
      }

      if (!missing(`population`)) {
        queryParams['population'] <- population
      }

      if (!missing(`marker`)) {
        queryParams['marker'] <- marker
      }

      if (!missing(`min_value`)) {
        queryParams['minValue'] <- min_value
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      body <- NULL
      urlPath <- "/flow-cytometry"
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
    get_flow_cytometry_versions = function(id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/flow-cytometry/{id}/versions"
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
    get_group = function(id, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/flow-cytometry/group/{id}"
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
    get_group_by_run = function(id, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/flow-cytometry/group/by/run/{id}"
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
    search_groups = function(filter, query, search_specific_terms, use_versions, returned_metadata_fields, page_offset, page_limit, ...){
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

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/flow-cytometry/group"
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
    search_runs = function(id, page_offset, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/flow-cytometry/runs/by/group/{id}"
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

#' Retrieve a single sample flow cytometry by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export FlowCytometrySPoTApi_get_flow_cytometry
#'
FlowCytometrySPoTApi_get_flow_cytometry <- function(id, returned_metadata_fields, ...) {
  FlowCytometrySPoTApi$new()$get_flow_cytometry(id, returned_metadata_fields, ...)
}

#' Retrieve a single sample flow cytometry by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param version Unique version of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export FlowCytometrySPoTApi_get_flow_cytometry_by_version
#'
FlowCytometrySPoTApi_get_flow_cytometry_by_version <- function(id, version, returned_metadata_fields, ...) {
  FlowCytometrySPoTApi$new()$get_flow_cytometry_by_version(id, version, returned_metadata_fields, ...)
}

#' Retrieve multiple flow cytometry data and metadata objects
#'
#' @param filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}  
#' @param query Search for flow cytometry objects via a full text query over all flow cytometry metadata.
#' @param search_specific_terms If the full-text query term is present in an ODM dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders" in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param run_filter Genestack accession that corresponds to the fcy column used to link flow cytometry data from the same run to a sample
#' @param readout_type Required value of "Readout type" column. E.g.: \code{Count}, \code{Median}
#' @param population Value of "Cell Population" column. E.g.: \code{"total cells"}, \code{CD45+,live/CD45+}, \code{CD3+}.  Note that if this value contains special characters like \code{/} which is used as a URI path separator, such characters should be escaped manually before sending request. For example, \code{/} should be escaped as \code{\%2F}.
#' @param marker Marker value. E.g.: \code{PD1}, \code{BV786}
#' @param min_value Minimum threshold (inclusive) for returned expression values.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#' @param page_limit Maximum number of results to return per page (see Paging above). This value must be between 0 and 2000 (inclusive). The default is 2000.
#' @param cursor The page tag to resume results from (see paging above).
#'
#' @export FlowCytometrySPoTApi_get_flow_cytometry_data
#'
FlowCytometrySPoTApi_get_flow_cytometry_data <- function(filter, query, search_specific_terms, run_filter, readout_type, population, marker, min_value, use_versions, returned_metadata_fields, page_limit, cursor, ...) {
  FlowCytometrySPoTApi$new()$get_flow_cytometry_data(filter, query, search_specific_terms, run_filter, readout_type, population, marker, min_value, use_versions, returned_metadata_fields, page_limit, cursor, ...)
}

#' Retrieve a list of object versions by ID
#'
#' @param id Unique identifier (accession) of the object.
#'
#' @export FlowCytometrySPoTApi_get_flow_cytometry_versions
#'
FlowCytometrySPoTApi_get_flow_cytometry_versions <- function(id, ...) {
  FlowCytometrySPoTApi$new()$get_flow_cytometry_versions(id, ...)
}

#' Retrieve a single group object by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export FlowCytometrySPoTApi_get_group
#'
FlowCytometrySPoTApi_get_group <- function(id, returned_metadata_fields, ...) {
  FlowCytometrySPoTApi$new()$get_group(id, returned_metadata_fields, ...)
}

#' Retrieve a single group object by run ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export FlowCytometrySPoTApi_get_group_by_run
#'
FlowCytometrySPoTApi_get_group_by_run <- function(id, returned_metadata_fields, ...) {
  FlowCytometrySPoTApi$new()$get_group_by_run(id, returned_metadata_fields, ...)
}

#' Retrieve groups that match a query
#'
#' @param filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}  
#' @param query Search for flow cytometry objects via a full text query over all flow cytometry metadata.
#' @param search_specific_terms If the full-text query term is present in an ODM dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders" in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param page_limit Maximum number of results to return per page (see Paging above). This value must be between 0 and 2000 (inclusive). The default is 2000.
#'
#' @export FlowCytometrySPoTApi_search_groups
#'
FlowCytometrySPoTApi_search_groups <- function(filter, query, search_specific_terms, use_versions, returned_metadata_fields, page_offset, page_limit, ...) {
  FlowCytometrySPoTApi$new()$search_groups(filter, query, search_specific_terms, use_versions, returned_metadata_fields, page_offset, page_limit, ...)
}

#' Retrieve run objects related to the given group
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param page_limit Maximum number of results to return per page (see Paging above). This value must be between 0 and 2000 (inclusive). The default is 2000.
#'
#' @export FlowCytometrySPoTApi_search_runs
#'
FlowCytometrySPoTApi_search_runs <- function(id, page_offset, page_limit, ...) {
  FlowCytometrySPoTApi$new()$search_runs(id, page_offset, page_limit, ...)
}

