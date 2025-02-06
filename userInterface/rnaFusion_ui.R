rna_fusion_page <- fluidPage(
  fluidRow(class = "text-center",
           column(
             12,
             h3("RNA-Fusion Analysis"),
           )),
  hr(),
  fluidRow(column(12,
                  fusion_filter_ui("rna_fusion_tbl"))),
  br(),
  hr()
)
