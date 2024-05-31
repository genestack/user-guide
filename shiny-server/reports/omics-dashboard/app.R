library(httr)
library(rjson)
library(RCurl)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(plotly)
library(splitstackshape)
library(data.table)
library(plyr)
library(dplyr)
library(tidyr)
library(viridis)
library(integrationCurator)

# -------------------------------  Constants  ----------------------------------
# Target ODM url.
Sys.setenv("ODM_URL" = "https://odm-demos.genestack.com/")
Sys.setenv(PRED_SPOT_HOST = 'odm-demos.genestack.com',
           PRED_SPOT_TOKEN = 'tknRoot',
           PRED_SPOT_VERSION = 'default-released')
odm_url <- parse_url(Sys.getenv("ODM_URL"))

# Target ODM host.
odm_host <- if (is.null(odm_url$port)) odm_url$hostname else paste0(odm_url$hostname, ":", odm_url$port)

# ODM API version.
version <- "default-released"

# ODM scheme.
scheme <- odm_url$scheme

# Metadata keys.
sample_source_id_key <- "Sample Source ID"

none <- "<none>"
no_value <- "No value"
expression_key_A <- "<Gene 1 Expression>"
expression_key_B <- "<Gene 2 Expression>"

id_column <- "genestack:accession" # Must be unique accross all the samples.

# Visualization types.
vtype_boxplot     <- "Box Plot"
vtype_scatterplot <- "Scatter Plot"
vtype_barchart    <- "Bar Chart"

visualization_types <- c(vtype_boxplot, vtype_scatterplot, vtype_barchart)
# ----------------------------------  END  -------------------------------------

# ---------------------------------  UTILS  ------------------------------------
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

      row_unwrap <- row[, keys_unwrap, drop = FALSE]
      keys_duplicate <- setdiff(names(unwrapped_metadata), keys_unwrap)
      row_duplicate <- row[, keys_duplicate, drop = FALSE]

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

      result <- suppressWarnings(cbind(row_duplicate[c(rep(1, n)), , drop = FALSE], unwrapped))
      result[, names_order]
    })

    unwrapped_metadata <- as.data.frame(rbindlist(to_bind))
  }

  unwrapped_metadata
}

