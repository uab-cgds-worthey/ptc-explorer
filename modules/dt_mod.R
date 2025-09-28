dt_ui <- function(id) {
  ns <- NS(id)
  tagList(dataTableOutput(ns("tbl")) %>% withSpinner())
}

dt_server <-
  function(id,
           tempdf,
           server = FALSE,
           return_row = FALSE,
           ...) {
    moduleServer(id, function(input, output, session) {
      output$tbl <- renderDT(server = server, {
        validate(need(!is.null(tempdf), "Please import data."))
        return(
          datatable(
            tempdf,
            selection = "single",
            extensions = c("Responsive", "Buttons"),
            class = "cell-border stripe",
            rownames = FALSE,
            width = "90%",
            options = list(
              pageLength = 5,
              responsive = TRUE,
              dom = "Bfrtip",
              buttons = list(
                "pageLength",
                "copy",
                list(
                  extend = "collection",
                  buttons = c("csv", "excel", "pdf"),
                  text = "Download"
                )
              ),
              ...
            )
          )
        )
      })
      if (return_row) {
        reactive(input$tbl_rows_selected)
      }
    })
  }

