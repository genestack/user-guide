library(httr)
library(RJSONIO)

host <- "occam.genestack.com"
token <- "bd7ebdc3ea0ac8be98ecad5a7570589513885a81"

authenticate = function() {
    sign_in = sprintf('https://%s/frontend/endpoint/application/invoke/genestack/signin', host)
    auth = httr::POST(sign_in, body = list(
        method = "authenticateByApiToken",
        parameters = sprintf('["%s"]', token)
    ))
}

GetTemplateValues <- function() {
    authenticate()
    terms = httr::POST(
        sprintf('https://%s/frontend/endpoint/application/invoke/genestack/shell', host),
        body = list(
            method = "dictionaryAutocomplete",
            parameters = '["GSF516042",""]'
        )
    )
    labels = fromJSON(rawToChar(terms$content))$result
    
    return(labels)
}
