home_page <- fluidPage(
  fluidRow(
    column(12,
           tags$h3("Pediatric Thyroid Cancer Explorer"),
           includeMarkdown("desc/home_intro.Rmd")
    )
  ),
  hr(),
  fluidRow(
    column(8,
           tags$h3("Study Design"),
           tags$img(src = "img/workflow_fig1.png", 
                    style = "width: 90%; height: auto;")
    ),
    column(4,
           tags$h3("Sample Statistics"),
           uiOutput("sample_meta"),
           plotOutput("meta_plot")
           # verbatimTextOutput("sample_summary")
    )
  ),
  br(),
  hr(),
  # br(),
  h3("Sample Metadata"),
  fluidRow(
    column(12, 
           # dtUI("sample_meta_df")
           reactableUI("sample_meta_df")
    )
  ),
  br(),
  hr()
)
