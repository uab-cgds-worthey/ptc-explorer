docs_page <- fluidPage(
  fluidRow(
    column(12,
      tabsetPanel(
        id = "docs_tabs",
        type = "tabs",
        
        # Main App Documentation Tab
        tabPanel(
          "App Guide",
          icon = icon("book"),
          fluidRow(
            column(2, ),
            column(8,
              style = "display: flex; flex-direction: column;
              justify-content: center;
              align-items: left; height: 100%;",
              includeMarkdown("docs/ptce_docs.Rmd")
            ),
            column(2, )
          )
        ),
        
        # User Guide Tab
        tabPanel(
          "User Guide",
          icon = icon("user-guide"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/USER_GUIDE.md")
            ),
            column(1, )
          )
        ),
        
        # Technical Reference Tab
        tabPanel(
          "Technical Reference",
          icon = icon("cog"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/TECHNICAL_REFERENCE.md")
            ),
            column(1, )
          )
        ),
        
        # Modules & Components Tab
        tabPanel(
          "Modules & Components", 
          icon = icon("puzzle-piece"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/MODULES_COMPONENTS.md")
            ),
            column(1, )
          )
        ),
        
        # Main Documentation Tab
        tabPanel(
          "Full Documentation",
          icon = icon("file-text"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/DOCUMENTATION.md")
            ),
            column(1, )
          )
        ),
        
        # Developer/Linting Guide Tab
        tabPanel(
          "Development Guide",
          icon = icon("wrench"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/LINTING_GUIDE.md")
            ),
            column(1, )
          )
        )
      )
    )
  ),
  br()
)

