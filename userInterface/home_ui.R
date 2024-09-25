home_page <- fluidPage(
# Page title
titlePanel('Home Page'),
hr(),
fluidRow(
  h1("Interactive Oncoplot"),
  column(6,h2('Column size 3')),
  column(6,h2('Column size 6'))
),
br(),
hr(),
br(),
fluidRow(
  h1("Expression Heatmap"),
  column(6,h2('Column size 3')),
  column(6,h2('Column size 6'))
),
br(),
hr(),
br(),
fluidRow(
  h1("Gene Search"),
  column(6,h2('Column size 3')),
  column(6,h2('Column size 6'))
),
br(),
hr(),
)
