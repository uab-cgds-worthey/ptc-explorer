home_page <- fluidPage(
  fluidRow(class = "text-center",
    column(12,
           tags$h2("Pediatric Thyroid Cancer Explorer"),
           tags$h5("It is an open-access resource for interactive exploration of rare pediatric differentiated thyroid cancer. It characterizes the whole-exome and transcriptome from 45 formalin-fixed paraffin-embedded (FFPE) surgical samples (tumor-normal) from pediatric patients with female predominance (<19 years).")

    )
  ),
  hr(),
  fluidRow(
    column(6,
           tags$h3("Study Design"),
           tags$img(src = "img/workflow_fig1.png", 
                    style = "width: 90%; height: auto;")
    ),
    column(6,
           tags$h3("Sample Statistics"),
           metaPlotsUI("sample_meta_stats")
          
    )
  ),
  br(),
  hr(),
  # br(),
  h3("Sample Metadata"),
  fluidRow(
    column(12, 
           reactableUI("sample_meta_df")
    )
  ),
  br(),
  hr()
)
