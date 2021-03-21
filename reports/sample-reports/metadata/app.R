library(shiny)
library(shinyStore)
library(sampleCurator)

odm_host <- Sys.getenv("ODM_HOST")

ui <- fluidPage(
  titlePanel("Metadata"),
  initStore("store", "shiny-store"),
  tableOutput("metadata"),
)

server <- function(input, output, session) {
  sample_id <- reactive({
    query <- getQueryString()
    query$sampleId
  })

  output$metadata <- renderTable({
    client <- sampleCurator::ApiClient$new(host    = odm_host,
                                           version = "default-released",
                                           token   = isolate(input$store$token))
    api    <- SampleSPoTApi$new(client)

    sample   <- api$get_sample(sample_id())$content
    metadata <- data.frame(Value = sapply(sample, function(value) if (is.null(value)) "" else value))
    metadata
  }, rownames = TRUE, colnames = FALSE)
}

shinyApp(ui = ui, server = server)
