library(shiny)
library(ggbeeswarm)
library(plyr)
library(gridExtra)
suppressMessages(library(tidyverse))

host <- "occam.genestack.com"
token <- "6139dc4be955529e0910992cc0d8cbadd1dcd421"

source("r_client_api.R")
source("dictionaries_api.R")
source("ui_components.R")

Sys.setenv(
    PRED_SPOT_HOST = host,
    PRED_SPOT_TOKEN = token,
    PRED_SPOT_VERSION = "default-released"
)

# `genes` is a vector of selected genes (string).
# `genes_table` is expected to have the following columns:
#   1. `gene_symbol`;
#   2. `description`.
GenerateGeneSummary <- function(genes, genes_table) {
    print('generate gene summary')

    summary <- genes_table[genes_table$gene_symbol %in% genes, c("gene_symbol", "description")]
    summary <- summary[!duplicated(summary$gene_symbol), ]
    colnames(summary) <- c('Gene', 'Description')
    return(summary)
}

GenerateStudySummary <- function(studies) {
    print('generate study summary')
    if (!('Gating strategy' %in% colnames(studies))) {
        studies[, 'Gating strategy'] = ''
    }
    studies[is.na(studies)] <- ''

    studies = as_tibble(studies) %>%
        unnest(`Study Source ID`) %>%
        group_by(`genestack:accession`, `Study Title`, `Study Description`, `Gating strategy`) %>%
        summarise(
            `Study Source ID` = paste0(`Study Source ID`, collapse=' ')
        ) %>% unite(Study, `genestack:accession`, `Study Source ID`, sep=' ') %>%
        unite(Description, `Study Title`, `Study Description`, `Gating strategy`, sep='<br><br>')

    return(studies)
}

GenerateSampleSummary <- function(se) {
    x = as_tibble(se)[, c('genestack:accession', 'Organism', 'Sex', 'Disease', 'Tissue', 'Sample Source')] %>% distinct() %>% rename(Study=`Sample Source`)
    a = x %>% group_by(Study, Organism) %>% count() %>%
        unite(Organism, n, Organism, sep=' ') %>% group_by(Study) %>%
        summarise(Organism=paste(Organism, collapse='<br>'))
    b = x %>% group_by(Study, Sex) %>% count() %>%
        unite(Sex, n, Sex, sep=' ') %>% group_by(Study) %>%
        summarise(Sex=paste(Sex, collapse='<br>'))
    c = x %>% group_by(Study, Disease) %>% count() %>%
        unite(Disease, n, Disease, sep=' ') %>% group_by(Study) %>%
        summarise(Disease=paste(Disease, collapse='<br>'))
    d = x %>% group_by(Study, Tissue) %>% count() %>%
        unite(Tissue, n, Tissue, sep=' ') %>% group_by(Study) %>%
        summarise(Tissue=paste(Tissue, collapse='<br>'))

    # count cell type
    if ('Barcode' %in% colnames(se)) {
        y = as_tibble(se)[, c('Barcode', 'Cell Type', 'Sample Source')] %>% distinct() %>% rename(Study=`Sample Source`)
    } else {
        y = as_tibble(se)[, c('genestack:accession', 'Cell Type', 'Sample Source')] %>% distinct() %>% rename(Study=`Sample Source`)
    }
    e = y %>% group_by(Study, `Cell Type`) %>% count() %>%
        unite(`Cell Type`, n, `Cell Type`, sep=' ') %>% group_by(Study) %>%
        summarise(`Cell Type`=paste(`Cell Type`, collapse='<br>'))

    reduce(list(a,b,c,d,e), full_join, by = "Study")
}

GenerateExpressionSummary <- function(se) {
    se = subset(se, !is.na(expression))

    x = as_tibble(se)[, c(
        'Sample Source',
        'Expression Group ID',
        'metadata.Experimental Platform',
        'metadata.Data Processing Method',
        'metadata.Genome Version',
        'metadata.Scale',
        'metadata.Source')]

    colnames(x) = gsub('metadata.', '', colnames(x))
    x = x %>% rename(Study=`Sample Source`)
    x %>% group_by(Study, `Expression Group ID`, `Experimental Platform`, `Data Processing Method`, `Genome Version`, Scale) %>% distinct()
}

