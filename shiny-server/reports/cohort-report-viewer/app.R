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
id_column <- "genestack:accession" # Must be unique accross all the samples.

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

unwrap_compound_keys <- function(metadata) {
  compounds <- names(metadata)[grep("/", names(metadata), fixed = TRUE)]
  groups <- strsplit(compounds, "/")

  compound_keys <- list()
  for (group in groups) {
    compound_keys[[group[1]]] <- c(compound_keys[[group[1]]], group[2:length(group)])
  }

  names_order <- names(metadata)
  unwrapped_metadata <- as.data.frame(metadata, stringsAsFactors = FALSE)
  for (key_main in names(compound_keys)) {
    keys_unwrap <- sprintf("%s/%s", key_main, unlist(compound_keys[[key_main]]))

    classes <- sapply(unwrapped_metadata[, keys_unwrap], class)
    if (all(classes != "list")) { next }

    to_bind <- lapply(1:nrow(unwrapped_metadata), function(i) {
      row <- unwrapped_metadata[i, ]

      row_unwrap <- row[, keys_unwrap]
      keys_duplicate <- setdiff(names(unwrapped_metadata), keys_unwrap)
      row_duplicate <- row[, keys_duplicate]

      unlisted <- lapply(keys_unwrap, function(key) {
        unlist(row_unwrap[, key])
      })

      n <- max(sapply(unlisted, length))
      unlisted_with_same_length <- lapply(unlisted, function(column) {
        if (length(column) < n) c(column, rep(NA, n - length(column))) else column
      })

      unwrapped <- do.call(cbind, unlisted_with_same_length)
      unwrapped <- as.data.frame(unwrapped, stringsAsFactors = FALSE)
      names(unwrapped) <- keys_unwrap

      result <- cbind(row_duplicate[c(rep(1, n)), ], unwrapped)
      result[, names_order]
    })

    unwrapped_metadata <- as.data.frame(rbindlist(to_bind))
  }

  unwrapped_metadata
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

  # Unwrap compound keys.
  metadata <- unwrap_compound_keys(metadata)

  # Unwrap multivalued columns.
  classes <- sapply(metadata, class)
  columns_to_unwrap <- names(metadata)[classes == "list"]

  for (column in columns_to_unwrap) {
    metadata <- splitstackshape::listCol_l(metadata, column)
  }

  # Method `listCol_l` modify original column names. Need to return original names back.
  setnames(metadata, sprintf("%s_ul", columns_to_unwrap), columns_to_unwrap)
  metadata <- as.data.frame(metadata)

  # Replace <NA> values with strings "<NA>". That allows to simplify keys classification and filtering logic.
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
  plot_ly(data = data,
          type = "box",
          boxpoints = "all", pointpos = 0, jitter = 0.2,
          line = list(width = 1.4)) %>%
    layout(title = list(text = title, xanchor = "left", x = 0.025),
           xaxis = list(type = "category",
                        title = "",
                        automargin = TRUE),
           yaxis = list(title = yaxis_title,
                        zeroline = FALSE,
                        automargin = TRUE,
                        hoverformat = ".2f")) %>% config(displayModeBar = F)
}

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
      add_boxplot(y = ~get(yaxis), x = ~get(xaxis),
                  text = ~paste0(`Sample Source ID`,": ", round(get(yaxis),2)), hoverinfo = 'text') %>%
      layout(showlegend = FALSE)
  } else {

    fig <- fig %>%
      add_boxplot(x = ~get(xaxis[1]), y = ~get(yaxis), color = ~get(xaxis[2]),
                  text = ~paste0(`Sample Source ID`,": ", round(get(yaxis),2)), hoverinfo = 'text') %>%
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
                        hoverformat = ".2f")) %>% config(displayModeBar = F)
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
    add_trace(x = ~get(xaxis), y = ~get(yaxis), name = "",
              text = ~paste0(`Sample Source ID`,": (", round(get(xaxis),2), ", ",
                             round(get(yaxis),2), ")"), hoverinfo = 'text') %>%
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
             xaxis = list(visible = FALSE), yaxis = list(visible = FALSE)) %>% config(displayModeBar = F)
    return(fig)
  }

  count_column <- get_unique_count_column_name(xaxis, yaxis)
  count <- data %>% count(get(xaxis), get(yaxis), name = count_column)
  names(count) <- c(xaxis, yaxis, count_column)

  categories <- unique(data[, yaxis])
  colors <- viridis(length(categories))

  fig <- plot_ly(data = count, type = "bar", colors = colors,
                 x = ~get(xaxis), y = ~get(count_column),
                 color = ~get(yaxis),

                 text = ~paste0(get(yaxis), ": ", get(count_column)), hoverinfo = 'text') %>%
    layout(barmode = "stack",
           hoverlabel = list(bgcolor = "black", font = list(color = "white")),
           title = list(text = title, xanchor = "left", x = 0.025),
           xaxis = list(type = "category",
                        title = list(text = xaxis, standoff = 5),
                        automargin = TRUE),
           yaxis = list(title = "Count",
                        zeroline = FALSE)) %>% config(displayModeBar = F)

  fig
}
# ----------------------------------  END  -------------------------------------

