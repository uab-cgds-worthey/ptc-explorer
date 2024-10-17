wes_page <- fluidPage(
  # Page title
#  titlePanel('Whole Exome Sequencing Analysis'),
#  hr(),
  fluidRow(
    h3("Sample Variant Information"),
    column(12, 
           dtUI("sample_variant_df")
           )
  ),
  br(),
  hr(),
  br(),
  fluidRow(
    column(12, tags$h3("Mutational Signature Analysis")
    )
  ),
  fluidRow(
    column(6,
           tags$h3("Mutations in each sample"),
           tags$img(src = "img/mutational_sign_2.png", 
                    style = "width: 90%; height: auto;"
           )
    ),
    column(6,
           tags$h3("MSI levels in PTC tumors"),
           tags$img(src = "img/mutational_signature_4.png", 
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  fluidRow(
    tags$h3("SBS Signatures"),
    column(6,
           tags$img(src = "img/mutational_sign_0.png", 
                    style = "width: 90%; height: auto;"
           )
           ),
    column(6,
           tags$img(src = "img/mutational_sign_1.png", 
                    style = "width: 90%; height: auto;"
           )
           )
  ),
  br(),
  hr(),
  br(),
  fluidRow(
    tags$h3("Clonal Analysis"),
    column(12,
           tags$img(src = "img/clonal_analysis_1.png", 
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  br(),
  hr()
)
