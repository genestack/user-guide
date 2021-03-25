# Roche pRed Layers 3
# 
# This is the API for layer 3 of the Roche pRed project.  This swagger page describes the expressionUser API endpoints for ODM. These are typically used to find and retrieve expression data and metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 

ExpressionSPoTApi <- R6::R6Class(
  'ExpressionSPoTApi',
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
    get_expression = function(id, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/expression/{id}"
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
    get_expression_by_version = function(id, version, returned_metadata_fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`returned_metadata_fields`)) {
        queryParams['returnedMetadataFields'] <- returned_metadata_fields
      }

      body <- NULL
      urlPath <- "/expression/{id}/versions/{version}"
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
    get_expression_data = function(filter, query, search_specific_terms, run_filter, min_expression_level, feature_list, use_versions, returned_metadata_fields, page_limit, cursor, ...){
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

      if (!missing(`min_expression_level`)) {
        queryParams['minExpressionLevel'] <- min_expression_level
      }

      if (!missing(`feature_list`)) {
        queryParams['featureList'] <- feature_list
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
      urlPath <- "/expression"
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
    get_expression_versions = function(id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      body <- NULL
      urlPath <- "/expression/{id}/versions"
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
      urlPath <- "/expression/group/{id}"
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
      urlPath <- "/expression/group/by/run/{id}"
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
    search_groups = function(filter, query, search_specific_terms, returned_metadata_fields, use_versions, page_offset, page_limit, ...){
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

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/expression/group"
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
      urlPath <- "/expression/runs/by/group/{id}"
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

#' Retrieve a single expression object by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export ExpressionSPoTApi_get_expression
#'
ExpressionSPoTApi_get_expression <- function(id, returned_metadata_fields, ...) {
  ExpressionSPoTApi$new()$get_expression(id, returned_metadata_fields, ...)
}

#' Retrieve a single expression object by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param version Unique version of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export ExpressionSPoTApi_get_expression_by_version
#'
ExpressionSPoTApi_get_expression_by_version <- function(id, version, returned_metadata_fields, ...) {
  ExpressionSPoTApi$new()$get_expression_by_version(id, version, returned_metadata_fields, ...)
}

#' Retrieve multiple expression data and metadata objects
#'
#' @param filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Normalization Method"=TPM}. 
#' @param query Search for expression objects via a full text query over all expression metadata. E.g. \code{TPM}.
#' @param search_specific_terms If the full-text query term is present in an ODM dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders" in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param run_filter Genestack accession that corresponds to the gct column used to link expression data from the same run to a sample.
#' @param min_expression_level Minimum threshold (inclusive) for returned expression values.
#' @param feature_list List of features to return. These features must match exactly the probe IDs in the GCT file. Example: \code{featureList=1552256_a_at&featureList=1552269_at}
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#' @param page_limit Maximum number of results to return per page (see Paging above). This value must be between 0 and 2000 (inclusive). The default is 2000.
#' @param cursor The page tag to resume results from (see paging above).
#'
#' @export ExpressionSPoTApi_get_expression_data
#'
ExpressionSPoTApi_get_expression_data <- function(filter, query, search_specific_terms, run_filter, min_expression_level, feature_list, use_versions, returned_metadata_fields, page_limit, cursor, ...) {
  ExpressionSPoTApi$new()$get_expression_data(filter, query, search_specific_terms, run_filter, min_expression_level, feature_list, use_versions, returned_metadata_fields, page_limit, cursor, ...)
}

#' Retrieve a list of object versions by ID
#'
#' @param id Unique identifier (accession) of the object.
#'
#' @export ExpressionSPoTApi_get_expression_versions
#'
ExpressionSPoTApi_get_expression_versions <- function(id, ...) {
  ExpressionSPoTApi$new()$get_expression_versions(id, ...)
}

#' Retrieve a single group object by ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export ExpressionSPoTApi_get_group
#'
ExpressionSPoTApi_get_group <- function(id, returned_metadata_fields, ...) {
  ExpressionSPoTApi$new()$get_group(id, returned_metadata_fields, ...)
}

#' Retrieve a single group object by run ID (accession)
#'
#' @param id Unique identifier (accession) of the object.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#'
#' @export ExpressionSPoTApi_get_group_by_run
#'
ExpressionSPoTApi_get_group_by_run <- function(id, returned_metadata_fields, ...) {
  ExpressionSPoTApi$new()$get_group_by_run(id, returned_metadata_fields, ...)
}

#' Retrieve groups that match a query
#'
#' @param filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Normalization Method"=TPM}. 
#' @param query Search for expression objects via a full text query over all expression metadata. E.g. \code{TPM}.
#' @param search_specific_terms If the full-text query term is present in an ODM dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders" in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param returned_metadata_fields The parameter defines amount of metadata attributes to return:  1. \code{template} - return metadata attributes according to applied template, if object doesn’t have applied template default template will be used. This is the default for User endpoints. 2. \code{all} - return all metadata attributes with values and null attributes, if they are present in the applied template. This is the default for Curator endpoints.
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param page_limit Maximum number of results to return per page (see Paging above). This value must be between 0 and 2000 (inclusive). The default is 2000.
#'
#' @export ExpressionSPoTApi_search_groups
#'
ExpressionSPoTApi_search_groups <- function(filter, query, search_specific_terms, returned_metadata_fields, use_versions, page_offset, page_limit, ...) {
  ExpressionSPoTApi$new()$search_groups(filter, query, search_specific_terms, returned_metadata_fields, use_versions, page_offset, page_limit, ...)
}

#' Retrieve run objects related to the given group
#'
#' @param id Unique identifier (accession) of the object.
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param page_limit Maximum number of results to return per page (see Paging above). This value must be between 0 and 2000 (inclusive). The default is 2000.
#'
#' @export ExpressionSPoTApi_search_runs
#'
ExpressionSPoTApi_search_runs <- function(id, page_offset, page_limit, ...) {
  ExpressionSPoTApi$new()$search_runs(id, page_offset, page_limit, ...)
}

