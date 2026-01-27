enrichr_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(
      12,
      uiOutput(ns("enrichr_dbs_opt")),
      br(),
      h4("Pathways affected by upregulated genes"),
      plotlyOutput(ns("enrichr_plot_1")),
      br(),
      dt_ui(ns("enrich_up")),
      uiOutput(ns("placeholder_up"))
    )
  ), hr(), fluidRow(column(
    12,
    h4("Pathways affected by downregulated genes"),
    plotlyOutput(ns("enrichr_plot_2")),
    br(),
    dt_ui(ns("enrich_down")),
    uiOutput(ns("placeholder_down"))
  )))
}

enrichr_server <- function(id, x, dbs, precalculate = FALSE) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    log2FoldChange <- NULL
    if (precalculate) {
      output$enrichr_dbs_opt <- renderUI({
        req(dbs)
        selectInput(
          ns("enrichr_sel_opt"),
          "EnrichR databases",
          choices = dbs,
          selected = dbs[1]
        )
      })
      output$enrichr_plot_1 <- renderPlotly({
        validate(need(
          !is.null(input$enrichr_sel_opt),
          "Please select a database."
        ))
        selected_db <- input$enrichr_sel_opt
        enriched_up_df <- x[[selected_db]][["up_df"]]
        enriched_up_plot <-
          x[[selected_db]][["up_plot"]]
        dt_server("enrich_up", enriched_up_df)
        plotEnrich(enriched_up_plot, title = selected_db)
      })
      output$placeholder_up <- renderUI({
        NULL
      })
      output$enrichr_plot_2 <- renderPlotly({
        validate(need(
          !is.null(input$enrichr_sel_opt),
          "Please select a database."
        ))
        selected_db <- input$enrichr_sel_opt
        enriched_down_df <-
          x[[selected_db]][["down_df"]]
        enriched_down_plot <-
          x[[selected_db]][["down_plot"]]
        dt_server("enrich_down", enriched_down_df)
        plotEnrich(enriched_down_plot, title = selected_db)
      })
      output$placeholder_down <- renderUI({
        NULL
      })
    } else {
      x_up <- rownames(x %>% subset(log2FoldChange > 0))
      x_down <-
        rownames(x %>% subset(log2FoldChange < 0))
      clean_enrichr_df <-
        function(enrichr_df, source_name) {
          enrichr_df <- enrichr_df[, c(1:4, 7:9)]
          enrichr_df[, c(3:4)] <-
            round(enrichr_df[, c(3:4)], 4)
          enrichr_df[, c(5, 6)] <-
            round(enrichr_df[, c(5, 6)], 2)
          colnames(enrichr_df) <-
            c("Enriched Term",
              "Overlap",
              "pVal",
              "adjPval",
              "OR",
              "Score",
              "Genes")
          enrichr_df
        }
      output$enrichr_dbs_opt <- renderUI({
        req(dbs)
        selectInput(
          ns("enrichr_sel_opt"),
          "EnrichR databases",
          choices = dbs,
          selected = dbs[1]
        )
      })
      output$enrichr_plot_1 <- renderPlotly({
        req(x_up)
        validate(
          need(
            !is.null(input$enrichr_sel_opt),
            "Please select a database."
          ),
          need(
            !purrr::is_empty(x_up),
            "No significant genes for analysis."
          )
        )
        selected_db <- input$enrichr_sel_opt
        enriched <- enrichr(x_up, databases = c(selected_db))
        if (is.null(enriched[[1]]) ||
              nrow(enriched[[1]]) == 0) {
          enriched_up_df <-
            clean_enrichr_df(enriched[[1]], source_name = "up")
          dt_server("enrich_up", enriched_up_df)
          output$placeholder_up <- renderUI({
            div(
              style = "display: flex;
                           flex-direction: column;
                           height: 20vh;
                           text-align:center; font-size: 14px; color: gray;",
              "No data available"
            )
          })
        } else {
          enriched_up_df <-
            clean_enrichr_df(enriched[[1]], source_name = "up")
          dt_server("enrich_up", enriched_up_df)
          output$placeholder_up <- renderUI({
            NULL
          })
        }
        validate(need(
          nrow(enriched[[1]]) != 0,
          "No results found. Please try changing database."
        ))
        plotEnrich(enriched[[1]], title = selected_db)
      })
      output$enrichr_plot_2 <- renderPlotly({
        req(x_down)
        validate(
          need(
            !is.null(input$enrichr_sel_opt),
            "Please select a database."
          ),
          need(
            !purrr::is_empty(x_down),
            "No significant genes for analysis."
          )
        )
        selected_db <- input$enrichr_sel_opt
        enriched <- enrichr(x_down, databases = c(selected_db))
        if (is.null(enriched[[1]]) ||
              nrow(enriched[[1]]) == 0) {
          enriched_down_df <-
            clean_enrichr_df(enriched[[1]], source_name = "down")
          dt_server("enrich_down", enriched_down_df)
          output$placeholder_down <- renderUI({
            div(
              style = "display: flex; flex-direction: column;
                           height: 20vh;
                           text-align:center; font-size: 14px; color: gray;",
              "No data available"
            )
          })
        } else {
          enriched_down_df <-
            clean_enrichr_df(enriched[[1]], source_name = "down")
          dt_server("enrich_down", enriched_down_df)
          output$placeholder_down <- renderUI({
            NULL
          })
        }
        validate(need(
          nrow(enriched[[1]]) != 0,
          "No results found. Please try changing database."
        ))
        plotEnrich(enriched[[1]], title = selected_db)
      })
    }
  })
}
