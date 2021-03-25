Response  <- R6::R6Class(
  'Response',
  public = list(
    content = NULL,
    json = NULL,
    response = NULL,
    initialize = function(content, json, response){
      self$content <- content
      self$json <- json
      self$response <- response
    }
  )
)
