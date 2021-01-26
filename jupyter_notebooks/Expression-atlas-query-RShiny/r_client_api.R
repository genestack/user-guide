library(studyCurator)
library(integrationCurator)

GetStudies <- function(therapeutic.area, study_type) {
    start_time <- Sys.time()
    
    if (therapeutic.area != '') {
        filter <- sprintf('"Therapeutic Area"="%s" AND "Study Type"="%s"', therapeutic.area, study_type)  
    } else {
        filter <- sprintf('"Study Type"="%s"', study_type)
    }
    
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

StudiesHasVariantData <- function(studies) {
    if (is.null(studies) || nrow(studies) == 0) {
        return(FALSE)
    }
    
    # Create filters
    study_filter <- paste(sprintf('genestack:accession=%s', studies[,'genestack:accession']), collapse=' OR ')
    
    variant_groups_content <- OmicsQueriesApi_search_variant_groups(
        study_filter = study_filter
    )$content
    
    return(!is.null(variant_groups_content) && nrow(variant_groups_content$data) > 0)
}

# UK Biobank demo
# GetSamplesAndExpressions <- function(studies, sample_filter, cell_types, expression_filter, genes) {
GetSamplesAndExpressions <- function(studies, sample_filter, group_filter, expression_filter, genes) {
    if (is_empty(studies) || nrow(studies) == 0) {
        return(NULL)
    }
    
    study_filter = paste(sprintf('genestack:accession=%s', studies[, 'genestack:accession']), collapse=' OR ')
    
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
    
    # UK Biobank demo
    ### filter by cell subtypes
    # if (!is_empty(cell_types) && !any(samples[['Cell Type']] %in% names(cell_types))) {
    #     return(list('data'=NULL, 'logs'=logs))
    # }
    # 
    # if (!is_empty(cell_types)) {
    #     samples = samples[samples[['Cell Type']] %in% names(cell_types), ]
    #     
    #     # merge cell types
    #     observed_cell_types = unique(samples[['Cell Type']])
    #     samples[['Cell Type']] = sapply(samples[['Cell Type']], function(x){
    #         parents = strsplit(cell_types[[x]],'//')[[1]]
    #         matches = intersect(parents, observed_cell_types)[1]
    #         
    #         if (length(matches) >= 1) {
    #             matches[1]
    #         } else {
    #             x
    #         }
    #     })
    #     
    #     # intersect cell types in case of >1 studies
    #     sample_sources = unique(samples[['Sample Source']])
    #     if (length(sample_sources) > 1) {
    #         cell_types_1 = unique(samples[samples[,'Sample Source'] == sample_sources[1], ][['Cell Type']])
    #         cell_types_2 = unique(samples[samples[,'Sample Source'] == sample_sources[2], ][['Cell Type']])
    #         samples = samples[samples[['Cell Type']] %in% intersect(cell_types_1, cell_types_2), ]
    #     }
    # }
    # 
    # if (is_empty(samples) || nrow(samples) == 0) {
    #     return(list('data'=NULL, 'logs'=logs))
    # }
    # if (is_empty(genes) || nrow(genes) == 0 || genes == '') {
    #     return(list('data'=samples, 'logs'=logs))
    # }
    
    # Filter data by groups
    sample_sources = unique(samples[['Sample Source']])
    
    if (length(sample_sources) > 1) {
        group_select_1 = unique(samples[samples[,'Sample Source'] == sample_sources[1],][[as.character(group_filter)]])
        group_select_2 = unique(samples[samples[,'Sample Source'] == sample_sources[2],][[as.character(group_filter)]])
        group_select = intersect(group_select_1, group_select_2)
        
        if ((length(group_select) >= 1) && (is.na(group_select) == F)) {
            samples = samples[samples[[as.character(group_filter)]] %in% group_select, ]
        }else{
            return(list('data' = NULL, 'logs' = logs))
        }
    } else {
        group_select = unique(samples[[as.character(group_filter)]])
        if (length(group_select) >= 1 && is.na(group_select) == F) {
            samples = samples
        }else{
            return(list('data' = NULL, 'logs' = logs))
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
    ex_query = sprintf('Gene=%s', paste(genes[, 'symbol'],collapse=','))
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

ComputeAlleleFrequencies <- function(studies, vx_query, group_filter) {
    if (is.null(studies) || nrow(studies) == 0) {
        return(NULL)
    }
    
    study_filter <- paste(sprintf('genestack:accession=%s', studies[, 'genestack:accession']), collapse=' OR ')
    
    samples_content <- OmicsQueriesApi_search_samples(
        study_filter = study_filter,
        sample_filter = ''
    )$content
    
    if (is.null(samples_content)) {
        return(NULL)
    }
    
    samples <- samples_content$data[['metadata']]
    
    variants_content <- OmicsQueriesApi_search_variant_data(
        study_filter = study_filter,
        sample_filter = '',
        vx_query = vx_query,
        page_limit = 20000
    )$content
    
    if (is.null(variants_content) || length(variants_content$data) == 0) {
        return(NULL)
    }
    
    variants <- variants_content$data
    variants <- cbind(
        'SampleID' = variants$relationships$sample,
        VariantID = variants$variationId,
        Chr = variants$contig,
        Start = variants$start,
        Ref = variants$reference,
        Alt = variants$alteration,
        do.call(cbind, variants$genotype),
        do.call(cbind, variants$info)
    ) %>% as_tibble %>% mutate_all(function(x) map_chr(x, ~paste(., collapse=', ')))
    
    variants <- filter(variants, VT == 'SNP')
    
    if (nrow(variants) == 0) {
        return(NULL)
    }
    
    if (group_filter %in% colnames(samples)) {
        af <- ComputeAlleleFrequenciesWithFactor(samples, variants, SelectFactorByGroup(group_filter))
    } else {
        af <- ComputeAlleleFrequenciesWithoutFactor(samples, variants)
    }
    
    return(af)
}

SelectFactorByGroup <- function(group_filter) {
    if (group_filter == 'Sex') {
        return(function(x) { x['Sex'] })
    } else if (group_filter == 'BMI') {
        return(function(x) {
            if (is.na(x['BMI'])) NA
            else if (x['BMI'] < 18.5) 'Underweight'
            else if (x['BMI'] < 25.0) 'Normal'
            else 'Overweight'
        })
    } else if (group_filter == 'Smoking status') {
        return(function(x) { x['Smoking status'] })
    } else if (group_filter == 'Disease') {
        return(function(x) { x['Disease'] })
    } else if (group_filter == 'Cell Type') {
        return(function(x) { x['Cell Type'] })
    }
}

ComputeAlleleFrequenciesWithoutFactor <- function(samples, variants) {
    af <- variants %>% group_by(Start) %>%
        summarise(AlleleTotalCount = sum(
            sapply(GT, function(x) if (x == '1|1') 2 else if (x == '1|0' || x == '0|1') 1 else 0))
        ) %>% filter(AlleleTotalCount > 0)
    
    af$Freq <- af$AlleleTotalCount / (2 * nrow(samples))
    return(af)
}

ComputeAlleleFrequenciesWithFactor <- function(samples, variants, cond) {
    s_table <- samples %>% select('genestack:accession')
    s_table$factor <- apply(samples, 1, cond)
    res_variants = inner_join(variants, s_table, by=c("SampleID"="genestack:accession"))
    res_variants <- res_variants %>% group_by(Start, factor) %>%
        summarise(AlleleTotalCount = sum(
            sapply(GT, function(x) if (x=='1|1') 2 else if (x=='1|0' || x == '0|1') 1 else 0))
        ) %>% filter(AlleleTotalCount > 0)
    res_variants$Freq <- res_variants$AlleleTotalCount / (2 * nrow(samples))
    return(res_variants)
}
