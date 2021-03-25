# Roche pRed Layers 3
# 
# This swagger page describes the preparationUser API endpoints for ODM. These are typically used to find and retrieve preparation metadata.  Before carrying out any API calls you will need an API token. API tokens can be obtained under your profile within the Genestack software. Further instructions can be found [here](https://odm-user-guide.readthedocs.io/en/latest/doc-odm-user-guide/getting-a-genestack-api-token.html).  To try out calls in this swagger page:  1.  Click the 'Authorize' button below to enter your API token 2.  Scroll to the 'Parameters' section for the method you wish to try out and click the 'Try it out' button 3.  Enter parameter values that you wish to try 4.  Scroll to the bottom of the Parameters section and click the 'Execute' bar that appears    The server response will be in the section that follows.
# 
# API version: v0.1
# 


ApiClient  <- R6::R6Class(
  'ApiClient',
  public = list(
    host = NULL,
    token = NULL,
    scheme = 'https',
    version = 'v0.1',
    basePath = NULL,
    defaultHeaders = NULL,
    userAgent = NULL,
    initialize = function(host = NULL, token = NULL, scheme = NULL, version = NULL){
        envHost = private$readParameterFromEnv('PRED_SPOT_HOST')
        envToken = private$readParameterFromEnv('PRED_SPOT_TOKEN')
        envScheme = private$readParameterFromEnv('PRED_SPOT_SCHEME')
        envVersion = private$readParameterFromEnv('PRED_SPOT_VERSION')

        if (!missing(host)) {
            self$host <- host
        } else if (!is.null(envHost)) {
            self$host <- envHost
        } else {
            stop('Host not given explicitly or via environment variable!')
        }
        if (!missing(token)) {
            self$token <- token
        } else if (!is.null(envToken)) {
            self$token <- envToken
        } else {
            stop('Token not given explicitly or via environment variable!')
        }
        if (!missing(scheme)) {
            self$scheme <- scheme
        } else if (!is.null(envScheme)) {
            self$scheme <- envScheme
        }
        if (!missing(version)) {
            self$version <- version
        } else if (!is.null(envVersion)) {
            self$version <- envVersion
        }
        self$basePath <- sprintf('%s://%s/frontend/rs/genestack/preparationUser/%s',
            self$scheme,
            self$host,
            self$version
        )
        self$defaultHeaders <- c(
            'Genestack-API-Token' = self$token,
            'Content-Type' = 'application/json',
            'Accept-Encoding' = 'gzip, deflate'
        )
        self$`userAgent` <- 'Swagger-Codegen/1.36.0-1/r'
    },
    callApi = function(url, method, queryParams, headerParams, body, ...){
        allHeaderParams = c(self$defaultHeaders, headerParams)
        headers <- httr::add_headers(allHeaderParams)

        if (method == "GET") {
            httr::GET(url, headers, query = queryParams,...)
        }
        else if (method == "POST") {
            httr::POST(url, headers, query = queryParams, body = body, ...)
        }
        else if (method == "PUT") {
            httr::PUT(url, headers, query = queryParams, body = body, ...)
        }
        else if (method == "PATCH") {
            httr::PATCH(url, headers, query = queryParams, body = body, ...)
        }
        else if (method == "HEAD") {
            httr::HEAD(url, headers, query = queryParams, ...)
        }
        else if (method == "DELETE") {
            httr::DELETE(url, headers, query = queryParams, ...)
        }
        else {
            stop("http method must be `GET`, `HEAD`, `OPTIONS`, `POST`, `PATCH`, `PUT` or `DELETE`.")
        }
    }
  ),
  private = list(
    readParameterFromEnv = function(name) {
        envVar = Sys.getenv(name)
        if (envVar == '') {
            return(NULL)
        }
        return(envVar)
    }
  )
)
