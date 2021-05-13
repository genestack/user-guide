library(httr)
library(rjson)
library(shiny)
library(ArvadosR)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)
library(scattermore)
library(integrationUser)

# -------------------------------  Constants  ----------------------------------
# Report name (should match corresponding arvados report files collection)
cell_composition_report_name   <- "CyTOF_CellTypeComposition"
protein_expression_report_name <- "CyTOF_ProteinExpressionPerCellOverDimensionReduction"
report_file_extension <- ".csv"

# Target ODM url.
Sys.setenv(ODM_URL = "inc-dev-5.s-int.gs.team")
odm_host <- Sys.getenv("ODM_URL")

# ODM API version.
version <- "v0.1"

# ODM scheme.
scheme <- "http"

# Metadata keys.
arvados_url_key <- "Arvados URL"
sample_source_id_key <- "Sample Source ID"

# Pie chart size settings [px].
pie_chart_width  <- 620
pie_chart_height <- 380

# Individual scatter plot size settings [px].
scatter_plot_width  <- 320
scatter_plot_height <- 240

# Scatter plots grid settings.
n_columns <- 3

# Spectral color palette for scatter plots.
colours <- RColorBrewer::brewer.pal(n = 11, name = "Spectral")

cell_labels <- "cellLabels"
x_dimension <- "reducedDim1"
y_dimension <- "reducedDim2"

# Report files arvados subproject name
reports_subproject_name <- "Statistical Analysis"

predefined_columns <- c(cell_labels, x_dimension, y_dimension)
# ----------------------------------  END  -------------------------------------

# _------------------------  CELL COMPOSITION PLOT  ----------------------------
cell_composition_plot <- function(data, randomize_colours = FALSE) {
  counts <- data.frame(table(data$cellLabels))
  names(counts) <- c("Cell Label", "Frequency")
  counts <- counts[order(counts$Frequency, decreasing = TRUE), ]

  # Calculate percentage and add it to the labels.
  percentage <- scales::percent(counts$Frequency / sum(counts$Frequency), accuracy = 0.01)
  counts$`Cell Label with Percentage` <- paste0("[", percentage, "] ", counts$`Cell Label`)

  current_colours <- colorRampPalette(colours)(nrow(counts))
  if (randomize_colours) {
    set.seed(0)
    current_colours <- sample(current_colours)
  }

  # Labels to show over the pie chart.
  labels <- counts$`Cell Label`
  if (length(labels) > 5) {
    # Only first 5 labels are shown.
    labels[6:length(labels)] <- NA
  }

  ggplot(counts, aes(x = "", y = Frequency, fill = reorder(`Cell Label with Percentage`, Frequency))) +
    geom_bar(stat = "identity", width = 1, color = "seashell") +
    coord_polar("y", start = 0) +
    geom_text(aes(label = labels), na.rm = TRUE, position = position_stack(vjust = 0.5), size = 5) +
    guides(fill = guide_legend(reverse = TRUE)) +
    labs(x = NULL, y = NULL, fill = "Cell Label") +
    scale_fill_manual(values = current_colours) +
    theme(legend.title = element_text(size = 20),
          legend.text = element_text(size = 12),
          axis.ticks = element_blank(),
          axis.text = element_blank(),
          panel.background = element_blank())
}
# ----------------------------------  END  -------------------------------------

# ------------------------  PROTEIN EXPRESSION PLOT  ---------------------------
protein_expression_plot <- function(data, marker) {
  ggplot(data = data, aes_string(x = x_dimension, y = y_dimension)) +
    geom_scattermore(aes_string(color = marker), pointsize = 4, interpolate = TRUE) +
    scale_color_gradientn(colours = rev(colours), name = NULL) +
    ggtitle(marker) + xlab(NULL) + ylab(NULL) +
    theme(plot.title = element_text(size = 16, face = "bold"))
}
# ----------------------------------  END  -------------------------------------

