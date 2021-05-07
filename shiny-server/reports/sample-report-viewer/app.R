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
odm_host <- Sys.getenv("ODM_URL")

# ODM API version.
version <- "v0.1"

# ODM scheme.
scheme <- "https"

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
# ----------------------------------  END  -------------------------------------

# ---------------------------  Token Pop-Up Dialogs  ---------------------------
odm_token_dialog <- modalDialog(
  textInput("odmToken", "ODM API Token", placeholder = "<token>"),
  footer = tagList(modalButton("Cancel"), actionButton("odmTokenDialogOk", "OK")),
  size = "s"
)

arvados_token_dialog <- function(api_host) {
  modalDialog(
    textInput("arvadosToken", paste("Arvados Token for", api_host), placeholder = "<token>"),
    footer = tagList(modalButton("Cancel"), actionButton("arvadosTokenDialogOk", "OK")),
    size = "s"
  )
}
# ----------------------------------  END  -------------------------------------

# ----------------------------------  UI  --------------------------------------
ui <- fluidPage(title = "Sample Report Viewer",
  tags$head(
    tags$script(type="text/javascript", src = "js.cookie.min.js"),
    tags$script(type="text/javascript", src = "tokens.cookie.js")
  ),

  titlePanel(
    tags$span("Sample Report Viewer",
              actionButton("resetTokens", "Reset Tokens"))
  ),
  h3("Metadata"),
  tableOutput("metadata"),
  h3("Cell Type Composition [CyTOF]"),
  uiOutput("cellComposition"),
  h3("Protein Expression per Cell over Dimension Reduction [CyTOF]"),
  uiOutput("proteinExpression")
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

      current[arvados_api_host()] <- input$arvadosToken
      msg <- list(name = "arvadosTokens", value = rjson::toJSON(current))
      session$sendCustomMessage("cookie-set", msg)
      removeModal()
    }
  })

  observeEvent(input$resetTokens, {
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
    metadata_list <- Filter(function(value) !is.null(value), response$content)

    # Join multivalued.
    values <- sapply(metadata_list, function(value) {
      if (length(value) > 1) paste(value, collapse = " | ")
      else as.character(value)
    })

    data.frame(key = names(values), value = values)
  })

  sample_ssid <- reactive({
    api <- odm_sample_api()
    response <- api$get_sample(sample_id(), returned_metadata_fields = "all")
    response$content[[sample_source_id_key]]
  })

  arvados_project_url <- reactive({
    api <- odm_integration_api()
    response <- api$get_study_by_sample(sample_id(), returned_metadata_fields = "all")
    response$content[[arvados_url_key]]
  })

  arvados_project_uuid <- reactive({
    get_arvados_project_uuid(arvados_project_url())
  })

  arvados_api_host <- reactive({
    get_arvados_api_host(odm_host, odm_token(), arvados_project_url())
  })

  output$metadata <- renderTable({
    req(odm_token())
    req(sample_id())
    sample_metadata()
  }, striped = TRUE, colnames = FALSE)

  output$cellComposition <- renderUI({
    req(odm_token())
    req(sample_id())
    req(sample_ssid())
    req(arvados_project_url())

    api_host <- arvados_api_host()
    token <- arvados_token()

    req(token)
    arv <- Arvados$new(authToken = token, hostName = api_host)
    subprojects <- arv$projects.list(list(list("owner_uuid", "=", arvados_project_uuid())))$items
    reports_project <- Find(function(sub) sub$name == reports_subproject_name, subprojects)

    req(reports_project)
    collections <- arv$collections.list(list(list("owner_uuid", "=", reports_project$uuid)))$items
    report_collection <- Find(function(collection) collection$name == cell_composition_report_name, collections)

    collection <- Collection$new(arv, report_collection$uuid)
    filename <- paste0(sample_ssid(), report_file_extension)
    file <- collection$get(filename)
    content <- file$read("text")

    data <- read.table(text = content, sep = ",", header = TRUE, stringsAsFactors = FALSE)

    output$cellCompositionPlot <- renderPlot({
      cell_composition_plot(data)
    })

    plotOutput("cellCompositionPlot", width = pie_chart_width, height = pie_chart_height)
  })

  output$proteinExpression <- renderUI({
    req(odm_token())
    req(sample_id())
    req(sample_ssid())
    req(arvados_project_url())

    api_host <- arvados_api_host()
    token <- arvados_token()

    req(token)
    arv <- Arvados$new(authToken = token, hostName = api_host)
    subprojects <- arv$projects.list(list(list("owner_uuid", "=", arvados_project_uuid())))$items
    reports_project <- Find(function(sub) sub$name == reports_subproject_name, subprojects)

    req(reports_project)
    collections <- arv$collections.list(list(list("owner_uuid", "=", reports_project$uuid)))$items
    report_collection <- Find(function(collection) collection$name == protein_expression_report_name, collections)

    collection <- Collection$new(arv, report_collection$uuid)
    filename <- paste0(sample_ssid(), report_file_extension)
    file <- collection$get(filename)
    content <- file$read("text")

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
