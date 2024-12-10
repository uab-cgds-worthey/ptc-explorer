geneSearch_page <- fluidPage(
  fluidRow(
    column(2,
           selectizeInput('gene_name',  "Gene Symbol",  choices = NULL)
          # uiOutput("gene_list_main")
    ),
    column(10,
           uiOutput("gene_info_main")
           
    )
  ),
  br(),
  hr(),
  h4("Genomic Analysis"),
  fluidRow(
    column(12,
           reactableUI("variant_df_by_gene"),
    )
  ),
  br(),
  hr(),
  h4("Differentially Expressed Genes"),
  tags$p("Differential gene expression analysis identified the differentially expressed genes (DEGs) for the following two contrasts:"),
  fluidRow(
    
    column(6,
           h4('All Samples: Tumor Vs Normal'),
           reactableUI("dds_all_deg_by_gene")
    ),
    column(6,
           h4('Tumor Samples: PTCPlusThy vs FTC'),
           reactableUI("dds_subtype_deg_by_gene")
    )
  ),
  hr(),
  br(),
  h4("RNA-Fusion"),
  fluidRow(
    column(12,
           reactableUI("rnafusion_df_by_gene")
           
    )
  ),
  hr(),
  br()
)
