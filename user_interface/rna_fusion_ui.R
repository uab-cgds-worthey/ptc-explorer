rna_fusion_page <- fluidPage(
  fluidRow(class = "text-center",
           column(
             12,
             h3("RNA-Fusion Analysis"),
             tags$p(style = "color:darkred;",
                    "Table showing RNA-fusions in our study cohort."
             )
           )),
  hr(),
  fluidRow(column(12,
                  fusion_filter_ui("rna_fusion_tbl"))),
  br(),
  hr()
)

