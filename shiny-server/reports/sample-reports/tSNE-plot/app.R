library(shiny)
library(shinyStore)
library(plotly)
library(sampleCurator)
library(integrationCurator)

odm_host <- Sys.getenv("ODM_HOST")

ui <- fluidPage(
  titlePanel("tSNE-Plot"),
  initStore("store", "shiny-store"),
  plotlyOutput("plot"),
)

server <- function(input, output, session) {
  sample_id <- reactive({
    query <- getQueryString()
    query$sampleId
  })

  # Get lane and cell metadata for sample.
  cell <- reactive({
    sample_client <- sampleCurator::ApiClient$new(
      host    = odm_host,
      version = "default-released",
      token   = isolate(input$store$token)
    )

    integration_client <- integrationCurator::ApiClient$new(
      host    = odm_host,
      version = "default-released",
      token   = isolate(input$store$token)
    )

    study_integration_api <- StudyIntegrationApi$new(integration_client)
    study <- study_integration_api$get_study_by_sample(sample_id())$content
    url <- study[["Cell Metadata File"]]

    cell_metadata <- read.table(url(url), sep = "\t", header = TRUE,
                                stringsAsFactors = FALSE, check.names=FALSE)

    sample_api <- SampleSPoTApi$new(sample_client)
    sample <- sample_api$get_sample(sample_id())$content
    lane <- sample[["Sample Source ID"]]

    list(lane = lane, metadata = cell_metadata[cell_metadata$Lane == lane, ])
  })

  output$plot <- renderPlotly({
    title = sprintf("%s / %s", sample_id(), cell()$lane)
    plot_ly(data = cell()$metadata, text = ~`Cell Type`, x = ~x, y = ~y) %>% layout(title = title, width = 800)
  })
}

shinyApp(ui = ui, server = server)
