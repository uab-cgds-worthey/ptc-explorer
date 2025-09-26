meta_plots_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(column(
    12,
    # style = "display: flex; flex-direction: column;
    #       justify-content: center; 
    #       align-items: center; height: 100%;",
    uiOutput(ns("sample_meta_cols")),
    plotlyOutput(ns("meta_plot"),  height = "550px")
  )))
}

meta_plots_server <-
  function(id, sample_df, fact_cols, num_cols, ...) {
    moduleServer(id,
                 function(input, output, session) {
                   ns <- session$ns
                   Subtypes <- NULL
                   Subtypes_color = c("FA" = "#E31A1C", "FTC" = "#FDBF6F",
                                "NIFTP" = "#FF7F00", "PTC" = "#CAB2D6",
                                "PTCplusTHY" = "#6A3D9A", "THY" = "#FFFF99")
                   output$sample_meta_cols <- renderUI({
                     req(sample_df)
                     fluidRow(column(
                       12,
                       selectInput(ns("meta_col"),
                                   "Sample Features",
                                   choices = sort(colnames(sample_df)[-c(1, 4)])),
                     ))
                   })
                   observeEvent(input$meta_col, {
                     output$meta_plot <- renderPlotly({
                       validate(need(!is.null(input$meta_col),
                                     "Please select a feature"))
                       fs_meta_plot <- 12
                       if (input$meta_col %in% fact_cols) {
                         p1 <- ggplot(sample_df,
                                      aes(fill = Subtypes,
                                          x = !!sym(input$meta_col))) +
                           geom_bar(position = "dodge",color = "black") +
                           labs(
                             title = paste0(
                               "Counts of feature: ",
                               str_replace_all(input$meta_col,
                                               "_", " ")
                             ),
                             x = str_replace_all(input$meta_col,
                                                 "_", " "),
                             fill = "Subtypes",
                             y = "Counts"
                           ) +
                           scale_x_discrete(
                             labels = function(x) {
                               str_wrap(str_replace_all(x, "_", " "),
                                        width = 10)
                             }
                           ) +
                           theme_minimal() +
                           theme(
                             plot.title = element_text(size = fs_meta_plot + 4,
                                                       face = "bold"),
                             axis.title.x = element_text(
                               size = fs_meta_plot + 2,
                               margin = margin(t = 20),
                               face = "bold"
                             ),
                             axis.title.y = element_text(size = fs_meta_plot + 2,
                                                         face = "bold"),
                             axis.text.x = element_text(size = fs_meta_plot),
                             axis.text.y = element_text(size = fs_meta_plot),
                             legend.title = element_text(size = fs_meta_plot + 2),
                             legend.text = element_text(size = fs_meta_plot)
                           ) + scale_fill_manual(values = Subtypes_color)
                           #scale_fill_brewer(palette = "Set2")
                         ggplotly(p1)
                       } else if (input$meta_col %in% num_cols) {
                         ggplot(sample_df, aes(x = !!sym(input$meta_col))) +
                           geom_histogram(
                             binwidth = 5,
                             fill = "#00a5cf",#ccd5ae
                             color = "black",
                             alpha = 0.7
                           ) +
                           labs(
                             title = paste0(
                               "Histogram of feature: ",
                               str_replace_all(input$meta_col, "_", " ")
                             ),
                             x = "Values",
                             y = "Frequency"
                           ) +
                           theme_minimal() +
                           theme(
                             plot.title = element_text(size = fs_meta_plot + 4,
                                                       face = "bold"),
                             axis.title.x = element_text(
                               size = fs_meta_plot + 2,
                               margin = margin(t = 20),
                               face = "bold"
                             ),
                             axis.title.y = element_text(size = fs_meta_plot + 2,
                                                         face = "bold"),
                             axis.text.x = element_text(size = fs_meta_plot),
                             axis.text.y = element_text(size = fs_meta_plot),
                             legend.title = element_text(size = fs_meta_plot + 2),
                             legend.text = element_text(size = fs_meta_plot)
                           )
                       }
                     })
                   })
                 })
  }
