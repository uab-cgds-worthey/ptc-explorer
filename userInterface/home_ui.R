home_page <- fluidPage(
  fluidRow(class = "text-center",
           column(
             12,
             #tags$h2("Pediatric Thyroid Cancer Explorer"),
             tags$p(
               "Pediatric Thyroid Cancer Explorer is an open-access resource for interactive exploration of 
               rare pediatric differentiated thyroid cancer."
             ),
             tags$p("It characterizes the whole-exome and transcriptome from 
               45 formalin-fixed paraffin-embedded (FFPE) surgical 
               samples (tumor-normal) from pediatric patients with 
               female predominance (<19 years).")
           )),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      6,
      tags$h3("Study Design"),
      tags$p(style = "color:darkred;",
             "A workflow figure to show our study design and methods."
      ),
      tags$img(src = "img/workflow_fig1.png",
               style = "width: 90%; height: auto;")
    ),
    column(
      6,
      tags$h3("Sample Statistics"),
      tags$p(style = "color:darkred;",
             "Select a patient feature from the dropdown to show in summary plot."
             ),
      meta_plots_ui("sample_meta_stats")
    )
  ),
  br(),
  hr(),
  fluidRow(class = "text-center",
           column(12,
                  h3("Sample Metadata"))),
  hr(),
  fluidRow(column(12,
                  reactable_ui("sample_meta_df"))),
  br(),
  hr()
)
