home_page <- fluidPage(
# Page title
#titlePanel('Home Page'),
fluidRow(
  column(12,
         tags$h3("Project Overview"),
         includeMarkdown("desc/home_intro.Rmd")
  )
),
hr(),
fluidRow(
  column(6,
         tags$h3("Study Design"),
         tags$img(src = "img/study_design.png", 
                  style = "width: 90%; height: auto;")
         ),
  column(6,
         tags$h3("Sample Statistics"),
         verbatimTextOutput("sample_summary")
  )
),
  br(),
  hr(),
  br(),
h3("Sample Metadata"),
fluidRow(
  column(12, 
         dtUI("sample_meta_df")
  )
),
# br(),
# hr(),
# h3("Interactive Oncoplot"),
# fluidRow(
#   column(6,h2('Column size 3')),
#   column(6,h2('Column size 6'))
# ),
br(),
hr()
)
