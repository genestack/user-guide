library(httr)
library(RJSONIO)

host <- 'occam.genestack.com'
token <- '<your token here>'

authenticate = function() {
    sign_in = sprintf('https://%s/frontend/endpoint/application/invoke/genestack/signin', host)
    auth = httr::POST(sign_in, body = list(
        method = 'authenticateByApiToken',
        parameters = sprintf('["%s"]', token)
    ))
}

# `genes` is a vector of selected genes (string).
# `genes_table` is expected to have the following columns:
#   1. `ensembl_id`;
#   2. `gene_symbol`;
#   3. `uniprot_symbol`;
#   4. `gene_synonyms`.
GetGeneSynonyms <- function(genes, genes_table) {
    if (is_empty(genes) || genes == '') {
        return('')
    }

    synonyms <- genes_table[genes_table$gene_symbol %in% genes, c('ensembl_id', 'gene_synonyms', 'uniprot_symbol')]
    combined <- c(genes, synonyms$ensembl_id, synonyms$gene_synonyms, synonyms$uniprot_symbol)
    return(unique(combined[!is.na(combined) && combined != ""]))
}
