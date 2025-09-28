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
                   
                   # Validate and get gene information
                   tryCatch({
                     col_value <- tbl[selected_row(), gene_symbol_col]
                     
                     # Check if column value is valid
                     if (is.null(col_value) || is.na(col_value) || col_value == "") {
                       return(HTML(
                         "<div style='padding: 15px; text-align: center; background-color: #f8f9fa; border: 1px dashed #dee2e6; border-radius: 6px; color: #6c757d;'>",
                         "<strong>🧬 No Gene Selected</strong><br/>",
                         "Click on any gene in the table above to view detailed information including:<br/>",
                         "• Gene name and symbol<br/>",
                         "• Entrez and Ensembl IDs<br/>",
                         "• Functional summary<br/><br/>",
                         "<small>Select a row from the data table to get started</small>",
                         "</div>"
                       ))
                     }
                     
                     result <- if (query) {
                       gene_query(col_value)
                     } else {
                       gene_annotated(col_value)
                     }
                     
                     return(result)
                     
                   }, error = function(e) {
                     return(HTML(
                       "<div style='padding: 12px; border: 1px solid #dc3545; border-radius: 6px; background-color: #f8d7da; color: #721c24;'>",
                       "<strong>🔧 Technical Issue</strong><br/>",
                       "There was a problem displaying gene information.<br/>",
                       "<small style='color: #6c757d;'>Error details: ", e$message, "</small><br/><br/>",
                       "<strong>💡 Try:</strong><br/>",
                       "• Refreshing the page<br/>",
                       "• Selecting a different gene<br/>",
                       "• Checking your internet connection",
                       "</div>"
                     ))
                   })
                 })
               })
}

