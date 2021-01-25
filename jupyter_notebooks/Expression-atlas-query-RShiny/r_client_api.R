library(studyCurator)
library(integrationCurator)

GetStudies <- function(therapeutic.area, study_type) {
    start_time <- Sys.time()
    filter = sprintf('"Therapeutic Area"="%s" AND "Study Type"="%s"', therapeutic.area, study_type)
    studies <- studyCurator::StudySPoTApi_search_studies(
        filter = filter)$content$data

    query_time <- round(Sys.time() - start_time, digits=1)
    logs_study_query = sprintf('StudySPoTApi_search_studies(
    filter = \'%s\'
)', filter)
        logs_study_query_time = sprintf('# %s studies: %s seconds', 
                                         nrow(studies), query_time)
        logs = paste(logs_study_query, logs_study_query_time, sep='\n')
        
    return(list('data'=studies, 'logs'=logs))
}

GetSamplesAndExpressions <- function(studies, sample_filter, cell_types, expression_filter, genes) {
    if (is_empty(studies) || nrow(studies) == 0) {
        return(NULL)
    }
    
    study_filter = paste(sprintf('genestack:accession=%s', studies[,'genestack:accession']), collapse=' OR ')
    
    ### get samples
    start_time <- Sys.time()
    
    samples = NULL
    tryCatch({
        samples <- as_tibble(OmicsQueriesApi_search_samples(
            study_filter=study_filter,
            sample_filter=sample_filter,
            page_limit = 20000
        )$content$data[['metadata']])
    }, error = function(e) {})
    
    query_time <- round(Sys.time() - start_time, digits=1)
    logs_sample_query = sprintf('OmicsQueriesApi_search_samples(
    study_filter = \'%s\',
    sample_filter = \'%s\'
)', study_filter, sample_filter)
        logs_sample_query_time = sprintf('# %s samples from %s studies: %s seconds', 
                                         nrow(samples), nrow(studies), query_time)
        logs = paste(logs_sample_query, logs_sample_query_time, sep='\n')

    if (is_empty(samples) || nrow(samples) == 0) {
        return(list('data'=NULL, 'logs'=logs))
    }
    
    
    ### add cell metadata (for single-cell studies)
    if ('Cell Metadata File' %in% colnames(studies)) {
        start_time <- Sys.time()
        
        r = lapply(studies[["Cell Metadata File"]], function(x) {
            read.table(
                url(x),
                sep = "\t",
                header = TRUE,
                stringsAsFactors = FALSE,
                check.names=FALSE
            )
        })
        
        cell_metadata = as_tibble(do.call(rbind, r))
        
        query_time <- round(Sys.time() - start_time, digits=1)
        logs_cell_query = 'lapply(studies[["Cell Metadata File"]], function(x) {
    read.table(
    url(x),
    sep = "\\t",
    header = TRUE,
    stringsAsFactors = FALSE,
    check.names=FALSE
)})'
        logs_cell_query_time = sprintf('# %s cells from %s studies: %s seconds', 
                                       nrow(cell_metadata), nrow(studies), query_time)
        logs = paste(logs, '\n', logs_cell_query, logs_cell_query_time, sep='\n')
        
        cell_metadata[['Barcode']] = paste(cell_metadata[['Lane']], cell_metadata[['Barcode']], sep = '/')
        samples = samples %>% select(-one_of('Cell Type'))
        samples = inner_join(samples, cell_metadata, by=c("Sample Source ID"="Lane"))
    }
    
    ### filter by cell subtypes
    if (!is_empty(cell_types) && !any(samples[['Cell Type']] %in% names(cell_types))) {
        return(list('data'=NULL, 'logs'=logs))
    }
    
    if (!is_empty(cell_types)) {
        samples = samples[samples[['Cell Type']] %in% names(cell_types), ]
        
        # merge cell types
        observed_cell_types = unique(samples[['Cell Type']])
        samples[['Cell Type']] = sapply(samples[['Cell Type']], function(x){
            parents = strsplit(cell_types[[x]],'//')[[1]]
            matches = intersect(parents, observed_cell_types)[1]
            
            if (length(matches) >= 1) {
                matches[1]
            } else {
                x
            }
        })
        
        # intersect cell types in case of >1 studies
        sample_sources = unique(samples[['Sample Source']])
        if (length(sample_sources) > 1) {
            cell_types_1 = unique(samples[samples[,'Sample Source'] == sample_sources[1], ][['Cell Type']])
            cell_types_2 = unique(samples[samples[,'Sample Source'] == sample_sources[2], ][['Cell Type']])
            samples = samples[samples[['Cell Type']] %in% intersect(cell_types_1, cell_types_2), ]
        }
    }
    
    if (is_empty(samples) || nrow(samples) == 0) {
        return(list('data'=NULL, 'logs'=logs))
    }
    if (is_empty(genes) || nrow(genes) == 0 || genes == '') {
        return(list('data'=samples, 'logs'=logs))
    }
    
    ### add expression data, if exists
    start_time <- Sys.time()
    
    expressions = NULL
    ex_query = sprintf('Gene=%s', paste(genes[,'symbol'],collapse=','))
    tryCatch({
        expressions <- as_tibble(do.call(cbind, OmicsQueriesApi_search_expression_data(
            study_filter=study_filter,
            sample_filter=sample_filter,
            ex_query=sprintf('Gene=%s', paste(genes[,'symbol'],collapse=',')),
            ex_filter=expression_filter,
            page_limit=20000
        )$content$data))
    }, error = function(e) {})
    
    query_time <- round(Sys.time() - start_time, digits=1)
    logs_expr_query = sprintf('OmicsQueriesApi_search_expression_data(
    study_filter = \'%s\',
    sample_filter = \'%s\',
    ex_query = \'%s\',
    ex_filter = \'%s\',
    page_limit = 20000
)', study_filter, sample_filter, ex_query, expression_filter)
        logs_expr_query_time = sprintf('# %s expression values for %s genes from %s samples from %s studies: %s seconds', 
                                         nrow(expressions), length(unique(genes[,'symbol'])), nrow(samples), nrow(studies), query_time)
        logs = paste(logs, '\n', logs_expr_query, logs_expr_query_time, sep='\n')
    
    if (is_empty(expressions) || nrow(expressions) == 0) {
        return(list('data'=samples, 'logs'=logs))
    }

    
    if ('Barcode' %in% colnames(samples)) {
        se = left_join(samples, expressions, by=c("Barcode"="metadata.Run Source ID"))
    } else {
        se = left_join(samples, expressions, by=c("genestack:accession"="sample"))
    }
    
    return(return(list('data'=se, 'logs'=logs)))
}
