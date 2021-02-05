library(studyCurator)
library(integrationCurator)
library(expressionCurator)
library(variantCurator)

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
    logs_study_query <- paste('StudySPoTApi_search_studies(\n',
                              '    filter = \'', filter, '\'\n',
                              ')', sep = '')
    logs_study_query_time = sprintf('# %s studies: %s seconds', nrow(studies), query_time)
    logs = paste(logs_study_query, logs_study_query_time, sep='\n')

    return(list('data'=studies, 'logs'=logs))
}

GetExpressionGroups <- function(studies, sample_filter, ex_query, ex_filter) {
    if (is.null(studies) || nrow(studies) == 0) {
        return(NULL)
    }

    study_filter <- paste(sprintf('genestack:accession=%s', studies[,'genestack:accession']), collapse=' OR ')

    expression_groups_content <- OmicsQueriesApi_search_expression_groups(
        study_filter = study_filter,
        sample_filter = sample_filter,
        ex_query = ex_query
    )$content

    if (is.null(expression_groups_content)) {
        return(NULL)
    }

    if (ex_filter != '') {
        filter <- paste0('(',
                         paste(sprintf('genestack:accession=%s', expression_groups_content$data$itemId),
                               collapse=' OR '),
                         ')',
                         ' AND ',
                         ex_filter)
        expression_groups_content <- ExpressionSPoTApi_search_groups(filter = filter)$content
    }

    tryCatch({
        return(expression_groups_content$data)
    }, error = function(e) {
        return(NULL)
    })
}

GetVariantGroups <- function(studies, sample_filter, vx_query, vx_filter) {
    if (is.null(studies) || nrow(studies) == 0) {
        return(NULL)
    }

    study_filter <- paste(sprintf('genestack:accession=%s', studies[,'genestack:accession']), collapse=' OR ')
    variant_groups_content <- OmicsQueriesApi_search_variant_groups(
        study_filter = study_filter,
        sample_filter = sample_filter,
        vx_query = vx_query
    )$content

    if (is.null(variant_groups_content)) {
        return(NULL)
    }

    if (vx_filter != '') {
        filter <- paste0('(',
                         paste(sprintf('genestack:accession=%s', variant_groups_content$data$itemId),
                               collapse=' OR '),
                         ')',
                         ' AND ',
                         vx_filter)
        variant_groups_content <- VariantSPoTApi_search_groups(filter = filter)$content
    }

    tryCatch({
        return(variant_groups_content$data)
    }, error = function(e) {
        return(NULL)
    })
}

GetSamplesAndExpressions <- function(studies, sample_filter, group_factor, expression_filter, genes) {
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
    logs_sample_query <- paste('OmicsQueriesApi_search_samples(\n',
                              '    study_filter = \'', study_filter, '\'\n',
                              '    sample_filter = \'', sample_filter, '\'\n',
                              ')', sep = '')
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

    # Filter data by groups
    sample_sources = unique(samples[['Sample Source']])

    if (length(sample_sources) > 1) {
        group_select_1 = unique(samples[samples[,'Sample Source'] == sample_sources[1],][[as.character(group_factor)]])
        group_select_2 = unique(samples[samples[,'Sample Source'] == sample_sources[2],][[as.character(group_factor)]])
        group_select = intersect(group_select_1, group_select_2)

        if ((length(group_select) >= 1) && (is.na(group_select) == F)) {
            samples = samples[samples[[as.character(group_factor)]] %in% group_select, ]
        }else{
            return(list('data' = NULL, 'logs' = logs))
        }
    } else {
        group_select = unique(samples[[as.character(group_factor)]])
        if (length(group_select) >= 1 && is.na(group_select) == F) {
            samples = samples
        }else{
            return(list('data' = NULL, 'logs' = logs))
        }
    }

    if (is_empty(samples) || nrow(samples) == 0) {
        return(list('data'=NULL, 'logs'=logs))
    }
    if (is_empty(genes) || genes == '') {
        return(list('data'=samples, 'logs'=logs))
    }

    ### add expression data, if exists
    start_time <- Sys.time()

    expressions = NULL
    ex_query = sprintf('Gene=%s', paste(genes, collapse=','))
    tryCatch({
        expressions <- as_tibble(do.call(cbind, OmicsQueriesApi_search_expression_data(
            study_filter=study_filter,
            sample_filter=sample_filter,
            ex_query=sprintf('Gene=%s', paste(genes, collapse=',')),
            ex_filter=expression_filter,
            page_limit=20000
        )$content$data))
    }, error = function(e) {})

    query_time <- round(Sys.time() - start_time, digits=1)
    logs_expr_query <- paste('OmicsQueriesApi_search_expression_data(\n',
                             '    study_filter = \'', study_filter, '\'\n',
                             '    sample_filter = \'', sample_filter, '\'\n',
                             '    ex_query = \'', ex_query, '\'\n',
                             '    ex_filter = \'', expression_filter, '\'\n',
                             '    page_limit = 20000\n',
                             ')', sep = '')
        logs_expr_query_time = sprintf('# %s expression values for %s genes from %s samples from %s studies: %s seconds',
                                         nrow(expressions), length(unique(genes)), nrow(samples), nrow(studies), query_time)
        logs = paste(logs, '\n', logs_expr_query, logs_expr_query_time, sep='\n')

    if (is_empty(expressions) || nrow(expressions) == 0) {
        return(list('data'=samples, 'logs'=logs))
    }


    colnames(samples)[colnames(samples) == 'groupId'] <- 'Sample Group ID'
    colnames(expressions)[colnames(expressions) == 'groupId'] <- 'Expression Group ID'

    if ('Barcode' %in% colnames(samples)) {
        se = left_join(samples, expressions, by=c("Barcode"="metadata.Run Source ID"))
    } else {
        se = left_join(samples, expressions, by=c("genestack:accession"="sample"))
    }

    return(return(list('data'=se, 'logs'=logs)))
}

