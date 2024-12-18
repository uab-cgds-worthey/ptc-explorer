dtUI <- function(id) {
  ns <- NS(id)
  tagList(
    dataTableOutput(ns("tbl")) %>% withSpinner()
  )
}

dtServer <- function(id, tempdf, server = FALSE, returnRow = FALSE, ...) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$tbl <- renderDT(server = server,{
      validate(
        need(!is.null(tempdf), "Please import data."))
      return(
        datatable(tempdf,selection = 'single', extensions = c('Responsive','Buttons'), 
                  class = 'cell-border stripe', rownames = FALSE,
                  width = "90%",
                  options = list(pageLength = 5,responsive = TRUE,
                                 dom = 'Bfrtip',
                                 buttons = list('pageLength','copy', list(
                                   extend = 'collection',
                                   buttons = c('csv', 'excel', 'pdf'),
                                   text = 'Download'
                                 )),
                                 ...)
        )
      )
    })
    
    outputOptions(output, "tbl", suspendWhenHidden = FALSE)
    
    
    if(returnRow){
      return(reactive(input$tbl_rows_selected))
    }
    
  })
}
