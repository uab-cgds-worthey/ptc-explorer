rnaFusion_page <- fluidPage(
  h4("RNA-Fusion Analysis"),
  tags$p("Subtype-wise distribution of fusions detected using RNA-Seq within the tumor samples."),
  fluidRow(column(
    12,
    #    plotOutput("rna_fusion_4",  height = "1200px")
    plotlyOutput("rna_fusion_4",  height = "1200px")
  )),
  hr(),
  br()
)