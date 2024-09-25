rna_page <- fluidPage(
# Page title
titlePanel('RNA-seq Analysis'),
hr(),
fluidRow(
  h1("DEG Analysis"),
   column(6,h2('Column size 3')),
   column(6,h2('Column size 6'))
 ),
br(),
hr(),
br(),
fluidRow(
  h1("RNA-Fusion Analysis"),
  column(6,h2('Column size 3')),
  column(6,h2('Column size 6'))
),
br(),
hr(),
br(),
fluidRow(
  h1("Comparative Analysis"),
  column(6,h2('Column size 3')),
  column(6,h2('Column size 6'))
),
br(),
hr(),
# br(),
# fluidRow(
#   column(6,h2('Column size 3')),
#   column(6,h2('Column size 6'))
# ),
# br(),
# hr(),
br()
)
