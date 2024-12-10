geneSearch_page <- fluidPage(
  fluidRow(
    column(2,
           uiOutput("gene_list_main")
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
           dtUI("dds_all_deg_by_gene")
    ),
    column(6,
           h4('Tumor Samples: PTCPlusThy vs FTC'),
           dtUI("dds_subtype_deg_by_gene")
    )
  ),
  hr(),
  br(),
  h4("RNA-Fusion"),
  hr(),
  br(),
  fluidRow(
    column(12,
           
    )
  )
)
