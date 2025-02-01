rna_fusion_page <- fluidPage(
  fluidRow(class = "text-center",
           column(
             12,
             h3("RNA-Fusion Analysis"),
             # tags$p(
             #   "Subtype-wise distribution of fusions detected using 
             #   RNA-Seq within the tumor samples."
             # )
           )),
  hr(),
  # fluidRow(column(
  #   12,
  #   plotlyOutput("rna_fusion_4",  height = "1200px")
  # )),
  # hr(),
  fluidRow(column(12,
                  fusion_filter_ui("rna_fusion_tbl"))),
  br(),
  hr()
)
