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
report_name <- "CyTOF_ProteinExpressionPerCellOverDimensionReduction"
report_file_extension <- ".csv"

# Target ODM url.
# odm_host <- Sys.getenv("ODM_URL")
odm_host <- "inc-rc-s.genestack.com"

# ODM API version.
version <- "v0.1"

# ODM scheme.
scheme <- "http"

# Metadata keys.
arvados_url_key <- "Arvados URL"
sample_source_id_key <- "Sample Source ID"

# Individual plot size settings [px].
plot_width  <- 320
plot_height <- 240

# Grid settings.
n_columns <- 3

# Spectral color palette for scatter plots.
colours <- rev(RColorBrewer::brewer.pal(n = 11, name = "Spectral"))

cell_labels <- "cellLabels"
x_dimension <- "reducedDim1"
y_dimension <- "reducedDim2"

# Report files arvados subproject name
reports_subproject_name <- "Statistical Analysis"

predefined_columns <- c(cell_labels, x_dimension, y_dimension)
# ----------------------------------  END  -------------------------------------

# ---------------------------  MAIN PLOT FUNCTION  -----------------------------
plot <- function(data, marker) {
  ggplot(data = data, aes_string(x = x_dimension, y = y_dimension)) +
    geom_scattermore(aes_string(color = marker), pointsize = 4, interpolate = TRUE) +
    scale_color_gradientn(colours = colours, name = NULL) +
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
ui <- fluidPage(title = "Protein Expression per Cell over Dimension Reduction [CyTOF]",
  tags$head(
    tags$script(type="text/javascript", src = "js.cookie.min.js"),
    tags$script(type="text/javascript", src = "tokens.cookie.js")
  ),

  titlePanel(
    tags$span("Protein Expression per Cell over Dimension Reduction [CyTOF]",
              actionButton("resetTokens", "Reset Tokens"))
  ),
  uiOutput("main"),
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
    if (is.null(input$cookies$arvadosTokens)) NULL
    else rjson::fromJSON(input$cookies$arvadosTokens)[arvados_api_host()]
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

  output$main <- renderUI({
    req(odm_token())
    req(sample_id())
    req(sample_ssid())
    req(arvados_project_url())

    api_host <- arvados_api_host()
    token <- arvados_token()

    if (is.null(token))
      showModal(arvados_token_dialog(api_host))

    req(token)
    arv <- Arvados$new(authToken = token, hostName = api_host)
    subprojects <- arv$projects.list(list(list("owner_uuid", "=", arvados_project_uuid())))$items
    reports_project <- Find(function(sub) sub$name == reports_subproject_name, subprojects)

    req(reports_project)
    collections <- arv$collections.list(list(list("owner_uuid", "=", reports_project$uuid)))$items
    report_collection <- Find(function(collection) collection$name == report_name, collections)

    collection <- Collection$new(arv, report_collection$uuid)
    filename <- paste0(sample_ssid(), report_file_extension)
    file <- collection$get(filename)
    content <- file$read("text")

    data <- read.table(text = content, sep = ",", header = TRUE, stringsAsFactors = FALSE)
    markers <- setdiff(names(data), predefined_columns)

    output$plots <- renderPlot({
      plots <- lapply(markers, function(marker) plot(data, marker))
      grid.arrange(grobs = plots, ncol = n_columns)
    })

    n_rows <- length(markers) %/% n_columns + (length(markers) %% n_columns > 0)
    plotOutput("plots", width = plot_width * n_columns, height = plot_height * n_rows)
  })
}

shinyApp(ui = ui, server = server)
