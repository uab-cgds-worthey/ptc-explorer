rna_downstream_page <- fluidPage(
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
               style = "width: 90%; height: auto;"),
      br(),
      tags$p(
        style = "font-style: italic; color: #666; font-size: 14px; margin-top: 10px;",
        "Static PCA plot image showing tumor vs normal sample clustering"
      )
    ),
    column(
      6,
      h4("Subtype-wise PCA"),
      tags$img(src = "img/pca_label_batch-corr_subtypes_pid_font.png",
               style = "width: 90%; height: auto;"),
      br(),
      tags$p(
        style = "font-style: italic; color: #666; font-size: 14px; margin-top: 10px;",
        "Static PCA plot image showing subtype-wise sample clustering"
      )
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
  
  # Analysis type headers with colored backgrounds
  fluidRow(
    column(
      6,
      div(
        style = "background-color: #e3f2fd; border: 2px solid #1976d2; border-radius: 8px; padding: 15px; margin-bottom: 20px; text-align: center;",
        h4("All Samples: Tumor vs Normal", style = "color: #1976d2; margin: 0; font-weight: bold;"),
        p("Comparison across all samples", style = "color: #1565c0; margin: 5px 0 0 0; font-size: 14px;")
      )
    ),
    column(
      6,
      div(
        style = "background-color: #f3e5f5; border: 2px solid #7b1fa2; border-radius: 8px; padding: 15px; margin-bottom: 20px; text-align: center;",
        h4("Tumor Samples: PTCPlusThy vs FTC", style = "color: #7b1fa2; margin: 0; font-weight: bold;"),
        p("Subtype comparison within tumors", style = "color: #6a1b9a; margin: 5px 0 0 0; font-size: 14px;")
      )
    )
  ),
  
  # DEG Tables Section
  fluidRow(
    column(
      6,
      div(
        class = "analysis-section",
        style = "border-left: 4px solid #1976d2; padding-left: 15px;",
        h5("DEG Table", style = "color: #1976d2; font-weight: bold;"),
        dt_ui("dds_all_deg"),
        br(),
        gene_info_ui("sel_gene_t_vs_n")
      )
    ),
    column(
      6,
      div(
        class = "analysis-section",
        style = "border-left: 4px solid #7b1fa2; padding-left: 15px;",
        h5("DEG Table", style = "color: #7b1fa2; font-weight: bold;"),
        dt_ui("dds_subtype_deg"),
        br(),
        gene_info_ui("sel_gene_PTC_vs_FTC")
      )
    )
  ),
  hr(),
  
  # Volcano Plots Section
  fluidRow(
    column(
      6,
      div(
        class = "analysis-section",
        style = "border-left: 4px solid #1976d2; padding-left: 15px;",
        h5("Volcano Plot", style = "color: #1976d2; font-weight: bold;"),
        volcano_ui("vol_aff_unaff")
      )
    ),
    column(
      6,
      div(
        class = "analysis-section",
        style = "border-left: 4px solid #7b1fa2; padding-left: 15px;",
        h5("Volcano Plot", style = "color: #7b1fa2; font-weight: bold;"),
        volcano_ui("vol_ptc_vs_ftc")
      )
    )
  ),
  br(),
  hr(),
  fluidRow(class = "text-center",
           column(
             12,
             h3("Enrichment Analysis")
           )),
  hr(),
  
  # Enrichment Analysis Section
  fluidRow(
    column(
      6,
      div(
        class = "analysis-section",
        style = "border-left: 4px solid #1976d2; padding-left: 15px;",
        h5("Enrichment: Tumor vs Normal", style = "color: #1976d2; font-weight: bold;"),
        enrichr_ui("enrichr_t_vs_n")
      )
    ),
    column(
      6,
      div(
        class = "analysis-section",
        style = "border-left: 4px solid #7b1fa2; padding-left: 15px;",
        h5("Enrichment: PTCPlusThy vs FTC", style = "color: #7b1fa2; font-weight: bold;"),
        enrichr_ui("enrichr_PTC_vs_FTC")
      )
    )
  ),
  br(),
  hr(),
  br()
)