get_samples_metadata <- function(odm_sample_api, study_id) {
  data_frames <- list()
  offset <- 0
  limit <- 20000

  # repeat{
  #   response <- odm_sample_api$get_samples_by_study(
  #     id = study_id,
  #     page_offset = offset,
  #     page_limit = limit
  #   )
  #
  #   data_frames <- c(data_frames, list(response$content$data))
  #   offset <- offset + limit
  #
  #   if (offset >= response$content$meta$pagination$total) {
  #     break
  #   }
  # }
  #
  # # Bind all data.frames together.
  # metadata <- rbindlist(data_frames, fill = TRUE)

  # response <- integrationCurator::OmicsQueriesApi_search_samples(
  #     id = study_id,
  #     page_offset = offset,
  #     page_limit = limit
  # )
  # metadata = response$content$data
  # print(metadata)

  response <- integrationCurator::OmicsQueriesApi_search_samples(
      study_filter = paste0('genestack:accession=',study_id),
      page_limit = limit
  )
  metadata = response$content$data[['metadata']]
  print(metadata[1:10, ])

  # Remove NA column (for missed template keys).
  # metadata <- metadata[, which(unlist(lapply(metadata, function(x) !all(is.na(x))))), with = F]

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

  # Remove empty/NA columns
  metadata <- metadata[,colSums(is.na(metadata))<nrow(metadata)]
  metadata <- metadata[,colSums(metadata != "", na.rm=TRUE) != 0]

  # Replace <NA> values with strings "No value". That allows to simplify keys classification and filtering logic.
  metadata[is.na(metadata)] <- no_value
  metadata[metadata == ""]  <- no_value

  # Remove columns where all values are the same.
  selector <- apply(metadata, 2, function(column) length(unique(column)) > 1)
  metadata[, selector]

  print(nrow(metadata))

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

get_expression_data <- function(omics_api, study_id, gene) {
  limit <- 20000
  cursor <- NULL

  data_frames <- list()

  repeat {
    page <- omics_api$search_expression_data(
      study_filter = sprintf('"genestack:accession"=%s', study_id),
      ex_query     = sprintf("Feature=%s MinValue=0.0", gene),
      page_limit   = limit,
      cursor       = cursor
    )

    content <- page$content
    if (length(content$data) == 0) { break }

    expression_data_page <- cbind(
      content$data$metadata,
      content$data$relationships[, "sample", drop = FALSE],
      content$data[, c("itemId", "expression", "groupId")]
    )

    data_frames <- c(data_frames, list(expression_data_page))
    if (content$resultsExhausted) { break }
    cursor <- content$cursor
  }

  expression_data <- rbindlist(data_frames, fill = TRUE)
  expression_data
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
  plot_ly(data = data, type = "scatter", mode = "markers", hoverinfo = "x+y") %>%
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
             xaxis = list(visible = FALSE), yaxis = list(visible = FALSE)) %>% config(displayModeBar = F)
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
<div>Omics Dashboard</div>
</div>
'

study_icon <- '
<svg class="gs-icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 12C2.44772 12 2 11.5523 2 11L2 5C2 3.34315 3.34315 2 5 2L9.38197 2C9.76074 2 10.107 2.214 10.2764 2.55279L10.7236 3.44721C10.893 3.786 11.2393 4 11.618 4L16 4C17.1046 4 18 4.89543 18 6L18 11C18 11.5523 17.5523 12 17 12L3 12Z" fill="#B6D477"/>
<path d="M2 11C2 8.23858 4.23858 6 7 6H16C17.1046 6 18 6.89543 18 8V15C18 16.1046 17.1046 17 16 17H4C2.89543 17 2 16.1046 2 15V11Z" fill="#6C990F"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M15.0028 15.4648C16.916 14.3602 17.5715 11.9138 16.4669 10.0007C15.3623 8.0875 12.916 7.432 11.0028 8.53657C9.08962 9.64114 7.56809 12.5875 8.67266 14.5007C9.67814 16.2422 13.5 16.3324 15.0028 15.4648ZM12.8274 12C13.6558 12 15 11.5791 15 10.7507C15 9.92224 14.1558 9 13.3274 9C12.499 9 11.3125 9.92224 11.3125 10.7507C11.3125 11.5791 11.999 12 12.8274 12ZM13.7656 12.7902C13.2298 12.9238 12.9037 13.4665 13.0373 14.0024C13.1709 14.5383 13.7136 14.8644 14.2495 14.7308C14.7854 14.5971 15.4757 13.4483 15.342 12.9124C15.2187 12.4176 14.4358 12.6185 13.8947 12.7573L13.8946 12.7574L13.8944 12.7574C13.8497 12.7689 13.8066 12.78 13.7656 12.7902ZM11.7374 13.4353C12.0085 13.8554 11.8594 14.5466 11.4392 14.8177C11.019 15.0888 10.3279 14.9396 10.0568 14.5195C9.78574 14.0993 9.36022 13.1838 10.0839 12.7169C10.8077 12.25 11.4663 13.0151 11.7374 13.4353Z" fill="#B6D477"/>
</svg>
'

# ----------------------------------  UI  --------------------------------------
ui <- fluidPage(title = "Omics Dashboard",
  shinyjs::useShinyjs(),

  tags$head(
    tags$script(type="text/javascript", src = "js.cookie.min.js"),
    tags$script(type="text/javascript", src = "tokens.cookie.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "omics-dashboard-custom.css")
  ),

  withTags({
    div(class="root",
        h2(HTML(app_logo),
           div(class = "report-title", htmlOutput("reportTitle")),
           actionButton("resetTokens", "Reset Token")),

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
                shinyjs::disabled(
                  textInput("geneA", label = h4("Gene 1"))
                ),
                shinyjs::disabled(
                  textInput("geneB", label = h4("Gene 2"))
                ),
                hr(),
                selectizeInput("facetBy",
                               label = h4("Facet by ", tags$style(type = "text/css", "#q1 {vertical-align: top;}")),
                               choices = c(),
                               multiple = FALSE))))
    }),
)
# ----------------------------------  END  -------------------------------------

