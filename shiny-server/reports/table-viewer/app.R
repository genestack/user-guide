library(shiny)
library(studyCurator)
library(RCurl)

#odm_host <- Sys.getenv("ODM_HOST")

odm_host <- "occam.genestack.com"
token <- "c7eb6c07150e851141e19b8bf07a2ceaee9cfef2"
study_acc <- "GSF1235133"
name <- 'GWAS Analysis'
res_key <- paste(name, 'File', sep=' / ')
res_cmd_key <- paste(name, 'Command Line', sep=' / ')
res_desc_key <- paste(name, 'Description', sep=' / ')

ui <- fluidPage(
  titlePanel(name),
  mainPanel(
    br(),
    tableOutput('metainfo'),
    br(),
    DT::dataTableOutput("table")
  )
)

server <- function(input, output, session) {
  study_id <- reactive({
    query <- getQueryString()
    query$studyId
  })

  output$metainfo <- renderTable( {
    client <- studyCurator::ApiClient$new(host    = odm_host,
                                          version = "default-released",
                                          token   = token)
    api    <- StudySPoTApi$new(client)
    
    study   <- api$get_study(study_acc)$content
    metainfo_names <- names(study)
    names_cond <- lapply(metainfo_names, function(x) startsWith(x, name))
    gwas_subset = study[metainfo_names[unlist(names_cond)]]
    new_names = lapply(names(gwas_subset), function(x) substring(x, nchar(paste(name, " / ", sep=""))+1, ))
    names(gwas_subset) <- new_names
    ls = list(a=names(gwas_subset), b=unlist(gwas_subset))
    df <- as.data.frame(ls)
    df
  }, colnames=FALSE, rownames=FALSE, bordered=TRUE)
  output$table <- DT::renderDataTable({
    client <- studyCurator::ApiClient$new(host    = odm_host,
                                           version = "default-released",
                                           token   = token)
    api    <- StudySPoTApi$new(client)

    study   <- api$get_study(study_acc)$content
    url <- getURL(study[res_key])
    metadata <- read.table(text=url, header = TRUE)
    metadata
  }, options = list(order = c(9, 'asc')))
}

shinyApp(ui = ui, server = server)
