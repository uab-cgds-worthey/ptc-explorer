gene_search_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    class = "m-4",
    column(
      12,
      fluidRow(
        column(4,
               style = "display: flex; flex-direction: column;
          justify-content: left; 
          align-items: left; height: 100%;",
               h4(style = "color:darkred; justify-content: center !important;",
                  "Select or search a gene to display gene annotation and it's participation in our dataset."
               ),
               # fluidRow(
               #   column(12,
                        radioGroupButtons(
                          inputId = ns("gene_type"),
                          label = "Select a gene category",
                          choices = c("All Genes","Candidate Genes"),
                          selected = "Candidate Genes",
                          justified = TRUE
                        ),
                        selectizeInput(
                          ns("gene_name"),
                          "Select a gene symbol",
                          choices = NULL,
                          width = "550px"
                        ),
               #          )
               # ),
               tags$p(style = "font-size: 95% !important; color:grey;",
                 "'All Genes' - This is an aggregated list of significant genes in our 
          whole exome, bulk RNA-seq and downstream analysis."
               ),
               tags$p(style = "font-size: 95% !important; color:grey;",
                 "'Candidate Genes' - This is an aggregated list of candidate genes (genes of interest) in our 
          whole exome, bulk RNA-seq and downstream analysis."
               ),
          ),
        column(
          8,
          h3("Gene Information", class = "text-center",
             style = "color: darkgreen; font-weight: 900;"),
          hr(),
          div(style = "font-size: 110% !important;",
              uiOutput(ns("gene_info_main"))
          )
        ),
      ),
      br(),
      hr(),
      fluidRow(
        class = "text-center",
        #column(1, ),
        column(
          12,
          style = "padding-right: 10px;",
          h3("Variant Analysis",
             style = "color: darkgreen; font-weight: 900;"),
          hr(),
          reactable_ui(ns("variant_df_by_gene")),
        ),
        #column(1, )
      ),
      br(),
      hr(),
      fluidRow(class = "text-center",
               column(
                 12,
                 h3("Differential Gene Expression Analysis",
                    style = "color: darkgreen; font-weight: 900;"),
               )),
      fluidRow(
        class = "text-center",
        column(
          6,
          style = "border-right: 1px solid #ccc; padding-right: 5px;",
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
      br(),
      hr(),
      fluidRow(column(
        12,
        h3("Gene Expression from TCGA", class = "text-center",
           style = "color: darkgreen; font-weight: 900;"),
        div(class = "text-center",
            uiOutput(ns("ualcan_redirect"))
        ),
      )),
      br(),
      hr(),
      fluidRow(
        class = "text-center",
        #column(1, ),
        column(
          12,
          h3("RNA-Fusion Analysis",
             style = "color: darkgreen; font-weight: 900;"),
          hr(),
          reactable_ui(ns("rnafusion_df_by_gene"))
        ),
        #column(1, )
      ),
      hr(),
      br()
    )
  ))
}

gene_search_server <- function(id,
                               gene_list,
                               candidate_gene_list,
                               var_table,
                               deg_t_vs_n,
                               deg_ptc_vs_ftc,
                               fusion_table) {
  moduleServer(id,
               function(input, output, session) {
                 
                 observeEvent(input$gene_type, {
                   if(input$gene_type == "All Genes"){
                     gene_list_in <- gene_list
                   } else {
                     gene_list_in <- candidate_gene_list
                   }
                   
                   updateSelectizeInput(
                     session,
                     "gene_name",
                     choices = gene_list_in,
                     selected = gene_list_in[1],
                     server = TRUE
                   )
                   
                 })
                 
                 filtered_gene_df <- reactiveVal(var_table)
                 observeEvent(input$gene_name, {
                   
                   validate(need(!is.null(input$gene_name),
                                 "Please select a gene"))
                   
                   output$ualcan_redirect <- renderUI({
                     fluidRow(
                       column(
                         12,
                         p(paste0("Expression of gene ",
                                  input$gene_name,
                                  " in THCA cohort based on tumor histology 
                                  subtype via UALCAN cancer data portal.")),
                         tags$a(href = paste0(
                           "https://ualcan.path.uab.edu/cgi-bin/TCGAExResultNew2.pl?genenam=",
                           input$gene_name,
                           "&ctype=THCA&add=1"
                         ), "Click here to view on UALCAN",
                         target = "_blank")
                         )
                     )

                     
                   })
                   
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
                     defaultColDef = colDef(align = "left"),
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
                     defaultColDef = colDef(align = "left"),
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
                     defaultColDef = colDef( minWidth = 95, align = "left"),
                     reactive_tbl = FALSE,
                     null_msg = "This gene is not found to be significantly 
                     participating in our RNA-fusion analysis."
                   )
                 })
                 reactable_server("variant_df_by_gene",
                                  filtered_gene_df,
                                  defaultColDef = colDef(align = "left"),
                                  null_msg = "No variant of interest was found
                                  in this gene.")
                 output$gene_info_main <- renderUI({
                   req(input$gene_name)
                   gene_query(input$gene_name)
                 })
               })
}
