user_guide_page <- fluidPage(
  fluidRow(
    column(12,
      tabsetPanel(
        id = "user_guide_tabs",
        type = "pills",

        tabPanel(
          "User Guide",
          icon = icon("book"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/USER_GUIDE.md")
            ),
            column(1, )
          )
        ),

        tabPanel(
          "App Documentation",
          icon = icon("info-circle"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/DOCUMENTATION.md")
            ),
            column(1, )
          )
        )
      )
    )
  ),
  br()
)

