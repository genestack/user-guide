library(shiny)
library(shinyjs)
library(shinyStore)
library(integrationCurator) # TODO: consider switching to `integrationUser`
library(plotly)
library(dplyr)
library(tidyr)

# Constants.
none <- "<none>"
allele_category_selection <- "Allele [ALT]"
default_odm_host <- "occam.genestack.com"

# -----------------------------  UI Config  -----------------------------------
# Filters configuration (left column).
filters_configuration <- list(
  Disease = list(id = "disease",
                 label = h4("Disease"),
                 choices = c("melanoma", "lung non-small cell carcinoma")),
  Sex = list(id = "sex",
             label = h4("Sex"),
             choices = c("male", "female")),
  `main diagnoses` = list(id = "diagnoses",
                          label = h4("Main Diagnoses"),
                          choices = c("R074", "R31", "R69"))
)

# Value axis configuration (right column).
value_axis_configuration <- c("Age at cancer diagnosis")

# Category axis configuration (right column).
category_configuration <- c("Sex", "Disease", "Smoking status")

# Facet by configuration (right column).
facet_by_configuration <- c(none, "Sex", "Disease")
# --------------------------------  END  --------------------------------------

# ODM host should be set in the R environment variable file (/home/shiny/.Renviron).
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

# Some HTML text to show in case if Cohort ID (Genstack accession) is not specified.
no_cohort_id_text <- tags$html(
  tags$p(
    HTML(paste("Cohort ID ", tags$span("is not specified", style = "color:red"), ".", sep = "")),
    HTML(paste("Specify Cohort ID via the query parameters: ", tags$code("?cohortId=<id>"), ".", sep = ""))
  )
)

# `filters` is a list in a format `key` = c(`value 1`, `value 2`).
create_sample_filter <- function(filters) {
  filters <- filters[!sapply(filters, is.null)]
  filters_by_key <- lapply(
    names(filters),
    function(key) paste(sprintf('"%s"="%s"', key, filters[[key]]),
                        collapse = " OR ")
  )

  paste(sprintf("(%s)", filters_by_key), collapse = " AND ")
}

# Get all samples with filters.
get_samples <- function(token, cohort_id, filters) {
  # Set up ODM API Client.
  client  <- integrationCurator::ApiClient$new(
    host    = odm_host,
    version = "default-released",
    token   = token
  )

  api     <- OmicsQueriesApi$new(client)

  # Result samples data.frame.
  samples <- data.frame()
  cursor  <- NULL

  repeat{
    print(create_sample_filter(filters))

    response <- api$search_samples(
      study_filter  = sprintf('"genestack:accession"=%s', cohort_id),
      sample_filter = create_sample_filter(filters),
      page_limit    = 1000,
      cursor        = cursor
    )

    samples <- rbind(samples, response$content$data$metadata)
    cursor  <- response$content$cursor

    if(is.null(cursor)){
      break
    }
  }

  samples
}

count_alleles <- function(alleles) {
  sapply(alleles, function(allele) sum(as.numeric(strsplit(allele, "|", fixed = TRUE)[[1]]) > 0))
}

# Get alleles for samples.
get_alleles <- function(token, cohort_id, filters, variation_id) {
  # Set up ODM API Client.
  client  <- integrationCurator::ApiClient$new(
    host    = odm_host,
    version = "default-released",
    token   = token
  )

  api     <- OmicsQueriesApi$new(client)

  alleles <- data.frame()
  cursor  <- NULL

  repeat{
    response <- api$search_variant_data(
      study_filter  = sprintf('"genestack:accession"=%s', cohort_id),
      sample_filter = create_sample_filter(filters),
      vx_query      = sprintf("VariationId=%s", variation_id),
      page_limit    = 20000,
      cursor        = cursor
    )

    more <- data.frame(sampleId = response$content$data$relationships$sample,
                       alleles = as.character(count_alleles(response$content$data$genotype$GT)))
    alleles <- rbind(alleles, more)
    cursor  <- response$content$cursor

    if(is.null(cursor)){
      break
    }
  }

  if (nrow(alleles) > 0) {
    names(alleles) <- c("sampleId", allele_category_selection)
  }

  alleles
}

ui <- fluidPage(title = "Cohort Report Viewer",
  useShinyjs(),
  titlePanel(
    tags$span("Cohort Report Viewer",
              actionButton("reset", "Reset Tokens"))
  ),
  # Local storage must be initiated within the `ui` definition.
  initStore("store", "shiny-store"),
  fluidRow(
    column(2,
           selectizeInput("keys",
                          label = h4("Pie Charts on Metadata"),
                          multiple = TRUE,
                          choices = NULL,
                          options = list(maxItems = 4))),
    column(8,
           plotlyOutput("pie", height = "200px", width = "100%"))
  ),
  hr(),
  fluidRow(
    column(2,
           h3("Filters"),
           # Setup available filters.
           lapply(filters_configuration, function(config) {
             checkboxGroupInput(config$id, label = config$label, choices = config$choices)
           }),
           style = "background: #ebedef"),
    column(8, htmlOutput("main")),
    column(2,
           h3("Configuration"),
           radioButtons("value",
                        label = h4("Value Axis"),
                        choices = value_axis_configuration,
                        selected = value_axis_configuration[1]),
           checkboxGroupInput("category",
                              label = h4("Category Axis"),
                              choices = c(category_configuration, allele_category_selection)),
           shinyjs::disabled(
             textInput("variationId",
                       label = h5("Variation Id"))),
           radioButtons("facetBy",
                        label = h4("Facet by"),
                        choices = facet_by_configuration,
                        selected = none),
           style = "background: #ebedef")
  )
)

