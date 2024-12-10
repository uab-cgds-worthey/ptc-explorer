wes_page <- fluidPage(
  tags$h3("Mutational Signature Analysis"),
  tags$p("A summary of the signatures identified in this study is reported below. For details about the specific single base substitution (SBS), click on the respective tabs on the right."),
  fluidRow(
    column(8,
           
           tabsetPanel(
             type = "tabs",
             tabPanel(
               title = "Mutations in each Signature",
               tags$img(src = "img/fig_2c.png", 
                        style = "width: auto; height: 75%;"
               )
             ),
             tabPanel(
               title = "SBS Signature Image 1",
               tags$img(src = "img/mutational_sign_0.png", 
                        style = "width: auto; height: 75%;"
               )
             ),
             tabPanel(
               title = "SBS Signature Image 2",
               tags$img(src = "img/mutational_sign_1.png", 
                        style = "width: auto; height: 75%;"
               )
             )
             
           )
           # tags$h3("MSI levels in PTC tumors"),
           # tags$img(src = "img/mutational_signature_4.png", 
           #          style = "width: 90%; height: auto;"
           # )
    )
  ),
  hr(),
  br(),
  fluidRow(
    column(6,
           tags$h3("Tumor clonal evolution"),
           tags$p("Clonal analysis of somatic variation identified signatures of mutational processes in tumors from participant 2, 17 and 18."),
           tags$img(src = "img/clonal_analysis.png",
                    style = "width: 90%; height: auto;"
           )
    ),
    # ),
    # hr(),
    # br(),
  ),
  hr(),
    fluidRow(
    column(6,
           tags$h3("Microsatellite instability (MSI) analysis"),
           tags$p("Subtype-wise distribution of MSI levels among the tumor samples."),
           # fluidRow(
           # column(12,
           # tags$h3("MSI levels in PTC tumors"),
           tags$img(src = "img/mutational_signature_4.png",
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  br(),
  hr()
)