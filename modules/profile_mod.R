profile_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("profile_div_shiny"))
  )
}

profile_server <- function(id,
                           name = NULL,
                           img_url = NULL,
                           title = NULL,
                           email = NULL,
                           linkedin_url = NULL,
                           x_url = NULL,
                           web_url = NULL,
                           github_url = NULL,
                           img_style = NULL,
                           ...) {
  moduleServer(
    id,
    function(input, output, session) {
      img_url <- paste0("img/", img_url)

      output$profile_div_shiny <- renderUI({
        fluidRow(
          class = "profile_div_main",
          column(
            12,
            div(
              class = "profile_div_img",
              tags$img(
                src = img_url,
                alt = name,
                style = img_style,
                ...
              ),
            ),
            h3(name),
            tags$p(title),
            tags$a(
              style = "color:darkred;",
              href = paste0(
                "mailto:",
                email
              ),
              icon("square-envelope", "fa-2x"),
              target = "_blank"
            ),
            # tags$a(
            #   href = linkedin_url,
            #   target = "_blank"
            # ),
            tags$a(
              style = "color:black;",
              href = x_url,
              icon("square-x-twitter", "fa-2x"),
              target = "_blank"
            ),
          )
        )
      })
    }
  )
}
