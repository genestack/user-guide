library(shiny)
library(shinyStore)
library(tableHTML)
library(sampleCurator)

# ODM host should be set in the R environment variable file (/home/shiny/.Renviron).
odm_host <- Sys.getenv("ODM_HOST")

# Define a modal dialog with a token text input and two buttons:
#   • `ok`     - store token within a browser local storage;
#   • `cancel` - close dialog without any actions.
dialog <- modalDialog(
  textInput("token", "ODM API Token", placeholder = "<token>"),
  footer = tagList(modalButton("Cancel"), actionButton("ok", "OK")),
  size = "s"
)

# Some HTML text to show in case if Sample ID (Genstack accession) is not specified.
no_sample_id_text <- tags$html(
  tags$p(
    HTML(paste("Sample ID ", tags$span("is not specified", style = "color:red"), ".", sep = "")),
    HTML(paste("Specify Sample ID via the query parameters: ", tags$code("?sampleId=<id>"), ".", sep = ""))
  )
)

available_reports_text <- function(sampleId, reportNames) {
  tags$html(
    tags$p(
      HTML(paste("Entered Sample ID: ", tags$code(sampleId), ".", sep = "")),
      HTML(paste("Available reports, ", tags$em("(now this list is hardcoded)"), ":", sep="")),
      tags$ol(lapply(reportNames, FUN = tags$li))
    )
  )
}

# Hard-coded list of availbale reports. In the future this list can be somehow obtained from ODM.
get_available_report_names <- function(sampleId) {
  return(c("metadata", "tSNE-plot"))
}

ui <- fluidPage(title = "Available reports",
  titlePanel(
    tags$span(
      tags$div(style = "display: inline-block", htmlOutput("title")),
      tags$div(style = "display: inline-block", actionButton("reset", "Reset Tokens"))
  )),
  # Local storage must be initiated within the `ui` definition.
  initStore("store", "shiny-store"),
  htmlOutput("metadata"),
  htmlOutput("reports")
)

server <- function(input, output, session) {
  # Show token input dialog if token is not already stored in local storage.
  isolate({
    if (is.null(input$store$token)) {
      showModal(dialog)
    }
  })

  # Store token within a local storage when clicking `ok` button.
  observeEvent(input$ok, {
    updateStore(session, "token", isolate(input$token))
    removeModal()
  })

  observeEvent(input$reset, {
    updateStore(session, "token", NULL)
    showModal(dialog)
  })

  sample_id <- reactive({
    query <- getQueryString()
    query$sampleId
  })

  output$title <- renderUI({
    if (is.null(sample_id())) {
      return(HTML(paste("Sample", tags$span("<undefined>", style = "color:red"))))
    }

    return(paste("Sample", sample_id()))
  })

  output$metadata <- renderUI( {
    if (is.null(sample_id())) {
      return(no_sample_id_text)
    }

    client <- sampleCurator::ApiClient$new(host    = odm_host,
                                           version = "default-released",
                                           token   = isolate(input$store$token))
    api    <- SampleSPoTApi$new(client)
    sample   <- api$get_sample(sample_id())$content
    metadata <- data.frame(Value = unlist(sample[!sapply(sample, is.null)]))
    tableHTML(head(metadata, 5),
              border = 0,
              header = "",
              collapse = 'separate_shiny',
              spacing = '8px',
              caption = "Metadata") # %>% add_theme_colorize(color = '#1B30A0')
  })

  output$reports <- renderUI({
    server_url <- paste0(session$clientData$url_protocol, "//",
                         session$clientData$url_hostname, ":",
                         session$clientData$url_port)

    if (is.null(sample_id())) {
      return(tags$html(
        tags$p(h2("Available reports"),
               tags$span("Not available", style = "color:red"))
      ))
    }

    sample_query <- paste0("?sampleId=", sample_id())
    reports <- c("metadata", "tSNE-plot")
    links   <- lapply(reports, function(name) {
      tags$li(tags$a(tools::toTitleCase(name),
                     href = paste(server_url, "sample-reports", name, sample_query, sep = "/")))
    })

    tags$html(
      h2("Available reports"),
      tags$p(tags$ol(links))
    )
  })
}

shinyApp(ui = ui, server = server)
