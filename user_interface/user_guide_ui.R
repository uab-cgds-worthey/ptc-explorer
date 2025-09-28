user_guide_page <- fluidPage(
  fluidRow(
    column(12,
      tabsetPanel(
        id = "user_guide_tabs",
        type = "pills",
        
        tabPanel(
          "Getting Started",
          icon = icon("play-circle"),
          fluidRow(
            column(2, ),
            column(8,
              includeMarkdown("docs/ptce_docs.Rmd")
            ),
            column(2, )
          )
        ),
        
        tabPanel(
          "User Manual",
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