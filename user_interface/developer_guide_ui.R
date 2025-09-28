developer_guide_page <- fluidPage(
  fluidRow(
    column(12,
      tabsetPanel(
        id = "developer_guide_tabs",
        type = "pills",
        
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
        
        tabPanel(
          "Architecture & Modules",
          icon = icon("puzzle-piece"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/MODULES_COMPONENTS.md")
            ),
            column(1, )
          )
        ),
        
        tabPanel(
          "Data Management",
          icon = icon("database"),
          fluidRow(
            column(1, ),
            column(10,
              includeMarkdown("docs/DYNAMIC_DATA_LOADING.md")
            ),
            column(1, )
          )
        ),
        
        tabPanel(
          "Development Workflow",
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