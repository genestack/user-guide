# Roche pRed Layers 4
# 
# This is the API for layer 4 of the Roche pRed project.  This swagger page describes the integrationUser APIs. These are typically used to find and retrieve study, sample and processed (signal) data and metadata for a given query.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears   The server response will be in the section that follows.
# 
# API version: v0.1
# 

OmicsQueriesApi <- R6::R6Class(
  'OmicsQueriesApi',
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
    search_expression_data = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/expression/data"
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
    search_expression_groups = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/expression/group"
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
    search_flow_cytometry_data = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, page_offset, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/flow-cytometry/data"
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
    search_flow_cytometry_groups = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/flow-cytometry/group"
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
    search_samples = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/samples"
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
    search_streamed_expression_data = function(group_accession, sample_filter, sample_query, search_specific_terms, feature_list, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`feature_list`)) {
        queryParams['featureList'] <- feature_list
      }

      if (!missing(`group_accession`)) {
        queryParams['groupAccession'] <- group_accession
      }

      body <- NULL
      urlPath <- "/omics/expression/streamed-data"
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
    search_variant_data = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, page_offset, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`page_offset`)) {
        queryParams['pageOffset'] <- page_offset
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/variant/data"
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
    search_variant_groups = function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`study_filter`)) {
        queryParams['studyFilter'] <- study_filter
      }

      if (!missing(`study_query`)) {
        queryParams['studyQuery'] <- study_query
      }

      if (!missing(`sample_filter`)) {
        queryParams['sampleFilter'] <- sample_filter
      }

      if (!missing(`sample_query`)) {
        queryParams['sampleQuery'] <- sample_query
      }

      if (!missing(`search_specific_terms`)) {
        queryParams['searchSpecificTerms'] <- search_specific_terms
      }

      if (!missing(`vx_query`)) {
        queryParams['vxQuery'] <- vx_query
      }

      if (!missing(`vx_filter`)) {
        queryParams['vxFilter'] <- vx_filter
      }

      if (!missing(`ex_query`)) {
        queryParams['exQuery'] <- ex_query
      }

      if (!missing(`ex_filter`)) {
        queryParams['exFilter'] <- ex_filter
      }

      if (!missing(`fx_query`)) {
        queryParams['fxQuery'] <- fx_query
      }

      if (!missing(`fx_filter`)) {
        queryParams['fxFilter'] <- fx_filter
      }

      if (!missing(`use_versions`)) {
        queryParams['useVersions'] <- use_versions
      }

      if (!missing(`cursor`)) {
        queryParams['cursor'] <- cursor
      }

      if (!missing(`page_limit`)) {
        queryParams['pageLimit'] <- page_limit
      }

      body <- NULL
      urlPath <- "/omics/variant/group"
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

#' Retrieve expression data objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_expression_data
#'
OmicsQueriesApi_search_expression_data <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_expression_data(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...)
}

#' Retrieve group objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_expression_groups
#'
OmicsQueriesApi_search_expression_groups <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_expression_groups(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...)
}

#' Retrieve flow cytometry data objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_flow_cytometry_data
#'
OmicsQueriesApi_search_flow_cytometry_data <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, page_offset, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_flow_cytometry_data(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, page_offset, cursor, page_limit, ...)
}

#' Retrieve group objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_flow_cytometry_groups
#'
OmicsQueriesApi_search_flow_cytometry_groups <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_flow_cytometry_groups(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...)
}

#' Retrieve sample metadata objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_samples
#'
OmicsQueriesApi_search_samples <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_samples(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...)
}

#' Retrieve expression levels streamingly
#'
#' @param group_accession Accession of the group which contains the reference to the expression matrix
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param feature_list Filter results by specific feature (eg. Gene identifier). The feature parameter value must match the name of the identifier in the GCT file (under the NAME column). Example: \code{ENSG00000077044}
#'
#' @export OmicsQueriesApi_search_streamed_expression_data
#'
OmicsQueriesApi_search_streamed_expression_data <- function(group_accession, sample_filter, sample_query, search_specific_terms, feature_list, ...) {
  OmicsQueriesApi$new()$search_streamed_expression_data(group_accession, sample_filter, sample_query, search_specific_terms, feature_list, ...)
}