# ---------------------------------  UTILS  ------------------------------------
get_arvados_api_host <- function(odm_host, odm_token, arvados_project_url) {
  arvados_workbench_hostname <- parse_url(arvados_project_url)$hostname
  if (is.null(parse_url(odm_host)$scheme))
    odm_host <- paste0(scheme, "://", odm_host)
  arvados_settings_endpoint_path <- "/frontend/rs/genestack/arvadosadmin/default-released/arvados/settings"
  arvados_setting_endpoint <- paste0(odm_host, arvados_settings_endpoint_path)
  response <- GET(arvados_setting_endpoint, add_headers(`Genestack-API-Token` = odm_token))
  settings <- rjson::fromJSON(content(response, "text"))
  arvados_instance <- Find(
    function(instance)
      parse_url(instance$workbenchHost)$hostname == arvados_workbench_hostname,
    settings
  )
  paste0(parse_url(arvados_instance$apiHost)[c("hostname", "port")], collapse = ":")
}

get_arvados_project_uuid <- function(arvados_project_url) {
  path <- parse_url(arvados_project_url)$path
  strsplit(path, split = "/")[[1]][2]
}

get_report_file <- function(arv, project_uuid, report_name, sample_ssid) {
  subprojects <- arv$projects.list(list(list("owner_uuid", "=", project_uuid)))$items
  reports_project <- Find(function(sub) sub$name == reports_subproject_name, subprojects)

  if (is.null(reports_project)) return(NULL)

  collections <- arv$collections.list(list(list("owner_uuid", "=", reports_project$uuid)))$items
  report_collection <- Find(function(collection) collection$name == report_name, collections)

  if (is.null(report_collection)) return(NULL)

  collection <- Collection$new(arv, report_collection$uuid)
  filename <- paste0(sample_ssid, report_file_extension)
  collection$get(filename)
}
# ----------------------------------  END  -------------------------------------

# ---------------------------  Token Pop-Up Dialogs  ---------------------------
odm_token_dialog <- modalDialog(
  textInput("odmToken", "ODM API Token", placeholder = "<token>"),
  footer = tagList(modalButton("Cancel"), actionButton("odmTokenDialogOk", "OK")),
  size = "s"
)

arvados_token_dialog <- function(api_host, failed = FALSE) {
  modalDialog(
    textInput("arvadosToken", paste("Arvados Token for", api_host), placeholder = "<token>"),
    if (failed)
      div("Invalid arvados token", style = "color: red; text-align:center;"),
    footer = tagList(modalButton("Cancel"), actionButton("arvadosTokenDialogOk", "OK")),
    size = "s"
  )
}
# ----------------------------------  END  -------------------------------------

app_logo <- '
<div class="app-title">
<svg
class="gs-icon"
width="20"
height="20"
viewBox="0 0 20 20"
fill="none"
xmlns="http://www.w3.org/2000/svg"
>
<path
fill-rule="evenodd"
clip-rule="evenodd"
d="M19.8014 10.0745C19.8014 9.23114 18.9802 8.46161 18.1452 8.46161H9.82893C8.99367 8.46161 8.37756 9.23114 8.37756 10.0745C8.37756 10.9179 8.99367 11.5385 9.82893 11.5385H16.4575C15.767 14.5939 13.0599 16.9457 9.82893 16.9457C7.98638 16.9457 6.31509 16.1992 5.08844 14.9932L2.9769 17.1802C4.74873 18.9236 7.16604 20.0002 9.82893 20.0002C15.2475 20.0002 19.8004 15.5448 19.8014 10.0721L19.8014 10.0745Z"
fill="#34AF7C"
/>
<path
fill-rule="evenodd"
clip-rule="evenodd"
d="M3.02472 9.92929V9.92721C3.02472 6.13786 6.07695 3.05474 9.82892 3.05474C11.6751 3.05474 13.3497 3.80383 14.5771 5.01396L16.6881 2.82669C14.9158 1.07968 12.4954 -6.10352e-05 9.82892 -6.10352e-05C4.4103 -6.10352e-05 0.00205728 4.45163 0.00051432 9.92435L0 9.92877C0 10.7721 0.677102 11.456 1.5121 11.456C2.34684 11.456 3.02395 10.7727 3.0242 9.92929H3.02472Z"
fill="#34AF7C"
/>
<path
fill-rule="evenodd"
clip-rule="evenodd"
d="M17.2174 3.98875C17.2174 4.83368 16.539 5.51862 15.7024 5.51862C14.8659 5.51862 14.1878 4.83368 14.1878 3.98875C14.1878 3.14381 14.8659 2.45862 15.7024 2.45862C16.539 2.45862 17.2174 3.14381 17.2174 3.98875Z"
fill="#024DA1"
/>
<path
fill-rule="evenodd"
clip-rule="evenodd"
d="M5.46595 16.0062C5.46595 16.8527 4.78653 17.5386 3.94844 17.5386C3.11087 17.5386 2.43146 16.8527 2.43146 16.0062C2.43146 15.1599 3.11087 14.4737 3.94844 14.4737C4.78653 14.4737 5.46595 15.1599 5.46595 16.0062Z"
fill="#024DA1"
/>
</svg>
<div>Sample Report Viewer</div>
</div>
'