ui <- fluidPage(
    titlePanel(h2(" ", align = "left")),

    sidebarLayout(
        sidebarPanel(
            genes.input,
            group.input,
            hr(),
            study.type.input,
            therapeutic.area.input,
            uiOutput("studies.checkbox.input"),
            uiOutput("select.all"),
            hr(),
            sample.filter.input,
            expression.filter.input,
            width = 3
        ),

        mainPanel(
            tabsetPanel(type = "tabs", id = "tabs",
                        tabPanel("Beeswarm Plot", h1(''), uiOutput("beeswarm")),
                        # tabPanel("Allele Frequency Plot", h1(''), uiOutput("alleles")),
                        tabPanel("t-SNE Plot", h1(''), uiOutput("tsne")),
                        tabPanel("Gene Info", h1(''), uiOutput("genes")),
                        tabPanel("Study Info", h1(''), uiOutput("studies")),
                        tabPanel("Sample Info", h1(''), uiOutput("samples")),
                        tabPanel("Expression Info", h1(''), uiOutput("expression_metadata")),
                        tabPanel("API Calls", h1(''), verbatimTextOutput("api_calls"))),
            width = 9
        )
    )
)

server <- function(input, output, session) {
    genes_table <- read.csv('~/dev/genes_homo_sapiens.csv', header = TRUE, stringsAsFactors = FALSE)
    updateSelectizeInput(session, 'gene.input', choices = genes_table$gene_symbol, server = TRUE)

    therapeutic_areas <- read.csv('~/dev/therapeutic_area.csv', header = TRUE, stringsAsFactors = FALSE)
    updateSelectizeInput(session, 'therapeutic.area.input', choices = therapeutic_areas$Label, server = TRUE)

    observeEvent(input$study.type.input, {
        if (input$study.type.input == 'Single-cell Study') {
            showTab(inputId = "tabs", target = "t-SNE Plot")
        } else {
            hideTab(inputId = "tabs", target = "t-SNE Plot")
        }
    })

    genes <- reactive({
        print('get genes')

        x <- input$gene.input
        if (is_empty(x) || x == '') {
            return('')
        }

        return(GetGeneSynonyms(x, genes_table))
    })

    group_filter <- reactive({
        print('get group')
        input$group.input
    })

    studies_options <- reactive({
        print('get possible studies')
        GetStudies(input$therapeutic.area.input, input$study.type.input)
    })

    studies <- reactive({
        print("get selected studies")
        s = studies_options()[['data']]
        if (is_empty(s)) {
            return(NULL)
        }
        s[s[,'genestack:accession'] %in% input$studies.checkbox.input, ]
    })

    samples_expressions <- reactive({
        print("get samples and expressions")
        GetSamplesAndExpressions(
            studies(),
            input$sample.filter.input,
            group_filter(),
            input$expression.filter.input,
            genes()
        )
    })

    output$studies.checkbox.input <- renderUI({
        GetStudiesCheckboxInput(studies_options()[['data']])
    })

    output$select.all <- renderUI({
        GetStudiesSelectAllInput(studies_options()[['data']])
    })

    observeEvent(input$select.all, {
        updateCheckboxGroupInput(
            session = session,
            inputId = "studies.checkbox.input",
            selected = studies_options()[['data']][,'genestack:accession']
        )
    })

    output$beeswarm <- renderUI({
        se = samples_expressions()[['data']]
        if (is_empty(se) || nrow(se) == 0 || !('expression' %in% names(se))) {
            return("")
        }

        genes_n = length(as.character(unique(se[['gene']])))
        if (genes_n > 1) {
            plotOutput("beeswarm_show", height=ceiling((genes_n+1)/2)*200)
        } else {
            plotOutput("beeswarm_show")
        }
    })

    output$beeswarm_show <- renderPlot({
        se = samples_expressions()[['data']]
        se = subset(se, !is.na(expression))

        group_val = gsub(" ", "", as.character(group_filter()), fixed = T)
        colnames(se) = sub(group_filter(), group_val, colnames(se))
        colnames(se) = sub("Sample Source", "Sample_Source", colnames(se))
        ggplot(
            se, aes_string(x = group_val, y = "expression", color = "Sample_Source")
        ) + facet_wrap(~ gene + metadata.Source, ncol = 2) +
            geom_beeswarm(cex = 2, size = 2, alpha = 0.5) +
            theme(axis.text.x = element_text(size = 10, angle = 8, hjust = 0.5, vjust = 0.5)) +
            theme(legend.title = element_blank()) + labs(y = "Expression", x = "") +
            scale_y_log10() + expand_limits(y = 0)
    })

    output$alleles <- renderUI({
        if (!StudiesHasVariantData(studies())) {
            return('')
        }

        plotOutput('alleles_show')
    })

    output$alleles_show <- renderPlot({
        g <- genes()
        if (is_empty(g) || nrow(g) == 0 || genes() == '') {
            vx_query <- 'info_AF=(0.001:1)'
        } else {
            vx_query <- sprintf('Gene=%s info_AF=(0.001:1)', paste(genes()[,'symbol'], collapse=','))
        }

        af <- ComputeAlleleFrequencies(studies(), vx_query, group_filter())
        if (is.null(af)) {
            return('')
        }

        if ('factor' %in% colnames(af)) {
            ggplot(
                af[1:10, ],
                mapping = aes(x = Start, y = Freq, fill = factor)
            ) + geom_bar(stat='identity', position = position_dodge())
        } else {
            ggplot(
                af[1:10, ],
                mapping = aes(x = Start, y = Freq)
            ) + geom_bar(stat = 'identity')
        }
    })

    output$tsne <- renderUI({
        se = samples_expressions()[['data']]
        if (is_empty(se) || nrow(se) == 0 ) {
            return('')
        }

        studies_n = length(unique(se[['Sample Source']]))
        if ('gene' %in% colnames(se)) {
            x = se[,c('Sample Source', 'gene')] %>% distinct()
            genes_n = sum(!is.na(as.character(unique(x[['gene']]))))
            plotOutput("tsne_show", height = 400*(studies_n+genes_n))
        } else {
            plotOutput("tsne_show", height = 400*studies_n)
        }
    })
    output$tsne_show <- renderPlot({
        se = samples_expressions()[['data']]
        sample_sources = unique(se[['Sample Source']])
        group_val = as.character(group_filter())

        plots = lapply(sample_sources, function(ss) {
            se = se[se[['Sample Source']] == ss, ]

            c = se[,c('Barcode', 'x', 'y', group_val)] %>% distinct()
            colnames(c) = gsub(" ","", colnames(c), fixed = T)
            group_factor = gsub(" ","", group_val, fixed = T)

            plots = list(ggplot(c, aes_string(x = "x", y = "y", color = group_factor)) +
                            geom_point(cex = 1, alpha = 0.5) +
                            theme(axis.text.x = element_text(size = 10, angle = 8, hjust = 0.5, vjust = 0.5)) +
                            theme(legend.title = element_blank()) + labs(y = "", x = "") +
                            ggtitle(ss) + theme(plot.title = element_text(hjust = 0.5, size = 10))
                         )

            if ('gene' %in% colnames(se)) {
                genes = as.character(unique(se[['gene']]))
                genes = genes[!is.na(genes)]

                additional_plots = lapply(genes, function(gene){
                    g = se[se[['gene']] == gene | is.na(se[['gene']]), ]
                    g[is.na(g[['expression']]), 'expression'] = 0

                    gp = ggplot(g, mapping=aes(x=x, y=y, color=expression)) +
                        geom_point(cex=1, alpha=0.5) +
                        theme(axis.text.x = element_text(size = 10, angle = 8, hjust = 0.5, vjust = 0.5)) +
                        theme(legend.title = element_blank()) + labs(y = "", x = "") +
                        scale_colour_gradient(low="grey80", high="red") +
                        ggtitle(gene) + theme(plot.title = element_text(hjust = 0.5, size=10))
                    return(gp)
                })

                plots = c(plots, additional_plots)
            }

            plots
        })

        if (length(sample_sources)>1) {
            plots = c(plots[[1]], plots[[2]])
        } else {
            plots = plots[[1]]
        }

        grid.arrange(grobs = plots, ncol=1)
    })

    output$genes <- renderUI({
        g = genes()
        if (is_empty(g) || length(g) == 0 || g == '') {
            return('')
        }
        tableOutput('genes_show')
    })

    output$genes_show <- renderTable({
        GenerateGeneSummary(genes(), genes_table)
    }, sanitize.text.function=identity)

    output$studies <- renderUI({
        s = studies()
        if (is_empty(s) || nrow(s) == 0) {
            return("")
        }
        tableOutput("studies_show")
    })

    output$studies_show <- renderTable({
            GenerateStudySummary(studies())
        }, sanitize.text.function=identity)

    output$samples <- renderUI({
        se = samples_expressions()[['data']]
        if (is_empty(se) || nrow(se) == 0) {
            return("")
        }
        tableOutput("samples_show")
    })

    output$samples_show <- renderTable({
        GenerateSampleSummary(samples_expressions()[['data']])
    }, sanitize.text.function=identity)

    output$expression_metadata <- renderUI({
        se = samples_expressions()[['data']]
        if (is_empty(se) || nrow(se) == 0 || !('expression' %in% names(se))) {
            return("")
        }
        tableOutput("expression_metadata_show")
    })

    output$expression_metadata_show <- renderTable({
        GenerateExpressionSummary(samples_expressions()[['data']])
    }, sanitize.text.function=identity)

    output$api_calls <- renderText({paste(studies_options()[['logs']],samples_expressions()[['logs']],sep='\n\n\n')})
}

shinyApp(ui = ui, server = server)
