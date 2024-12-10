rna_page <- fluidPage(
  h4("Prinical Component Analysis (PCA)"),
  tags$p("An unsupervised linear transformation technique, for dimensionality reduction to uncover interesting patterns and find any technical biases while preserving the biological variation in the dataset. First, we used phenotype (tumor and normal), batch and sex as factors which revealed distinctive clusters for tumor and normal samples (left PCA plot). Additionally, we also used six phenotype_subtypes, batch and sex as factors showing clustering of normal and tumor samples by subtypes (right PCA plot)."),
  fluidRow(
    column(6, add_busy_bar(),
           h4('All Samples: Tumor Vs Normal'),
           tags$img(src = "img/pca_label_batch-corr_b&w_pid.png", 
                    style = "width: 90%; height: auto;"
           )
           # plotOutput("pca_cell_1")
    ),
    column(6,
           h4('Tumor Samples: PTCPlusThy vs FTC'),
           # plotOutput("pca_cell_2")
           tags$img(src = "img/pca_label_batch-corr_subtypes_pid.png", 
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  br(),
  hr(),
  fluidRow(
    h4("Differentially Expressed Genes"),
    tags$p("Differential gene expression analysis identified the differentially expressed genes (DEGs) for the following two contrasts:"),
    column(6,
           h4('All Samples: Tumor Vs Normal'),
           dtUI("dds_all_deg"),
           br(),
           gene_infoUI("sel_gene_t_vs_n")
    ),
    column(6,
           h4('Tumor Samples: PTCPlusThy vs FTC'),
           dtUI("dds_subtype_deg"),
           br(),
           gene_infoUI("sel_gene_PTC_vs_FTC")
    )
  ),
  #br(),
  hr(),
  fluidRow(
    #h5("DEG Analysis"),
    column(6, 
           h4('All Samples: Tumor Vs Normal'),
           volcanoUI("vol_aff_unaff")
    ),
    column(6, 
           h4('Tumor Samples: PTCPlusThy vs FTC'),
           volcanoUI("vol_ptc_vs_ftc"))
  ),
  br(),
  hr(),
  h4("Enrichment Anlaysis using: gProfiler"),
  fluidRow(
    column(6,
           gprofilerUI("go_t_vs_n")),
    column(6,
           gprofilerUI("go_PTC_vs_FTC")
    )
    
  ),
  br(),
  hr(),
  h4("Enrichment Anlaysis using: Enrichr databases"),
  h3("Enrichment analysis using Enrichr databases"),
  fluidRow(
    column(6,
           enrichrUI("enrichr_t_vs_n")),
    column(6,
           enrichrUI("enrichr_PTC_vs_FTC")
    )
  ),
  br(),
  hr(),
  br()
)