gprofiler_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(
      12,
      plotlyOutput(ns("go_plot")) %>% withSpinner(),
      br(),
      dt_ui(ns("go_res")) %>% withSpinner()
    )
  ))
}

gprofiler_server <- function(id, x, input_gostres = FALSE) {
  moduleServer(id,
               function(input, output, session) {
                 clean_gosrest_df <- function(go_results) {
                   go_results <- go_results[, c(11, 10, 9, 3, 7, 8, 4, 5)]
                   go_results[, c(5, 6)] <-
                     round(go_results[, c(5, 6)], 3)
                   return(go_results)
                 }
                 output$go_plot <- renderPlotly({
                   req(x)
                   if (!input_gostres) {
                     gostres <- isolate(
                       gost(
                         query = x,
                         organism = "hsapiens",
                         ordered_query = FALSE,
                         multi_query = FALSE,
                         significant = TRUE,
                         exclude_iea = FALSE,
                         measure_underrepresentation = FALSE,
                         evcodes = FALSE,
                         user_threshold = 0.05,
                         correction_method = "g_SCS",
                         # "bonferroni", # "g_SCS",
                         domain_scope = "annotated",
                         custom_bg = NULL,
                         numeric_ns = "",
                         sources = NULL,
                         as_short_link = FALSE,
                         highlight = TRUE
                       )
                     )
                   } else {
                     gostres <- x
                   }
                   dt_server("go_res", clean_gosrest_df(gostres$result))
                   gostplot(gostres, capped = FALSE, interactive = TRUE)
                 })
               })
}
