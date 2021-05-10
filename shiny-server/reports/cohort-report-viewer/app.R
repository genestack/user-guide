# client <- integrationUser::ApiClient$new(
#     host    = "inc-dev-5.s-int.gs.team",
#     version = "v0.1",
#     scheme  = "http",
#     token   = 'tknRoot'
# )
# 
# integrationUser::LinkageApi$new(client)$get_links_by_params(
#     first_id = 'GSF017059',
#     first_type = "study",
#     second_type = "sample",
#     offset = 0,
#     limit = 10
# )$content$data

library(httr)
library(rjson)
library(RCurl)
library(shiny)
library(shinyWidgets)
library(shinyBS)
library(ArvadosR)
library(plotly)
library(splitstackshape)
library(data.table)
library(plyr)
library(dplyr)
library(tidyr)
library(viridis)
library(sampleUser)
library(integrationUser)


# -------------------------------  Constants  ----------------------------------
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

# Plot size settings [px].
plot_width  <- 620
plot_height <- 380

# Spectral color palette for plots.
colours <- RColorBrewer::brewer.pal(n = 11, name = "Spectral")

none <- "<none>"
id_column <- "Sample Source ID" # TODO why introduce artificial ID

# Visualization types.
vtype_boxplot <- "Box Plot"
vtype_scatterplot <- "Scatter Plot"
vtype_barchart <- "Bar Chart"

visualization_types <- c(vtype_boxplot, vtype_scatterplot, vtype_barchart)

# Max number of unique values for faceting key (`facet by` UI component).
max_unique_values_for_faceting <- 10

# ----------------------------------  END  -------------------------------------

# ---------------------------------  UTILS  ------------------------------------
get_cohort_sample_ids <- function(odm_linkage_api, cohort_id) {
  sample_ids <- c()
  offset <- 0
  limit <- 1000

  repeat{
    # Get cohort - sample links via linkage API.
    response <- odm_linkage_api$get_links_by_params(
      first_id = cohort_id,
      first_type = "study",
      second_type = "sample",
      offset = offset,
      limit = limit
    )

    sample_ids <- c(sample_ids, response$content$data$secondId)
    offset <- offset + limit

    if (offset >= response$content$meta$pagination$total) {
      break
    }
  }

  sample_ids
}

get_samples_metadata <- function(odm_sample_api, sample_ids) {
  batch_size <- 100
  start_indices <- seq(from = 1, to = length(sample_ids), batch_size)

  data_frames <- lapply(start_indices, function(from) {
    to <- min(from + batch_size - 1, length(sample_ids))
    ids_filter <- paste(sprintf('"genestack:accession"="%s"', sample_ids[from:to]), collapse = " OR ")
    odm_sample_api$search_samples(filter = ids_filter, returned_metadata_fields = "all")$content$data
  })

  # Bind all data.frames together.
  metadata <- rbindlist(data_frames, fill = TRUE)

  # Unwrap multivalued columns.
  classes <- sapply(metadata, class)
  columns_to_unwrap <- names(metadata)[classes == "list"]

  # Add artificial id column for further duplicates elimination.
  metadata[, id_column] <- seq_len(nrow(metadata))

  for (column in columns_to_unwrap) {
    metadata <- splitstackshape::listCol_l(metadata, column)
  }

  # Method `listCol_l` modify original column names. Need to return original names back.
  setnames(metadata, sprintf("%s_ul", columns_to_unwrap), columns_to_unwrap)
  metadata <- as.data.frame(metadata)

  # Replace <NA> values with strings "<NA>". That allows to simplify filtering logic.
  metadata[is.na(metadata)] <- "<NA>"
  metadata[metadata == ""]  <- "<NA>"

  # Remove columns where all values are the same.
  selector <- apply(metadata, 2, function(column) length(unique(column)) > 1)
  metadata[, selector]
  metadata
}

# Transform metadata key into shiny selectize input id (filter).
to_fid <- function(key) { as.character(RCurl::base64Encode(key)) }

# Backward transformation.
from_fid <- function(key) { RCurl::base64Decode(key) }

# Apply filters to samples metadata data.frame. Filters is a list of the format key: [values].
# Values for one key are joined with OR, resulted key filters are joined with AND.
apply_filters <- function(filters, metadata) {
  if (is.null(filters) || length(filters) == 0) { return(metadata) }
  selector <- Reduce("&", lapply(names(filters), function(key) {
    Reduce("|", lapply(filters[[key]], function(value) metadata[, key] == value))
  }))
  metadata[selector, ]
}
# ----------------------------------  END  -------------------------------------

