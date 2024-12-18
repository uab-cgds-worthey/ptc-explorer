geneSearchUI <- function(id) {
  ns <- NS(id)
  tagList(
  fluidRow(class = "m-4",
    column(12,
           fluidRow(
             # column(3,
             #        h4("This is an aggregated list of found genes in our whole exome, bulk RNA-seq and their downstream analysis. Select or search a gene to display gene annotation and it's participation in our dataset.")
             # ),
             column(12,
                    style = "display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100%;",
                    selectizeInput(ns('gene_name'),  "Select a gene symbol",
                                   choices = NULL,
                                   width = "550px"),
                    h4("This is an aggregated list of significant genes in our whole exome, bulk RNA-seq and downstream analysis. Select or search a gene to display gene annotation and it's participation in our dataset.")
             ),
             # column(8,
             #        h3("Gene Information", class = "text-center"),
             #        hr(),
             #        uiOutput(ns("gene_info_main"))
             #        )
           ),
           br(),
           hr(),
           fluidRow(
                    column(12,
                           # h4("Gene Information"),
                           h3("Gene Information", class = "text-center",
                              style = "color: darkgreen; font-weight: 900;"),
                           hr(),
                           uiOutput(ns("gene_info_main"))
                    )),
           # hr(),
           # fluidRow(class = "p-4",
           #   column(12,
           #          uiOutput(ns("gene_info_main"))
           #          
           #   )
           # ),
           # br(),
           hr(),
           # fluidRow(class = "text-center",
           #          column(12,
           #   h3("Genomic Analysis: Variant Analysis"),
           #          )),
           # hr(),
           fluidRow(class = "text-center",
             column(6, style = "border-right: 2px solid #ccc; padding-right: 10px;", 
                    h3("Variant Analysis",
                       style = "color: darkgreen; font-weight: 900;"),
                    hr(),
                    reactableUI(ns("variant_df_by_gene")),
             ),
             column(6,
                    h3("RNA-Fusion Analysis",
                       style = "color: darkgreen; font-weight: 900;"),
                    hr(),
                    reactableUI(ns("rnafusion_df_by_gene")))
           ),
           # br(),
           hr(),
           # fluidRow(class = "text-center",
           #          column(12,
           # h3("Differentially Expressed Genes")
           #          )),
           # hr(),
           fluidRow(class = "text-center",
             column(6, style = "border-right: 2px solid #ccc; padding-right: 10px;", 
                    h3("Differentially Expressed Genes",
                       style = "color: darkgreen; font-weight: 900;"),
                    hr(),
                    h4('All Samples: Tumor Vs Normal'),
                    reactableUI(ns("dds_all_deg_by_gene"))
             ),
             column(6,
                    h3("Differentially Expressed Genes",
                       style = "color: darkgreen; font-weight: 900;"),
                    hr(),
                    h4('Tumor Samples: PTCPlusThy vs FTC'),
                    reactableUI(ns("dds_subtype_deg_by_gene"))
             )
           ),
           # hr(),
           # br(),
           # fluidRow(class = "text-center",
           #          column(12,
           # h3("RNA-Fusion"),
           #          )),
           # hr(),
           # fluidRow(
           #   column(12,
           #          # reactableUI(ns("rnafusion_df_by_gene"))
           #          
           #   )
           # ),
           hr(),
           br()
           
           )
  )
  )
}

geneSearchServer <- function(id, geneList, var_table, deg_t_vs_n,
                             deg_ptc_vs_ftc, fusion_table) {
  moduleServer(
    id,
    function(input, output, session) {
      
      
      updateSelectizeInput(session, 'gene_name', 
                           choices = geneList, 
                           selected = "BRAF",
                           server = TRUE)
      
      filtered_gene_df <- reactiveVal(var_table)
      
      observeEvent(input$gene_name,{
        validate(
          need(!is.null(input$gene_name), "Please select a gene"))
        
        
        temp_gene_df <- var_table[var_table$Gene %in% input$gene_name, ]
        filtered_gene_df(temp_gene_df)
        
        reactableServer("dds_all_deg_by_gene",
                        clean_sig_df(deg_t_vs_n, renameCols = TRUE, gene = input$gene_name),
                        reactive_tbl = FALSE,
                        null_msg = "This gene is not found to be differentially expressed between our Tumor Vs Normal samples.")
        
        reactableServer("dds_subtype_deg_by_gene",
                        clean_sig_df(deg_ptc_vs_ftc, renameCols = TRUE, gene = input$gene_name),
                        reactive_tbl = FALSE,
                        null_msg = "This gene is not found to be differentially expressed between our PTCPlusThy vs FTC samples.")
        
        rna_fusion_df_filtered <- fusion_table[fusion_table$geneA %in% input$gene_name |
                                                 fusion_table$geneB %in% input$gene_name,
        ]
        reactableServer("rnafusion_df_by_gene",
                        rna_fusion_df_filtered,
                        reactive_tbl = FALSE,
                        null_msg = "This gene is not found to be significantly participating in our RNA-fusion analysis.")
        
        
      })
      
      reactableServer("variant_df_by_gene",
                      filtered_gene_df,
                      null_msg = "This gene is not found to be significantly participating in our variant analysis.", fullWidth = FALSE)
      
      
      
      output$gene_info_main <- renderUI({
        req(input$gene_name)
        
        gene_query(input$gene_name)
        
      })
      
      
    }
  )
}