reactableUI <- function(id) {
  ns <- NS(id)
  tagList(
  fluidRow(
    column(12,
           uiOutput(ns("reactable_uiManage")) %>% withSpinner()
           )
  )
  )
}

reactableServer <- function(id, tbl, 
                            #col_defs = NULL,
                            reactive_tbl = TRUE,
                            null_msg = "No data available for this.",
                            ...) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ns <- session$ns
      
       output$reactable_tbl <- renderReactable({
        req(tbl)
        if(reactive_tbl){
          reactable(tbl(),
                    showPageSizeOptions = TRUE,
                    searchable = TRUE,
                    #outlined = TRUE,
                    compact = TRUE,
                    #borderless = TRUE,
                    ...)
        }else(
          reactable(tbl,
                    showPageSizeOptions = TRUE,
                    searchable = TRUE,
                    #outlined = TRUE,
                    compact = TRUE,
                    #borderless = TRUE,
                    ...)
        )
      })
       
      output$placeholder_text <- renderUI({
        
        fluidRow(class = "text-center",
          column(12,
                 h4(null_msg, style = "color: darkred;")
                 )
        )
        
      })
      
      
      output$reactable_uiManage <- renderUI({
        
        main_data <- if (reactive_tbl) tbl() else tbl
        # print(nrow(main_data))
        if(is.null(main_data) || nrow(main_data) == 0){
          
          uiOutput(ns("placeholder_text"))
          
        }else{
          reactableOutput(ns("reactable_tbl"))
        }
        
      })

    }
  )
}