ComputeAlleleFrequencies <- function(studies, sample_filter, vx_query, vx_filter, group_factor) {
    if (is.null(studies) || nrow(studies) == 0) {
        return(list(data=NULL, logs=''))
    }

    study_filter <- paste(sprintf('genestack:accession=%s', studies[, 'genestack:accession']), collapse=' OR ')

    start_time <- Sys.time()
    samples_content <- OmicsQueriesApi_search_samples(
        study_filter = study_filter,
        sample_filter = sample_filter
    )$content
    query_time <- round(Sys.time() - start_time, digits = 1)

    logs <- paste('OmicsQueriesApi_search_samples(\n',
                  '    study_filter = \'', study_filter, '\'\n',
                  '    sample_filter = \'', sample_filter, '\'\n',
                  ')', sep = '')

    if (is.null(samples_content)) {
        logs <- paste(logs, sprintf('# 0 samples: %s seconds', query_time), sep = '\n')
        return(list(data=NULL, logs=logs))
    }

    samples <- samples_content$data[['metadata']]
    logs <- paste(logs, sprintf('# %s samples: %s seconds', nrow(samples), query_time), sep = '\n')

    start_time <- Sys.time()
    variants_content <- OmicsQueriesApi_search_variant_data(
        study_filter = study_filter,
        sample_filter = sample_filter,
        vx_query = vx_query,
        vx_filter = vx_filter,
        page_limit = 20000
    )$content
    query_time <- round(Sys.time() - start_time, digits = 1)

    logs <- paste(logs,
                  '\n\nOmicsQueriesApi_search_variant_data(\n',
                  '    study_filter = \'', study_filter, '\'\n',
                  '    sample_filter = \'', sample_filter, '\'\n',
                  '    vx_query = \'', vx_query, '\'\n',
                  '    vx_filter = \'', vx_filter, '\'\n',
                  '    page_limit = 20000\n',
                  ')', sep = '')

    if (is.null(variants_content) || length(variants_content$data) == 0) {
        logs <- paste(logs, sprintf('# 0 variants: %s seconds', query_time), sep = '\n')
        return(list(data=NULL, logs=logs))
    }

    variants <- variants_content$data
    logs <- paste(logs, sprintf('# %s variants: %s seconds', nrow(variants), query_time), sep = '\n')

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
        return(list(data=NULL, logs=logs))
    }

    if (group_factor %in% colnames(samples)) {
        af <- ComputeAlleleFrequenciesWithFactor(samples, variants, group_factor)
    } else {
        af <- ComputeAlleleFrequenciesWithoutFactor(samples, variants)
    }

    return(list(data=af, logs=logs))
}

ComputeAlleleFrequenciesWithoutFactor <- function(samples, variants) {
    af <- variants %>% group_by(Start) %>%
        summarise(AlleleTotalCount = sum(
            sapply(GT, function(x) if (x == '1|1') 2 else if (x == '1|0' || x == '0|1') 1 else 0))
        ) %>% filter(AlleleTotalCount > 0)

    af$Freq <- af$AlleleTotalCount / (2 * nrow(samples))
    return(af)
}

ComputeAlleleFrequenciesWithFactor <- function(samples, variants, group_factor) {
    s_table <- samples %>% select('genestack:accession')
    s_table$factor <- samples[, group_factor]
    res_variants = inner_join(variants, s_table, by=c("SampleID"="genestack:accession"))
    res_variants <- res_variants %>% group_by(Start, factor) %>%
        summarise(AlleleTotalCount = sum(
            sapply(GT, function(x) if (x=='1|1') 2 else if (x=='1|0' || x == '0|1') 1 else 0))
        ) %>% filter(AlleleTotalCount > 0)
    res_variants$Freq <- res_variants$AlleleTotalCount / (2 * nrow(samples))
    return(res_variants)
}
