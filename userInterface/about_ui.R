about_page <- fluidPage(
  # Page title
  titlePanel('About'),
  hr(),
  fluidRow(
    column(6,h2('Column size 3')),
    column(6,h2('Column size 6'))
  )
)
