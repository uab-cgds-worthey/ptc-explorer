download_page <- fluidPage(
  fluidRow(
    class = "text-center",
    column(
      12,
      h3("Download Latest Datasets"),
      br(),
      p("Download the most recent versions of the application datasets in RDS format:"),
      br(),
      div(
        class = "download-section",
        style = "max-width: 600px; margin: 0 auto;",

        # App Data Pack Download
        div(
          class = "download-item",
          style = "background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 20px; margin: 15px 0;",
          h4("Main Application Data", style = "color: darkred; margin-top: 0;"),
          p("Complete dataset including variants, expression data, clinical metadata, and analysis results."),
          # Version information
          div(
            style = "margin: 10px 0; padding: 8px; background-color: #e7f3ff; border-left: 3px solid #007bff; font-size: 0.9em;",
            strong("📅 File: "),
            span(ifelse(exists("app_data_file_info") && !is.null(app_data_file_info$filename),
              app_data_file_info$filename, "Loading..."
            )), br(),
            strong("🕒 Version: "),
            span(ifelse(exists("app_data_version") && !is.null(app_data_version),
              app_data_version, "Not available"
            ))
          ),
          downloadButton(
            "download_app_data",
            "Download app_data_pack.rds",
            class = "btn-primary",
            style = "background-color: darkred; border-color: darkred; font-weight: bold; padding: 10px 20px;"
          )
        ),

        # Oncoplot Data Download
        div(
          class = "download-item",
          style = "background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 20px; margin: 15px 0;",
          h4("Oncoplot Visualization Data", style = "color: darkgreen; margin-top: 0;"),
          p("Pre-processed oncoplot objects for variant visualization and analysis."),
          # Version information
          div(
            style = "margin: 10px 0; padding: 8px; background-color: #d4edda; border-left: 3px solid #28a745; font-size: 0.9em;",
            strong("📅 File: "),
            span(ifelse(exists("onco_file_info") && !is.null(onco_file_info$filename),
              onco_file_info$filename, "Loading..."
            )), br(),
            strong("🕒 Version: "),
            span(ifelse(exists("onco_data_version") && !is.null(onco_data_version),
              onco_data_version, "Not available"
            ))
          ),
          downloadButton(
            "download_onco_data",
            "Download ptc_onco_obj_list.rds",
            class = "btn-success",
            style = "background-color: darkgreen; border-color: darkgreen; font-weight: bold; padding: 10px 20px;"
          )
        )
      ),
      br(),
      div(
        style = "max-width: 600px; margin: 0 auto; padding: 15px; background-color: #e9ecef; border-radius: 8px;",
        h5("Usage Information", style = "color: #495057; margin-top: 0;"),
        p("These RDS files can be loaded directly into R/RStudio using:", style = "margin-bottom: 8px;"),
        code("data <- readRDS('filename.rds')", style = "display: block; background-color: white; padding: 8px; border-radius: 4px;"),
        br(),
        p("Files contain the most recent data available and are updated automatically.", style = "font-style: italic; margin-bottom: 0;")
      )
    )
  )
)
