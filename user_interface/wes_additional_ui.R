wes_additional_page <- fluidPage(
  fluidRow(
    class = "text-center",
    column(
      12,
      tags$h3("Mutational Signature Analysis"),
      tags$p(
        style = "color:darkred;",
        "A summary of the signatures identified
               in this study is shown below.
               For details about the specific single base substitution (SBS),
               click on the respective tabs on the right."
      )
    )
  ),
  hr(),
  fluidRow(
    column(4, ),
    column(
      8,
      tabsetPanel(
        type = "tabs",
        tabPanel(
          title = "Mutations in each Signature",
          tags$img(
            src = "img/fig_2c.png",
            style = "width: auto; height: 90%;"
          )
        ),
        tabPanel(
          title = "SBS Signature Group 1",
          tags$img(
            src = "img/mutational_sign_0.png",
            style = "width: auto; height: 90%;"
          )
        ),
        tabPanel(
          title = "SBS Signature Group 2",
          tags$img(
            src = "img/mutational_sign_1.png",
            style = "width: auto; height: 90%;"
          )
        )
      )
    )
  ),
  br(),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      12,
      tags$h3("Tumor Clonal Evolution Analysis"),
      tags$p(
        style = "color:darkred;",
        "Select a case ID to view the clonal analysis of somatic variation identified in tumors."
      )
    )
  ),
  hr(),
  fluidRow(
    column(4, ),
    column(
      4,
      selectizeInput(
        "clonal_case_select",
        "Select Case ID:",
        choices = NULL,
        width = "100%"
      )
    ),
    column(4, )
  ),
  br(),
  fluidRow(
    column(2, ),
    column(
      8,
      div(
        class = "d-flex justify-content-center align-items-center",
        clonal_analysis_ui("clonal_analysis_tab")
      )
    ),
    column(2, )
  ),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      12,
      tags$h3("Microsatellite Instability (MSI) Analysis"),
      tags$p(
        style = "color:darkred;",
        "Subtype-wise distribution of MSI levels among the tumor samples."
      )
    )
  ),
  hr(),
  fluidRow(
    column(4, ),
    column(
      6,
      div(
        class = "d-flex justify-content-center align-items-center",
        tags$img(
          src = "img/mutational_signature_4.png",
          style = "width: 75%; height: auto;"
        )
      )
    ),
    column(2, )
  ),
  br(),
  hr()
)