# ---------------------------  MAIN PLOT FUNCTION  -----------------------------
visualize <- function(type, data, xaxis, yaxis, title = NULL) {
  if (type == vtype_boxplot) {
    data[, yaxis] <- suppressWarnings(as.numeric(data[, yaxis]))
    data <- data[!is.na(data[, yaxis]), ]
    return(boxplot(unique(data), xaxis = xaxis, yaxis = yaxis, title = title))
  }

  if (type == vtype_scatterplot) {
    xaxis <- head(xaxis, 1)
    data[, xaxis] <- suppressWarnings(as.numeric(data[, xaxis]))
    data[, yaxis] <- suppressWarnings(as.numeric(data[, yaxis]))
    data <- data[!is.na(data[, xaxis]) & !is.na(data[, yaxis]), ]

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
<div>Cohort Report Viewer</div>
</div>
'

study_icon <- '
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 12C2.44772 12 2 11.5523 2 11L2 5C2 3.34315 3.34315 2 5 2L9.38197 2C9.76074 2 10.107 2.214 10.2764 2.55279L10.7236 3.44721C10.893 3.786 11.2393 4 11.618 4L16 4C17.1046 4 18 4.89543 18 6L18 11C18 11.5523 17.5523 12 17 12L3 12Z" fill="#B6D477"/>
<path d="M2 11C2 8.23858 4.23858 6 7 6H16C17.1046 6 18 6.89543 18 8V15C18 16.1046 17.1046 17 16 17H4C2.89543 17 2 16.1046 2 15V11Z" fill="#6C990F"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M15.0028 15.4648C16.916 14.3602 17.5715 11.9138 16.4669 10.0007C15.3623 8.0875 12.916 7.432 11.0028 8.53657C9.08962 9.64114 7.56809 12.5875 8.67266 14.5007C9.67814 16.2422 13.5 16.3324 15.0028 15.4648ZM12.8274 12C13.6558 12 15 11.5791 15 10.7507C15 9.92224 14.1558 9 13.3274 9C12.499 9 11.3125 9.92224 11.3125 10.7507C11.3125 11.5791 11.999 12 12.8274 12ZM13.7656 12.7902C13.2298 12.9238 12.9037 13.4665 13.0373 14.0024C13.1709 14.5383 13.7136 14.8644 14.2495 14.7308C14.7854 14.5971 15.4757 13.4483 15.342 12.9124C15.2187 12.4176 14.4358 12.6185 13.8947 12.7573L13.8946 12.7574L13.8944 12.7574C13.8497 12.7689 13.8066 12.78 13.7656 12.7902ZM11.7374 13.4353C12.0085 13.8554 11.8594 14.5466 11.4392 14.8177C11.019 15.0888 10.3279 14.9396 10.0568 14.5195C9.78574 14.0993 9.36022 13.1838 10.0839 12.7169C10.8077 12.25 11.4663 13.0151 11.7374 13.4353Z" fill="#B6D477"/>
</svg>
'

# ----------------------------------  UI  --------------------------------------
ui <- fluidPage(
  tags$head(
    tags$script(type="text/javascript", src = "js.cookie.min.js"),
    tags$script(type="text/javascript", src = "tokens.cookie.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "cohort-report-viewer-custom.css")
  ),

  withTags({
    div(class="root",
        h2(HTML(app_logo),
           div(class = "report-title", htmlOutput("reportTitle")),
           actionButton("resetTokens", "Reset Tokens")),

        div(class = "content",
            div(class="left", htmlOutput("filters")),
            div(class="main", htmlOutput("main")),
            div(class="right",
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
                               label = h4("Facet by ", tags$style(type = "text/css", "#q1 {vertical-align: top;}")),
                               choices = c(none),
                               selected = none,
                               multiple = FALSE))))
    }),
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

  odm_study_api <- reactive({
    client <- studyUser::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    studyUser::StudySPoTApi$new(client)
  })

  cohort_id <- reactive({
    query <- getQueryString()
    query$study
  })

  samples_metadata <- reactive({
    sample_ids <- get_cohort_sample_ids(odm_linkage_api(), cohort_id())
    get_samples_metadata(odm_sample_api(), sample_ids)
  })

  get_keys_classification <- reactive({
      metadata <- samples_metadata()
      keys_blacklist <- c('genestack:accession', 'Sample Source ID', 'Arvados URL')
      keys <- setdiff(names(metadata), keys_blacklist)

      keys_numeric <- Filter(function(key) {
        !anyNA(suppressWarnings(as.numeric(metadata[metadata[, key] != "<NA>", key])))
      }, keys)

      keys_categorical <- setdiff(keys, keys_numeric)

      keys_groups <- Filter(function(key) {
        to_check <- unique(metadata[, c(id_column, key)])
        length(unique(to_check[, key])) > 1
      }, keys_categorical)

      keys_classification <- list(
          'filters' = keys_categorical,
          'groups'  = keys_groups,
          'numeric' = keys_numeric
      )

      return(keys_classification)
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

  output$reportTitle <- renderUI({
    req(cohort_id(), odm_token())
    cohort_name <- odm_study_api()$get_study(cohort_id())$content["Study Title"]
    div(class = "report-title", HTML(study_icon), cohort_name)
  })


  output$filters <- renderUI({
    req(cohort_id(), odm_token())

    samples <- samples_metadata()
    filters <- selected_filters()
    keys    <- get_keys_classification()[["filters"]]

    checkbox_groups = lapply(keys, function(key){
      if (length(filters[[key]]) > 0) {
          samples_filtered <- apply_filters(within(filters, rm(list=key)), samples)
      } else {
          samples_filtered <- apply_filters(filters, samples)
      }

      choices <- unique(samples_filtered[, key])
      counts <- sapply(choices, function(choice) {
          length(unique(samples_filtered[samples_filtered[, key] == choice, id_column]))
      })
      choiceNames = paste(choices, counts)

      checkboxGroupInput(to_fid(key), key, choiceValues = choices, choiceNames = choiceNames, selected = filters[[key]])
    })

    do.call(tagList, checkbox_groups)
  })

  selected_filters <- reactive({
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
        subset <- subset[, c(id_column, sample_source_id_key, unique(c(input$xaxis, input$yaxis))), drop = FALSE]

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