server <- function(input, output, session) {
  axes_state <- reactiveVal(list(x = NULL, y = NULL, facetBy = none))
  previous_filters <- reactiveVal(NULL)

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

  odm_sample_api <- reactive({
    req(odm_token())

    client <- integrationCurator::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    integrationCurator::SampleIntegrationApi$new(client)
  })

  odm_study_api <- reactive({
    req(odm_token())

    client <- studyUser::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    studyUser::StudySPoTApi$new(client)
  })

  odm_expression_api <- reactive({
    req(odm_token())

    client <- integrationCurator::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    integrationCurator::ExpressionIntegrationApi$new(client)
  })

  odm_omics_api <- reactive({
    req(odm_token())

    client <- client <- integrationCurator::ApiClient$new(
      host    = odm_host,
      version = version,
      scheme  = scheme,
      token   = odm_token()
    )

    integrationCurator::OmicsQueriesApi$new(client)
  })

  study_id <- reactive({
    query <- getQueryString()
    query$study
  })

  samples_metadata <- reactive({
    req(study_id(), odm_sample_api())
    get_samples_metadata(odm_sample_api(), study_id())
  })

  samples_expression_A <- reactive({
    req(study_id(), odm_omics_api(), input$geneA)
    expression <- get_expression_data(odm_omics_api(), study_id(), input$geneA)
    if (nrow(expression) == 0) NULL else expression
  })

  samples_expression_B <- reactive({
    req(study_id(), odm_omics_api(), input$geneB)
    expression <- get_expression_data(odm_omics_api(), study_id(), input$geneB)
    if (nrow(expression) == 0) NULL else expression
  })

  get_keys_classification <- reactive({

      metadata <- samples_metadata()
      print("get_keys_classification")
      keys_blacklist <- c("genestack:accession", "Sample Source ID", "Arvados URL", "groupId", "genestack:name", "Name")
      keys <- setdiff(names(metadata), keys_blacklist)

      keys_numeric <- Filter(function(key) {
        notna <- metadata[metadata[, key] != no_value, key]
        length(notna) > 0 & !anyNA(suppressWarnings(as.numeric(notna)))
      }, keys)

      keys_categorical <- setdiff(keys, keys_numeric)
      keys_categorical <- Filter(function(key) {
          length(unique(metadata[, key])) < min(50, nrow(metadata)-1) # don't want to show too many vaues
      }, keys_categorical)

      keys_groups <- Filter(function(key) {
        length(unique(metadata[, key])) > 1
      }, keys_categorical)

      keys_classification <- list(
          "filters" = keys_categorical,
          "groups"  = keys_groups,
          "numeric" = keys_numeric
      )

      return(keys_classification)
  })

  has_expression_data <- reactive({
    req(study_id(), odm_expression_api())
    response <- odm_expression_api()$get_parents_by_study(study_id())
    nrow(response$content) > 0
  })

  observeEvent(input$xaxis, {
    state <- isolate(axes_state())
    axes_state(list(x = input$xaxis, y = state$y, facetBy = state$facetBy))
  }, ignoreNULL = FALSE)

  observeEvent(input$yaxis, {
    state <- isolate(axes_state())
    axes_state(list(x = state$x, y = input$yaxis, facetBy = state$facetBy))
  }, ignoreNULL = FALSE)

  observeEvent(input$facetBy, {
    state <- isolate(axes_state())
    axes_state(list(x = state$x, y = state$y, facetBy = input$facetBy))
  }, ignoreNULL = FALSE)

  # Filters selectize input update, all metadata keys are available for filtering.
  observe({
    req(study_id(), odm_token())

    keys_classification <- get_keys_classification()
    keys_groups  <- keys_classification[["groups"]]
    keys_numeric <- keys_classification[["numeric"]]

    if (has_expression_data()) {
      keys_numeric <- c(keys_numeric, expression_key_A, expression_key_B)
    }

    if (input$visualizationType == vtype_boxplot) {
      updateSelectizeInput(session, "xaxis", choices = keys_groups, selected = keys_groups[1],
                           options = list(maxItems = 2))
      updateSelectizeInput(session, "yaxis", choices = keys_numeric, selected = keys_numeric[1])
      axes_state(list(x = keys_groups[1], y = keys_numeric[1], facetBy = none))
    } else if (input$visualizationType == vtype_scatterplot) {
      updateSelectizeInput(session, "xaxis", choices = keys_numeric, selected = keys_numeric[1],
                           options = list(maxItems = 1))
      updateSelectizeInput(session, "yaxis", choices = keys_numeric, selected = keys_numeric[1])
      axes_state(list(x = keys_numeric[1], y = keys_numeric[1], facetBy = none))
    } else if (input$visualizationType == vtype_barchart) {
      updateSelectizeInput(session, "xaxis", choices = keys_groups, selected = keys_groups[1],
                           options = list(maxItems = 1))
      updateSelectizeInput(session, "yaxis", choices = keys_groups, selected = keys_groups[1])
      axes_state(list(x = keys_groups[1], y = keys_groups[1], facetBy = none))
    } else {
      stop("Unknown visualization type")
    }

    updateSelectizeInput(session, "facetBy", choices = c(none, keys_groups), selected = none)
  })

  output$reportTitle <- renderUI({
    req(study_id(), odm_token())
    cohort_name <- odm_study_api()$get_study(study_id())$content["genestack:accession"]
    div(class = "report-title", HTML(study_icon), cohort_name)
  })

  selected_filters <- reactive({
    keys <- get_keys_classification()[["filters"]]

    values <- lapply(keys, function(key) input[[to_fid(key)]])
    names(values) <- keys
    values <- values[sapply(values, function(x) !is.null(x))]
    if (length(values) == 0) { return(NULL) }

    values
  })

  output$filters <- renderUI({
    req(study_id(), odm_token())

    samples <- samples_metadata()
    keys    <- get_keys_classification()[["filters"]]

    checkbox_groups = lapply(keys, function(key){
      choices <- unique(samples[, key])
      counts <- sapply(choices, function(choice) {
        length(unique(samples[samples[, key] == choice, id_column]))
      })
      choice_names <- paste(choices, counts)

      checkboxGroupInput(to_fid(key), key, choiceValues = choices, choiceNames = choice_names)
    })

    do.call(tagList, checkbox_groups)
  })

  observe({
    req(study_id(), odm_token())

    samples <- samples_metadata()
    filters <- selected_filters()
    keys <- get_keys_classification()[["filters"]]

    if (length(isolate(previous_filters)) > 0) {
      keys <- setdiff(keys, names(filters[!(filters %in% isolate(previous_filters()))]))
    }

    for (key in keys) {
      if (length(filters[[key]]) > 0) {
        samples_filtered <- apply_filters(within(filters, rm(list = key)), samples)
      } else {
        samples_filtered <- apply_filters(filters, samples)
      }

      choices <- unique(samples_filtered[, key])
      counts <- sapply(choices, function(choice) {
        length(unique(samples_filtered[samples_filtered[, key] == choice, id_column]))
      })
      choice_names <- paste(choices, counts)

      arrangement <- order(counts, decreasing = TRUE)
      updateCheckboxGroupInput(inputId = to_fid(key),
                               choiceValues = choices[arrangement],
                               choiceNames = choice_names[arrangement],
                               selected = filters[[key]])

    }

    previous_filters(filters)
  })

  observe({
    if ((expression_key_A %in% input$xaxis) || (expression_key_A %in% input$yaxis))
      shinyjs::enable("geneA")
    else
      shinyjs::disable("geneA")
  })

  observe({
    if ((expression_key_B %in% input$xaxis) || (expression_key_B %in% input$yaxis))
      shinyjs::enable("geneB")
    else
      shinyjs::disable("geneB")
  })

  plots <- reactive({
    filters <- selected_filters()
    samples <- apply_filters(filters, samples_metadata())

    xaxis <- axes_state()$x
    yaxis <- axes_state()$y
    facet_by <- axes_state()$facetBy

    if (expression_key_A %in% c(xaxis, yaxis)) {
      expression_A <- req(samples_expression_A())
      expression_A <- expression_A[, c("sample", "expression")]
      colnames(expression_A) <- c("genestack:accession", expression_key_A)
      samples <- merge(samples, expression_A, by = "genestack:accession")
    }

    if (expression_key_B %in% c(xaxis, yaxis)) {
      expression_B <- req(samples_expression_B())
      expression_B <- expression_B[, c("sample", "expression")]
      colnames(expression_B) <- c("genestack:accession", expression_key_B)
      samples <- merge(samples, expression_B, by = "genestack:accession")
    }

    if (facet_by == none) {
      features <- c(none)
    } else {
      features <- unique(samples[, facet_by])
    }

    indices <- seq(from = 1, to = length(features))
    plot_ids <- paste0("plot_", indices)

    # Create box plots list.
    boxplots <- lapply(plot_ids, plotlyOutput)

    lapply(indices, function(index) {
      feature <- features[index]
      output[[plot_ids[index]]] <- renderPlotly({
        req(study_id(), odm_token(), xaxis, yaxis)

        title  <- if (feature == none) NULL    else feature
        subset <- if (feature == none) samples else samples[samples[, facet_by] == feature, ]
        subset <- subset[, c(id_column, sample_source_id_key, unique(c(xaxis, yaxis))), drop = FALSE]

        visualize(type = isolate(input$visualizationType),
                  data = subset,
                  xaxis = xaxis,
                  yaxis = yaxis,
                  title = title)
      })
    })

    do.call(tagList, boxplots)
  })

  output$main <- renderUI({
    req(study_id(), odm_token(), input$facetBy, cancelOutput = TRUE)
    plots()
  })
}

# options(shiny.port = 3838)
shinyApp(ui = ui, server = server)
