library(httr)
library(RJSONIO)

host <- "occam.genestack.com"
token <- "<your token here>"

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

GetCellSubtypes = function(cellType) {
    authenticate()
    terms = httr::POST(
        sprintf('https://%s/frontend/endpoint/application/invoke/genestack/shell', host),
        body = list(
            method = "getDictionaryChildren",
            parameters = sprintf('["GSF501948","subclass_of","%s"]', cellType)
        )
    )
    
    return(fromJSON(rawToChar(terms$content))$result)
}

GetGeneSynonyms = function(genes) {
    authenticate()
    terms = httr::POST(
        sprintf('https://%s/frontend/endpoint/application/invoke/genestack/shell', host),
        body = list(
            method = "getGeneSynonyms",
            parameters = sprintf('["GSF534821", "%s"]', genes)
        )
    )
    
    result = fromJSON(rawToChar(terms$content))$result
    return(do.call(rbind, result))
}
