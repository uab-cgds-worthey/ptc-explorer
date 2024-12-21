gene_info_ui <- function(id) {
  ns <- NS(id)
  tagList(uiOutput(ns("gene_info")))
}

gene_info_server <- function(id,
                             selected_row,
                             tbl,
                             gene_symbol_col,
                             query = TRUE,
                             ...) {
  moduleServer(id,
               function(input, output, session) {
                 output$gene_info <- renderUI({
                   req(selected_row())
                   col <- tbl[selected_row(), gene_symbol_col]
                   if (query) {
                     gene_query(col)
                   } else {
                     gene_annotated(col)
                   }
                 })
               })
}
