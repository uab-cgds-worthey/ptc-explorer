wes_page <- fluidPage(
  # Page title
  titlePanel('Whole Exome Sequencing Analysis'),
  hr(),
  fluidRow(
    h1("Variant Analysis"),
    column(6,h2('Column size 3')),
    column(6,h2('Column size 6'))
  ),
  br(),
  hr(),
  br(),
  fluidRow(
    h1("Mutational Signature Analysis"),
    column(6,h2('Column size 3')),
    column(6,h2('Column size 6'))
  ),
  br(),
  hr(),
  br(),
  fluidRow(
    h1("Clonal Analysis"),
    column(6,h2('Column size 3')),
    column(6,h2('Column size 6'))
  ),
  br(),
  hr(),
)
