library(shiny)
library(studyCurator)
library(RCurl)

#odm_host <- Sys.getenv("ODM_HOST")

odm_host <- "occam.genestack.com"
token <- "c7eb6c07150e851141e19b8bf07a2ceaee9cfef2"
study_acc <- "GSF1235133"
res_key <- "assoc_result_link"
res_cmd_key <- "assoc_command_line"

ui <- fluidPage(
  titlePanel("Example"),
  mainPanel(
    h6("Command line"),
    textOutput("cmdLine")
  ),
  p(),
  DT::dataTableOutput("table")
)

server <- function(input, output, session) {
  study_id <- reactive({
    query <- getQueryString()
    query$studyId
  })

  output$cmdLine <- renderText( {
    client <- studyCurator::ApiClient$new(host    = odm_host,
                                          version = "default-released",
                                          token   = token)
    api    <- StudySPoTApi$new(client)
    
    study   <- api$get_study(study_acc)$content
    command_line = as.character(study[res_cmd_key])
    command_line
  })
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
