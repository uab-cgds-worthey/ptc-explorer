rna_page <- fluidPage(
  fluidRow(class = "text-center",
           column(2, ),
           column(
             8,
             h3("Prinical Component Analysis (PCA)"),
             tags$p(
               "An unsupervised linear transformation technique, for 
               dimensionality reduction to uncover interesting patterns and 
               find any technical biases while preserving the biological 
               variation in the dataset. First, we used phenotype (tumor 
               and normal), batch and sex as factors which revealed 
               distinctive clusters for tumor and normal samples 
               (left PCA plot). Additionally, we also used six 
               phenotype_subtypes, batch and sex as factors showing 
               clustering of normal and tumor samples by 
               subtypes (right PCA plot)."
             ),
             column(2, )
           )),
  hr(),
  fluidRow(
    class = "text-center",
    column(
      6,
      add_busy_bar(),
      h4("Sample-wise PCA"),
      tags$img(src = "img/pca_label_batch-corr_b&w_pid_col.png",
               style = "width: 90%; height: auto;")
    ),
    column(
      6,
      h4("Subtype-wise PCA"),
      tags$img(src = "img/pca_label_batch-corr_subtypes_pid_font.png",
               style = "width: 90%; height: auto;")
    )
  ),
  br(),
  hr(),
  fluidRow(class = "text-center",
           column(
             12,
             h3("Differential Genes Expression Analysis"),
             tags$p(
               "List of differentially expressed genes (DEGs) for the 
               following two contrasts:"
             ),
             tags$p(style = "color:darkred;", "Click on the row in the table to display gene information and highlight gene in the volcano plot.")
           )),
  hr(),
  fluidRow(
    column(
      6,
      h4("All Samples: Tumor Vs Normal"),
      dt_ui("dds_all_deg"),
      br(),
      gene_info_ui("sel_gene_t_vs_n")
    ),
    column(
      6,
      h4("Tumor Samples: PTCPlusThy vs FTC"),
      dt_ui("dds_subtype_deg"),
      br(),
      gene_info_ui("sel_gene_PTC_vs_FTC")
    )
  ),
  hr(),
  fluidRow(column(
    6,
    h4("All Samples: Tumor Vs Normal"),
    volcano_ui("vol_aff_unaff")
  ),
  column(
    6,
    h4("Tumor Samples: PTCPlusThy vs FTC"),
    volcano_ui("vol_ptc_vs_ftc")
  )),
  br(),
  hr(),
  fluidRow(class = "text-center",
           column(
             12,
             h3("Enrichment Anlaysis")
           )),
  hr(),
  fluidRow(column(6,
                  enrichr_ui_mod("enrichr_t_vs_n")),
           column(6,
                  enrichr_ui_mod(
                    "enrichr_PTC_vs_FTC"
                  ))),
  br(),
  hr(),
  br()
)
