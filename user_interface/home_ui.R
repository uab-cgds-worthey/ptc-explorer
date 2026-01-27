home_page <- fluidPage(
  fluidRow(
    class = "text-center",
    column(
      12,
      tags$p(
        "Pediatric Thyroid Cancer Explorer is an open-access resource for interactive exploration of
               rare pediatric differentiated thyroid cancer."
      ),
      tags$p("It characterizes the whole-exome and transcriptome from
               45 formalin-fixed paraffin-embedded (FFPE) surgical
               samples (tumor-normal) from pediatric patients with
               female predominance (<19 years).")
    )
  ),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      6,
      tags$h3("Study Design"),
      tags$p(
        style = "color:darkred;",
        "Flowchart showing RNA-Seq and WES study design and analytical steps performed."
      ), br(),
      tags$img(
        src = "img/workflow_fig1.png",
        style = "width: 90%; height: auto;"
      )
      # padding: 4px;
      # border: 2.5px solid darkgrey")
    ),
    column(
      6,
      tags$h3("Sample Clinical Feature"),
      tags$p(
        style = "color:darkred;",
        "Select a patient’s clinical feature from the below dropdown to visualize as a histogram plot."
      ),
      meta_plots_ui("sample_meta_stats")
    )
  ),
  br(),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      12,
      h3("Sample Metadata"),
      tags$p(
        style = "color:darkred;",
        "Table showing patients' clinical features in our study cohort."
      )
    )
  ),
  hr(),
  fluidRow(column(
    12,
    reactable_ui("sample_meta_df")
  )),
  br(),
  hr()
)
