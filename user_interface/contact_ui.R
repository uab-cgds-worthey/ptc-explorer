contact_page <- fluidPage(
  fluidRow(
    class = "text-center",
    column(
      12,
      h3("Pediatric Thyroid Cancer Explorer Development Team")
    )
  ),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      4,
      profile_ui("gk")
    ),
    column(
      4,
      profile_ui("sb")
    ),
    column(
      4,
      profile_ui("lw")
    )
  )
)