# ---------------------------  COMMON PLOT UTILS  ------------------------------
get_empty_plot_text <- function(xaxis, yaxis, title) {
  xaxis_text <- if (length(xaxis) > 1) sprintf("(%s)", paste(xaxis, collapse = ", ")) else xaxis
  text <- if (is.null(title))
    sprintf("<b>Not available</b> for <b>X</b>: %s; <b>Y</b>: %s", xaxis_text, yaxis)
  else
    sprintf("<b>Not available</b> for %s\n<b>X</b>: %s; <b>Y</b>: %s", title, xaxis_text, yaxis)
}

get_unique_count_column_name <- function(xaxis, yaxis) {
  tail(make.unique(c(xaxis, yaxis, "count")), 1)
}
# ----------------------------------  END  -------------------------------------

# --------------------------------  BOX PLOT  ----------------------------------
boxplot_setup <- function(data, xaxis_title, yaxis_title, title) {
  # categories <- unique(data[, xaxis_colors])
  # colors <- rev(viridis(length(categories)))
  plot_ly(data = data, 
          type = "box", 
          boxpoints = "all", pointpos = 0, jitter = 0.2,
          # marker = list(color = "black"),
          line = list(width = 1.4)) %>%
    layout(title = list(text = title, xanchor = "left", x = 0.025),
           xaxis = list(type = "category",
                        title = "",
                        automargin = TRUE),
           yaxis = list(title = yaxis_title,
                        zeroline = FALSE, 
                        automargin = TRUE, 
                        hoverformat = ".2f"))
}

# boxplot_legend <- function(sub_xaxis) {
#   list(
#       # orientation = "h",
#        # xanchor = "left", x = 0,
#        # yanchor = "top", y = -0.25,
#        title = list(text = sub_xaxis,
#                     # side = "top",
#                     font = list(size = 14)))
# }