#' Retrieve variant data objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param page_offset Show the page {pageOffset+1} results from the start of the results. E.g. 100 will show a page of results  starting from the 101st result. The default value is 0.
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_variant_data
#'
OmicsQueriesApi_search_variant_data <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, page_offset, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_variant_data(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, page_offset, cursor, page_limit, ...)
}

#' Retrieve group objects by searching across multiple data types
#'
#' @param study_filter Filter by study metadata (key-value metadata pair(s)). E.g. \code{"Study Source"=ArrayExpress} 
#' @param study_query Search for objects via a full-text query over all study metadata fields. E.g. \code{"RNA-Seq of human dendritic cells"}
#' @param sample_filter Filter by sample metadata (key-value metadata pair(s)). E.g. \code{"Species or strain"="Homo sapiens"} 
#' @param sample_query Search for objects via a full-text query over all sample metadata fields. E.g. \code{Clozapine}
#' @param search_specific_terms If the full-text query term is present in an RTS dictionary, enabling this parameter will modify the query to include child terms of the full-text query.  For example, the search query "Body fluid" can be expanded to include the term "Blood" (a child term of  "Body fluid") so files containing either "Body fluid" or  "Blood"  in their metadata will be returned in the search results.  The parent-child relationship is defined by the key "broaders"  in the dictionary.  If the full query term is not present in a dictionary then this parameter has no effect.
#' @param vx_query Search for objects linked to variant data via data query (key-value pair(s)). E.g.  \code{VariationId=rs548419688|rs544419019}  \code{Intervals=12:23432-234324,30:234324-23432} \code{Gene=ASPM,BRCA1}  \code{Reference=A|T Alteration=C|G} \code{Quality=(0.9:1.0)}  \code{Type=SNP|MNP|INS|DEL|MIXED}  \code{info_VT=DEL}  \code{info_EUR_AF=(0.9:1.0)} \code{Start=12340} \code{AllelesNumber=1} \code{AlterationNumber=2}
#' @param vx_filter Filter by variant metadata (key-value metadata pair(s)). E.g. \code{"Variant Source"=dbSNP}  
#' @param ex_query Search for objects linked to expression data via data query (key-value pair(s)). E.g. \code{Feature=ENSG00000230368,ENSG00000188976 MinValue=1.50} 
#' @param ex_filter Filter by expression metadata (key-value metadata pair(s)). E.g. \code{"Genome Version"=hg19-BROAD}   
#' @param fx_query Search for objects linked to flow cytometry data via data query (key-value pair(s)). E.g. \code{ReadoutType=Median|Count} \code{CellPopulation="CD45+, live"} \code{MinValue=3.5}
#' @param fx_filter Filter by flow cytometry metadata (key-value metadata pair(s)). E.g. \code{Organ=blood}   
#' @param use_versions Specify which versions of omics data files are used in the query. By default the active version is used. See Versioning above. Syntax:  \\* or \code{v<version number>} or \code{<CHAIN_ID>}:\code{v<version number>} or \code{<CHAIN_ID>}:\code{<accession1,accession2,..>}
#' @param cursor The page tag to resume results from (see paging above).
#' @param page_limit How many results to retrieve per page. The default is 2000
#'
#' @export OmicsQueriesApi_search_variant_groups
#'
OmicsQueriesApi_search_variant_groups <- function(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...) {
  OmicsQueriesApi$new()$search_variant_groups(study_filter, study_query, sample_filter, sample_query, search_specific_terms, vx_query, vx_filter, ex_query, ex_filter, fx_query, fx_filter, use_versions, cursor, page_limit, ...)
}