sample_icon <- '
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13 4H7V15C7 17 8 18 10 18C12 18 13 17 13 15V4Z" fill="#D2DFEF"/>
<path d="M13 15V7C13 7 12 8.5 10 8C8 7.5 7 9 7 9V15C7 17 8 18 10 18C12 18 13 17 13 15Z" fill="#6290C8"/>
<circle cx="9" cy="10" r="1" fill="#D2DFEF"/>
<rect x="7" y="3" width="6" height="2" fill="#6290C8"/>
<rect x="10" y="12" width="1" height="1" fill="#D2DFEF"/>
</svg>
'

# ----------------------------------  UI  --------------------------------------
ui <- fluidPage(title = "Sample Report Viewer",
  tags$head(
    tags$script(type="text/javascript", src = "js.cookie.min.js"),
    tags$script(type="text/javascript", src = "tokens.cookie.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "sample-report-viewer-custom.css")
  ),

  withTags({
    div(class="root",
        h2(HTML(app_logo),
           div(class="report-title", htmlOutput("reportTitle")),
           actionButton("resetTokens", "Reset Tokens")),

        div(class="content",
        tabsetPanel(id = "reportTabs",
                    type = "tabs",
                    tabPanel(title = "Metadata", tableOutput("metadata"))))
    )
  })
)
# ----------------------------------  END  -------------------------------------

server <-  function(input, output, session) {
  observeEvent(input$cookies, {
    if (is.null(input$cookies$odmToken))
      showModal(odm_token_dialog)
  })

  observeEvent(input$odmTokenDialogOk, {
    if (input$odmToken != "") {
      msg <- list(name = "odmToken", value = input$odmToken)
      session$sendCustomMessage("cookie-set", msg)
      removeModal()
    }
  })

  observeEvent(input$arvadosTokenDialogOk, {
    if (input$arvadosToken != "") {
      json <- input$cookies$arvadosTokens

      if (is.null(json)) current <- list()
      else current <- rjson::fromJSON(json)

      # Check token.
      tryCatch({
        arv <- Arvados$new(authToken = input$arvadosToken, hostName = arvados_api_host())
        arv$api_client_authorizations.current() # Throws an error if token is wrong.
        current[arvados_api_host()] <- input$arvadosToken
        msg <- list(name = "arvadosTokens", value = rjson::toJSON(current))
        session$sendCustomMessage("cookie-set", msg)
        removeModal()
      },
        error = function(error) {
          removeModal()
          showModal(arvados_token_dialog(arvados_api_host(), failed = TRUE))
        }
      )
    }
  })

  observeEvent(input$resetTokens, {
    removeTab(inputId = "reportTabs",
              target = "Cell Type Composition [CyTOF]")
    removeTab(inputId = "reportTabs",
              target = "Protein Expression per Cell Over Dimension Reduction [CyTOF]")

    session$sendCustomMessage("cookie-remove", list(name = "odmToken"))
    session$sendCustomMessage("cookie-remove", list(name = "arvadosTokens"))
  })

  odm_token <- reactive({
    input$cookies$odmToken
  })

  arvados_token <- reactive({
    api_host <- arvados_api_host()
    token <- if (is.null(input$cookies$arvadosTokens)) NULL
             else rjson::fromJSON(input$cookies$arvadosTokens)[api_host]
    if (is.null(token))
      showModal(arvados_token_dialog(api_host))
    else
      token
  })

  odm_integration_api <- reactive({
    client <- integrationUser::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    integrationUser::StudyIntegrationApi$new(client)
  })

  odm_sample_api <- reactive({
    client <- sampleUser::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    sampleUser::SampleSPoTApi$new(client)
  })

  sample_id <- reactive({
    query <- getQueryString()
    query$sample
  })

  # Sample minimal metadata.
  sample_metadata <- reactive({
    api <- odm_sample_api()
    response <- api$get_sample(sample_id())
    if (response$response$status_code != 200) return(NULL)
    metadata_list <- Filter(function(value) !is.null(value), response$content)

    # Join multivalued.
    values <- sapply(metadata_list, function(value) {
      if (length(value) > 1) paste(value, collapse = " | ")
      else as.character(value)
    })

    data.frame(key = names(values), value = values)
  })

  sample_ssid <- reactive({
    req(sample_id(), odm_token())
    api <- odm_sample_api()
    response <- api$get_sample(sample_id(), returned_metadata_fields = "all")
    if (response$response$status_code != 200) return(NULL)
    response$content[[sample_source_id_key]]
  })

  arvados_project_url <- reactive({
    api <- odm_integration_api()
    response <- api$get_study_by_sample(sample_id(), returned_metadata_fields = "all")
    response$content[[arvados_url_key]]
  })

  arvados_project_uuid <- reactive({
    req(arvados_project_url())
    get_arvados_project_uuid(arvados_project_url())
  })

  arvados_api_host <- reactive({
    req(arvados_project_url())
    get_arvados_api_host(odm_host, odm_token(), arvados_project_url())
  })

  arvados <- reactive({
    req(arvados_api_host(), arvados_token())
    arv <- Arvados$new(authToken = arvados_token(), hostName = arvados_api_host())
  })

  # Report files.
  cell_composition_file <- reactive({
    req(sample_ssid(), arvados(), arvados_project_uuid())
    get_report_file(arvados(), arvados_project_uuid(),
                    cell_composition_report_name, sample_ssid())
  })

  protein_expression_file <- reactive({
    req(sample_ssid(), arvados(), arvados_project_uuid())
    get_report_file(arvados(), arvados_project_uuid(),
                    protein_expression_report_name, sample_ssid())
  })

  observe({
    if (!is.null(cell_composition_file())) {
      appendTab(inputId = "reportTabs",
                tab = tabPanel(title = "Cell Type Composition [CyTOF]",
                               uiOutput("cellComposition")))
    }

    if (!is.null(protein_expression_file())) {
      appendTab(inputId = "reportTabs",
                tab = tabPanel(title = "Protein Expression per Cell Over Dimension Reduction [CyTOF]",
                               uiOutput("proteinExpression")))
    }
  })

  output$reportTitle <- renderUI({
    req(sample_ssid())
    div(class="report-title", HTML(sample_icon), sample_ssid())
  })

  output$metadata <- renderTable({
    req(odm_token(), sample_id())
    sample_metadata()
  }, colnames = FALSE)

  output$cellComposition <- renderUI({
    req(cell_composition_file())

    content <- cell_composition_file()$read("text")
    data <- read.table(text = content, sep = ",", header = TRUE, stringsAsFactors = FALSE)

    output$cellCompositionPlot <- renderPlot({
      cell_composition_plot(data)
    })

    plotOutput("cellCompositionPlot", width = pie_chart_width, height = pie_chart_height)
  })

  output$proteinExpression <- renderUI({
    req(protein_expression_file())

    content <- protein_expression_file()$read("text")
    data <- read.table(text = content, sep = ",", header = TRUE, stringsAsFactors = FALSE)
    markers <- setdiff(names(data), predefined_columns)

    output$proteinExpressionPlots <- renderPlot({
      plots <- lapply(markers, function(marker) protein_expression_plot(data, marker))
      grid.arrange(grobs = plots, ncol = n_columns)
    })

    n_rows <- length(markers) %/% n_columns + (length(markers) %% n_columns > 0)
    plotOutput("proteinExpressionPlots", width = scatter_plot_width * n_columns, height = scatter_plot_height * n_rows)
  })
}

shinyApp(ui = ui, server = server)
