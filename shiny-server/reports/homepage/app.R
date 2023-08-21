library(shiny)
library(shinyStore)

# -----------------------------  Constants  -----------------------------------
# default_odm_host <- "odm-demos.genestack.com"
default_odm_host <- "inc-dev-6.genestack.com"
# version <- "default-released"
version <- "v0.1"
available_reports <- c("cohort-report-viewer", "table-viewer", "expression-atlas")
# --------------------------------  END  --------------------------------------

# ODM host should be set in the R environment variable file (/home/shiny/.Renviron).
odm_host <- Sys.getenv("ODM_HOST")
odm_host <- Sys.getenv("ODM_HOST")
if (odm_host == "") {
  odm_host <- default_odm_host
}

# Define a modal dialog with a token text input and two buttons:
#   • `ok`     - store token within a browser local storage;
#   • `cancel` - close dialog without any actions.
dialog <- modalDialog(
  textInput("token", "ODM API Token", placeholder = "<token>"),
  footer = tagList(modalButton("Cancel"), actionButton("ok", "OK")),
  size = "s"
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

ui <- fluidPage(title = "Homepage",
  titlePanel(
    tags$span(
      tags$div(style = "display: inline-block", "Homepage"),
      tags$div(style = "display: inline-block", actionButton("reset", "Reset Tokens"))
  )),
  # Local storage must be initiated within the `ui` definition.
  initStore("store", "shiny-store"),
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

  output$reports <- renderUI({
    server_url <- paste0(session$clientData$url_protocol, "//",
                         session$clientData$url_hostname, ":",
                         session$clientData$url_port)

    links <- lapply(available_reports, function(report) {
      tags$li(tags$a(tools::toTitleCase(report),
                     href = paste(server_url, report, sep = "/")))
    })

    tags$html(tags$ol(links))
  })
}

shinyApp(ui = ui, server = server)
