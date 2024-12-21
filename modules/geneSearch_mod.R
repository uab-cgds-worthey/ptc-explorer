gene_search_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    class = "m-4",
    column(
      12,
      fluidRow(
        column(
          12,
          style = "display: flex; flex-direction: column;
          justify-content: center; 
          align-items: center; height: 100%;",
          selectizeInput(
            ns("gene_name"),
            "Select a gene symbol",
            choices = NULL,
            width = "550px"
          ),
          h4(
            "This is an aggregated list of significant genes in our 
            whole exome, bulk RNA-seq and downstream analysis. Select or 
            search a gene to display gene annotation and it's 
            participation in our dataset."
          )
        ),
      ),
      br(),
      hr(),
      fluidRow(column(
        12,
        h3("Gene Information", class = "text-center",
           style = "color: darkgreen; font-weight: 900;"),
        hr(),
        uiOutput(ns("gene_info_main"))
      )),
      hr(),
      fluidRow(
        class = "text-center",
        column(2, ),
        column(
          8,
          style = "padding-right: 10px;",
          h3("Variant Analysis",
             style = "color: darkgreen; font-weight: 900;"),
          hr(),
          reactable_ui(ns("variant_df_by_gene")),
        ),
        column(2, )
      ),
      hr(),
      fluidRow(
        class = "text-center",
        column(2, ),
        column(
          8,
          h3("RNA-Fusion Analysis",
             style = "color: darkgreen; font-weight: 900;"),
          hr(),
          reactable_ui(ns("rnafusion_df_by_gene"))
        ),
        column(2, )
      ),
      hr(),
      fluidRow(class = "text-center",
               column(
                 12,
                 h3("Differentially Expressed Genes",
                    style = "color: darkgreen; font-weight: 900;"),
               )),
      fluidRow(
        class = "text-center",
        column(
          6,
          style = "border-right: 2px solid #ccc; padding-right: 10px;",
          hr(),
          h4("All Samples: Tumor Vs Normal"),
          reactable_ui(ns("dds_all_deg_by_gene"))
        ),
        column(
          6,
          hr(),
          h4("Tumor Samples: PTCPlusThy vs FTC"),
          reactable_ui(ns("dds_subtype_deg_by_gene"))
        )
      ),
      hr(),
      br()
    )
  ))
}

gene_search_server <- function(id,
                               gene_list,
                               var_table,
                               deg_t_vs_n,
                               deg_ptc_vs_ftc,
                               fusion_table) {
  moduleServer(id,
               function(input, output, session) {
                 updateSelectizeInput(
                   session,
                   "gene_name",
                   choices = gene_list,
                   selected = "BRAF",
                   server = TRUE
                 )
                 filtered_gene_df <- reactiveVal(var_table)
                 observeEvent(input$gene_name, {
                   validate(need(!is.null(input$gene_name),
                                 "Please select a gene"))
                   temp_gene_df <-
                     var_table[var_table$Gene %in% input$gene_name, ]
                   filtered_gene_df(temp_gene_df)
                   reactable_server(
                     "dds_all_deg_by_gene",
                     clean_sig_df(
                       deg_t_vs_n,
                       rename_cols = TRUE,
                       gene = input$gene_name
                     ),
                     reactive_tbl = FALSE,
                     null_msg = "This gene is not found to be differentially 
                     expressed between our Tumor Vs Normal samples."
                   )
                   reactable_server(
                     "dds_subtype_deg_by_gene",
                     clean_sig_df(
                       deg_ptc_vs_ftc,
                       rename_cols = TRUE,
                       gene = input$gene_name
                     ),
                     reactive_tbl = FALSE,
                     null_msg = "This gene is not found to be differentially 
                     expressed between our PTCPlusThy vs FTC samples."
                   )
                   rna_fusion_df_filtered <-
                     fusion_table[fusion_table$geneA %in% input$gene_name |
                                  fusion_table$geneB %in% input$gene_name, ]
                   reactable_server(
                     "rnafusion_df_by_gene",
                     rna_fusion_df_filtered,
                     reactive_tbl = FALSE,
                     null_msg = "This gene is not found to be significantly 
                     participating in our RNA-fusion analysis."
                   )
                 })
                 reactable_server("variant_df_by_gene",
                                  filtered_gene_df,
                                  null_msg = "This gene is not found to be 
                                  significantly participating in our 
                                  variant analysis.")
                 output$gene_info_main <- renderUI({
                   req(input$gene_name)
                   gene_query(input$gene_name)
                 })
               })
}