# Creates a boxplot.
boxplot <- function(data, xaxis, yaxis, title = NULL) {
  if (nrow(data) == 0) {
    fig <- plotly_empty(type = "box") %>%
      layout(title = list(text = get_empty_plot_text(xaxis, yaxis, title), yref = "paper", y = 0.5),
             xaxis = list(visible = FALSE), yaxis = list(visible = FALSE))
    return(fig)
  }

  if (length(xaxis) <= 0 || length(xaxis) > 2) {
    stop(sprintf("Unsupported length of xaxis: %g. Only 1 (ordinary boxplots)
               and 2 (group boxplots) are supported", length(xaxis)))
  }
    
  fig <- boxplot_setup(data, xaxis[1], yaxis, title)
  
  if (length(xaxis) == 1) {
    fig <- fig %>%
      add_boxplot(y = ~get(yaxis), x = ~get(xaxis), hoverinfo='y') %>%
      layout(showlegend = FALSE)
  } else {

    fig <- fig %>%
      add_boxplot(x = ~get(xaxis[1]), y = ~get(yaxis), color = ~get(xaxis[2]), hoverinfo='y') %>%
      layout(boxmode = "group")
  }

  fig
}
# ----------------------------------  END  -------------------------------------

# ------------------------------  SCATTER PLOT  --------------------------------
scatterplot_setup <- function(data, xaxis_title, yaxis_title, title) {
  plot_ly(data = data, type = "scatter", mode = "markers"
          , hoverinfo = "x+y") %>%
    layout(title = list(text = title, xanchor = "left", x = 0.025),
           xaxis = list(type = "linear",
                        title = list(text = xaxis_title, standoff = 20),
                        automargin = TRUE,
                        zeroline = FALSE,
                        hoverformat = ".2f"),
           yaxis = list(title = yaxis_title,
                        zeroline = FALSE,
                        hoverformat = ".2f"))
}

# Creates a scatterplot.
scatterplot <- function(data, xaxis, yaxis, title = NULL) {
  if (nrow(data) == 0) {
    fig <- plotly_empty(type = "scatter", mode = "markers") %>%
      layout(title = list(text = get_empty_plot_text(xaxis, yaxis, title), yref = "paper", y = 0.5),
             xaxis = list(visible = FALSE), yaxis = list(visible = FALSE))
    return(fig)
  }

  fig <- scatterplot_setup(data, xaxis, yaxis, title) %>%
    add_trace(x = ~get(xaxis), y = ~get(yaxis), name = "") %>%
    layout(showlegend = FALSE)

  fig
}
# ----------------------------------  END  -------------------------------------

# ------------------------------ BARCHART PLOT  --------------------------------
# Creates a barchart.
barchart <- function(data, xaxis, yaxis, title = NULL) {
  if (nrow(data) == 0) {
    fig <- plotly_empty(type = "bar") %>%
      layout(title = list(text = get_empty_plot_text(xaxis, yaxis, title), yref = "paper", y = 0.5),
             xaxis = list(visible = FALSE), yaxis = list(visible = FALSE))
    return(fig)
  }

  count_column <- get_unique_count_column_name(xaxis, yaxis)
  count <- data %>% count(get(xaxis), get(yaxis), name = count_column)
  names(count) <- c(xaxis, yaxis, count_column)

  categories <- unique(data[, yaxis])
  colors <- viridis(length(categories))

  fig <- plot_ly(data = count, type = "bar", colors = colors,
                 x = ~get(xaxis), y = ~get(count_column),
                 color = ~get(yaxis), text = count[, yaxis],
                 hovertemplate = "%{text}: %{y}<extra></extra>") %>%
    layout(barmode = "stack",
           hoverlabel = list(bgcolor = "black", font = list(color = "white")),
           title = list(text = title, xanchor = "left", x = 0.025),
           xaxis = list(type = "category",
                        title = list(text = xaxis, standoff = 5),
                        automargin = TRUE),
           yaxis = list(title = "Count",
                        zeroline = FALSE))

  fig
}
# ----------------------------------  END  -------------------------------------

# ---------------------------  MAIN PLOT FUNCTION  -----------------------------
visualize <- function(type, data, xaxis, yaxis, title = NULL) {
  if (type == vtype_boxplot) {
    data[, yaxis] <- suppressWarnings(as.numeric(data[, yaxis]))
    data <- data[!is.na(data[, yaxis]), ]
    return(boxplot(unique(data), xaxis = xaxis, yaxis = yaxis, title = title)) # TODO why unique(data)?
  }

  if (type == vtype_scatterplot) {
    xaxis <- head(xaxis, 1)
    data[, xaxis] <- suppressWarnings(as.numeric(data[, xaxis]))
    data[, yaxis] <- suppressWarnings(as.numeric(data[, yaxis]))
    data <- data[!is.na(data[, xaxis]) && !is.na(data[, yaxis]), ]
    return(scatterplot(unique(data), xaxis = xaxis, yaxis = yaxis, title = title))
  }

  if (type == vtype_barchart) {
    return(barchart(unique(data), xaxis = xaxis, yaxis = yaxis, title = title))
  }

  stop(sprintf("Unknown visualization type: %s", type))
}
# ----------------------------------  END  -------------------------------------

# ---------------------------  Token Pop-Up Dialog  ----------------------------
odm_token_dialog <- modalDialog(
  textInput("odmToken", "ODM API Token", placeholder = "<token>"),
  footer = tagList(modalButton("Cancel"), actionButton("odmTokenDialogOk", "OK")),
  size = "s"
)
# ----------------------------------  END  -------------------------------------

# ----------------------------------  UI  --------------------------------------
ui <- fluidPage(title = "Cohort Report Viewer",
  tags$head(
    tags$script(type="text/javascript", src = "js.cookie.min.js"),
    tags$script(type="text/javascript", src = "tokens.cookie.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  titlePanel(
    tags$span("Cohort Report Viewer",
              actionButton("resetTokens", "Reset Tokens"))
  ),
  fluidRow(
    column(2,
           # pickerInput("filtersInput",
           #             label = h3("Filters"),
           #             multiple = TRUE,
           #             choices = NULL,
           #             options = list(title = "Filters",
           #                            `actions-box` = TRUE,
           #                            `live-search` = TRUE)),
           htmlOutput("filters"),
           style = "background: #f5f5f5"),
    column(8, htmlOutput("main")),
    column(2,
           # h3("Configuration"),
           prettyRadioButtons("visualizationType",
                              label = h4("Visualization type"),
                              choices = visualization_types,
                              selected = visualization_types[1]),
           hr(),
           selectizeInput("xaxis",
                          label = h4("X-axis"),
                          choices = NULL,
                          multiple = TRUE,
                          options = list(maxItems = 2)),
           selectizeInput("yaxis",
                          label = h4("Y-axis"),
                          choices = NULL,
                          multiple = TRUE,
                          options = list(maxItems = 1)),
           hr(),
           selectizeInput("facetBy",
                          label = h4("Facet by ",
                             tags$style(type = "text/css", "#q1 {vertical-align: top;}"),
                             # bsButton("qFacetBy", label = "", icon = icon("question"),
                             #          style = "info", size = "extra-small")
                          ),
                          choices = c(none),
                          selected = none,
                          multiple = FALSE),
           # bsPopover(id = "qFacetBy", title = "Faceting plots",
           #           content = paste("Only keys with a number of unique values ≤",
           #                           max_unique_values_for_faceting, "are available for a faceting"),
           #           placement = "bottom", trigger = "focus",
           #           options = list(container = "body")
           # ),
           style = "background: #f5f5f5")
  )
)
# ----------------------------------  END  -------------------------------------

server <- function(input, output, session) {
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

  observeEvent(input$resetTokens, {
    session$sendCustomMessage("cookie-remove", list(name = "odmToken"))
  })

  odm_token <- reactive({
    input$cookies$odmToken
  })

  odm_linkage_api <- reactive({
    client <- integrationUser::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    integrationUser::LinkageApi$new(client)
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

  cohort_id <- reactive({
    query <- getQueryString()
    # query$study
    "GSF017059"
  })

  samples_metadata <- reactive({
    # sample_ids <- get_cohort_sample_ids(odm_linkage_api(), cohort_id())
    # samples = get_samples_metadata(odm_sample_api(), sample_ids)
    # write.csv(samples, 'samples.csv', row.names=FALSE)
      
    samples = read.csv('Avengers Cohort_Sample Report Concept - Samples.csv', check.names=FALSE, stringsAsFactors=FALSE)
    samples[samples==""] = none
    samples
  })
  
  get_keys_classification <- reactive({
      keys = names(samples_metadata())
      keys_blacklist = c('genestack:accession', 'Sample Source ID', 'Arvados URL')
      keys_filters = c()
      keys_groups = c()
      keys_numeric = c()
      
      for (key in keys) {
          print(key)
          if (key %in% keys_blacklist) { next }
          
          if (is.numeric(samples[, key])) {
              keys_numeric = c(keys_numeric, key)
              next
          }
          
          if (length(unique(samples[, key])) > 1) {
              keys_groups = c(keys_groups, key)
          }
          
          keys_filters = c(keys_filters, key)
      }
      
      keys_classification = list(
          'filters' = keys_filters,
          'groups' = keys_groups,
          'numeric' = keys_numeric
      )
      
      return(keys_classification)
  })

  # axis_numeric_choices <- reactive({
  #   metadata <- samples_metadata()
  #   keys <- names(metadata)
  # 
  #   Filter(function(key) {
  #     !anyNA(suppressWarnings(as.numeric(metadata[metadata[, key] != "<NA>", key])))
  #   }, keys)
  # })
  # 
  # axis_categorical_choices <- reactive({
  #   metadata <- samples_metadata()
  #   keys <- names(metadata)
  # 
  #   Filter(function(key) {
  #     to_check <- unique(metadata[, c(id_column, key)])
  #     length(unique(to_check[, key])) < nrow(to_check)
  #   }, keys)
  # })

  # facet_by_choices <- reactive({
  #   metadata <- samples_metadata()
  #   keys <- names(metadata)
  # 
  #   Filter(function(key) {
  #     length(unique(metadata[, key])) <= max_unique_values_for_faceting
  #   }, keys)
  # })

  observe({
    req(cohort_id(), odm_token())

    metadata <- samples_metadata()
    keys <- names(metadata)
    # updatePickerInput(session, "filtersInput", choices = keys)
  })

  # Filters selectize input update, all metadata keys are available for filtering.
  observe({
    req(cohort_id(), odm_token())

    keys_classification = get_keys_classification()
    keys_groups = keys_classification[['groups']]
    keys_numeric = keys_classification[['numeric']]
    
    if (input$visualizationType == vtype_boxplot) {
      updateSelectizeInput(session, "xaxis", choices = keys_groups, selected = keys_groups[1],
                           options = list(maxItems = 2))
      updateSelectizeInput(session, "yaxis", choices = keys_numeric, selected = keys_numeric[1])
    } else if (input$visualizationType == vtype_scatterplot) {
      updateSelectizeInput(session, "xaxis", choices = keys_numeric, selected = keys_numeric[1],
                           options = list(maxItems = 1))
      updateSelectizeInput(session, "yaxis", choices = keys_numeric, selected = keys_numeric[1])
    } else if (input$visualizationType == vtype_barchart) {
      updateSelectizeInput(session, "xaxis", choices = keys_groups, selected = keys_groups[1],
                           options = list(maxItems = 1))
      updateSelectizeInput(session, "yaxis", choices = keys_groups, selected = keys_groups[1])
    }

    updateSelectizeInput(session, "facetBy", choices = c(none, keys_classification[['groups']]), selected = none)
  })

  output$filters <- renderUI({
    # req(input$filtersInput)
    # metadata <- samples_metadata()
    # keys <- input$filtersInput
      
      samples = samples_metadata()
      filters <- selected_filters()
      keys = get_keys_classification()[['filters']]
      print('here')
      print(keys)

      checkboxGroups = lapply(keys, function(key){
          if (length(filters[[key]]) > 0) {
              samples_filtered = apply_filters(within(filters, rm(list=key)), samples)
          } else {
              samples_filtered = apply_filters(filters, samples)
          }

          choices <- unique(samples_filtered[, key])
          counts = sapply(choices, function(choice) {
              length(unique(samples_filtered[samples_filtered[,key] == choice, sample_source_id_key]))
          })
          choiceNames = paste(choices, counts)

          print(key)
          print(filters[[key]])
          checkboxGroupInput(to_fid(key), key, choiceValues = choices, choiceNames = choiceNames, selected = filters[[key]])
      })

    # checkboxGroups = lapply(keys, function(key) {
    #     samples <- apply_filters(filters, samples)
    #     choices <- unique(samples[, key])
    #     checkboxGroupInput(to_fid(key), key, choices = choices, selected = filters[[key]])
    # })

    do.call(tagList, checkboxGroups)
    

    # filters <- lapply(keys, function(key) {
    #   choices <- unique(metadata[, key])
    #   pickerInput(inputId = to_fid(key),
    #               label = key,
    #               choices = choices,
    #               multiple = TRUE,
    #               options = list(size = 8, title = key, `actions-box` = TRUE,
    #                              `selected-text-format` = "count > 3"))
    # })
    # 
    # wellPanel(do.call(tagList, filters))
  })
  
  # observeEvent(input$filters, {
  #     print('bla')
  #     # updateCheckboxGroupInput(
  #     #     session = session,
  #     #     inputId = "studies.checkbox.input",
  #     #     selected = studies_options()[['data']][,'genestack:accession']
  #     # )
  # })

  selected_filters <- reactive({
    # keys <- input$filtersInput
    # if (is.null(keys)) { return(NULL) }
    
    # print(input[["Indicationcheckbox"]])
    #   
    samples = samples_metadata()
    keys = names(samples)
      
    values <- lapply(keys, function(key) input[[to_fid(key)]])
    names(values) <- keys
    values <- values[sapply(values, function(x) !is.null(x))]
    if (length(values) == 0) { return(NULL) }

    values
  })

  plots <- reactive({
    filters <- selected_filters()
    samples <- apply_filters(filters, samples_metadata())

    facet_by <- input$facetBy
    if (facet_by == none) {
      features <- c(none)
    } else {
      features <- unique(samples[, facet_by])
    }

    # Create box plots list.
    boxplots <- lapply(features, plotlyOutput)

    lapply(features, function(feature) {
      output[[feature]] <- renderPlotly({
        req(cohort_id(), odm_token(), input$xaxis, input$yaxis)

        title  <- if (feature == none) NULL    else feature
        subset <- if (feature == none) samples else samples[samples[, facet_by] == feature, ]
        subset <- subset[, c(id_column, unique(c(input$xaxis, input$yaxis))), drop = FALSE]

        visualize(type = isolate(input$visualizationType),
                  data = subset,
                  xaxis = input$xaxis,
                  yaxis = input$yaxis,
                  title = title)
      })
    })

    do.call(tagList, boxplots)
  })

  output$main <- renderUI({
    req(cohort_id(), odm_token(), input$facetBy, cancelOutput = TRUE)
    plots()
  })
}

shinyApp(ui = ui, server = server)