server <- function(input, output, session) {
  # Show token input dialog if token is not already stored in local storage.
  # TODO: consider to use `observe` and remove `showModal` from `input$reset` event.
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

  observeEvent(input$facetBy, {
    selected <- input$facetBy
    shinyjs::enable(selector = "#category")
    updateCheckboxGroupInput(session, "category", selected = character(0))

    if (selected != none) {
      shinyjs::disable(selector = sprintf("#category input[value='%s']", selected))
    }
  })

  observeEvent(input$category, {
    if (allele_category_selection %in% input$category) {
      shinyjs::enable(selector = "#variationId")
    } else {
      shinyjs::disable(selector = "#variationId")
    }

    # Only two options are availble at the same time.
    if (length(input$category) == 2){
      to_disable <- setdiff(c(category_configuration, allele_category_selection), input$category)
      for (choice in to_disable) {
        shinyjs::disable(selector = sprintf("#category input[value='%s']", choice))
      }
    } else {
      shinyjs::enable(selector = "#category")
    }
  })

  cohort_id <- reactive({
    query <- getQueryString()
    query$cohortId
  })

  all_samples <- reactive({
    if (is.null(cohort_id())) {
      # Return an empty data frame.
      return(data.frame())
    }

    get_samples(isolate(input$store$token), cohort_id(), filters = c())
  })

  # Metadata keys for pie cahrts.
  observe({
    samples <- all_samples()
    keys <- colnames(samples)
    keys <- keys[!(keys %in% c("genestack:accession", "Sample Source ID", "groupId"))]
    updateSelectizeInput(session, "keys", choices = keys)
  })

  # Pie charts panel.
  output$pie <- renderPlotly({
    selected <- input$keys
    if (length(selected) == 0) { return(NULL) }

    samples <- all_samples()

    # Determine a boxplots grid.
    n <- floor((length(selected) - 1) / 4) + 1

    pies <- plot_ly()
    for (i in seq_along(selected)) {
      key <- selected[i]
      counts <- samples %>% count(.data[[key]])
      domain <- list(row = (i - 1) %/% 4, column = (i - 1) %% 4)
      pies <- pies %>%
        add_pie(data = counts, labels = counts[[key]], values = ~n, name = key, domain = domain) %>%
        add_annotations(text = key, showarrow = FALSE, yref = "paper", xref = "paper",
                        x = 0.275 * domain$column, y = 1 - domain$row / n,
                        font = list(size = 14), bgcolor = rgb(1,1,1,0.5))
    }

    pies %>% layout(grid = list(rows = n, columns = 4), showlegend = FALSE, title = "Samples Metadata",
                    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })

  # Main panel that shows box plots.
  output$main <- renderUI({
    if (is.null(cohort_id())) {
      return(no_cohort_id_text)
    }

    filters <- lapply(filters_configuration, function(config) { input[[config$id]] })
    samples <- get_samples(isolate(input$store$token), cohort_id(), filters)

    # Add alleles count if needed.
    if (allele_category_selection %in% input$category && input$variationId != "") {
      alleles <- get_alleles(isolate(input$store$token), cohort_id(), filters, input$variationId)
      if (nrow(alleles) > 0) {
        samples <- merge(x = samples, y = alleles, by.x = "genestack:accession", by.y = "sampleId")
      }
    }

    # Create a plot list
    facet_by <- input$facetBy
    if (facet_by == none) {
      features <- c(none)
    } else {
      features <- unique(samples[, facet_by])
    }

    boxplots <- lapply(features, plotlyOutput)
    lapply(features, function(feature) {
      output[[feature]] <- renderPlotly({
        subset <- if (feature == none) samples else samples[samples[, facet_by] == feature, ]
        category <- input$category
        category <- category[category %in% names(subset)]
        subset <- subset[, c(input$value, category), drop = FALSE] %>% drop_na()

        plot_ly(x = if (length(category) == 0) NULL else subset[, category[1]],
                y = subset[, input$value],
                type = "box",
                color = if (length(category) == 2) subset[, category[2]] else category[1],
                boxpoints = "all",
                pointpos = 0,
                name = if (length(category) == 0) input$value else NULL) %>%
          layout(title = if (feature == none) input$value else feature,
                 boxmode = "group",
                 legend = list(title = list(text = tail(category, 1))))
      })
    })

    tagList(boxplots)
  })
}

shinyApp(ui = ui, server = server)
