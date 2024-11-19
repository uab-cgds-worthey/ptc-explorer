geneSearch_page <- fluidPage(
  fluidRow(
    column(3,
           h5("Gene Dropdown here"),
           selectizeInput("gene_name", "Gene Names", 
                          choices = c("BRCA1"))
    ),
    column(6, 
           h5("Gene Annotation here"),
           p("Description, function, etc.")
    ),
    column(3,
           h5("Some other high level information")
    )
  ),
  br(),
  hr(),
  h4("Genomic Analysis"),
  hr(),
  br(),
  fluidRow(
    column(12,
           
    )
  ),
  br(),
  hr(),
  h4("DEG Analysis"),
  hr(),
  br(),
  fluidRow(
    column(12,
           
    )
  ),
  br(),
  hr(),
  h4("RNA-Fusion"),
  hr(),
  br(),
  fluidRow(
    column(12,
           
    )
  )
)

ditto_page <- fluidPage(
  fluidRow(
   h5("Variant Pathogenecity prediction by DITTO")
  ),
  br(),
  hr(),
  h4("DITTO scores and plot"),
  hr(),
  br(),
  fluidRow(
    column(12,
           
    )
  ),
  hr()
)

download_page <- fluidPage(
  # Page title
  fluidRow(class = "text-center",
    column(12,
           h3("Download options for dataset:"),
           br(),
           div(
             class = "text-center",
             a(href="alldata.zip", "All dataset zip", download=NA, target="_blank"),
             br(),
             a(href="alldata.rds", "All dataset RDS", download=NA, target="_blank")
           )
           )
  )
)


onco_plot <- fluidPage(
  # Page title
  h3("Interactive Oncoplot"),
  tags$p("A comprehensive analysis using whole exome sequencing identified 152 somatic and germline variants across 110 genes. These genetic alterations, derived from both tumor and normal samples, span six distinct subtypes, as illustrated in the interactive oncoplot below. On the right side, the box plots display the gene expression levels, contrasting tumor samples with normal ones. Variant information table follows the oncoplot that also include DITTO score for each variant. For more details on DITTO, please refer here."),
  fluidRow(
    column(8, 
           # plotOutput("oncoplot_main", height = "1400px")
           originalHeatmapOutput("ht", 
                                 width = 1100,
                                 height = 950,
                                 title = NULL)
    ),
    column(4,
           subHeatmapOutput("ht", 
                            width = 550,
                            height = 950,
                            title = NULL)
           )
  ),
  br(),
  hr(),
  fluidRow(
    h3("Sample Variant Information"),
    column(8, 
           #dtUI("sample_variant_df")
           reactableUI("sample_variant_df")
    )
  ),
  br(),
  hr()
)


rna_page <- fluidPage(
  # Page title
  #titlePanel('RNA-seq Analysis'),
  #hr(),
 
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
  # br(),
  # hr(),
  # h4("Enrichment Anlaysis using: gProfiler"),
  # fluidRow(
  #   column(6,
  #          gprofilerUI("go_t_vs_n")),
  #   column(6,
  #          gprofilerUI("go_PTC_vs_FTC")
  #          )
  # 
  # ),
  # br(),
  # hr(),
  # h4("Enrichment Anlaysis using: Enrichr databases"),
  # h3("Enrichment analysis using Enrichr databases"),
  # fluidRow(
  #   column(6,
  #          enrichrUI("enrichr_t_vs_n")),
  #   column(6,
  #          enrichrUI("enrichr_PTC_vs_FTC")
  #          )
  # ),
  br(),
  hr(),
  br()
)


rnaFusion_page <- fluidPage(
  h4("RNA-Fusion Analysis"),
  tags$p("Subtype-wise distribution of fusions detected using RNA-Seq within the tumor samples."),
  # fluidRow(column(
  #   3,
  #   plotOutput("rna_fusion_1",  height = "600px")
  # ),
  # column(
  #   9,
  #   plotOutput("rna_fusion_2",  height = "600px")
  # )),
  # br(),
  # hr(),
  fluidRow(column(
    12,
    #    plotOutput("rna_fusion_4",  height = "1200px")
    plotlyOutput("rna_fusion_4",  height = "1200px")
  )),
  hr(),
  br()
)



wes_page <- fluidPage(
  # Page title
  #  titlePanel('Whole Exome Sequencing Analysis'),
  #  hr(),
  
  # fluidRow(
  #   h3("Sample Variant Information"),
  #   column(8, 
  #          #dtUI("sample_variant_df")
  #          reactableUI("sample_variant_df")
  #   )
  # ),
  # br(),
  # hr(),
  # br(),
  # fluidRow(
  #   column(12, 
  #   )
  # ),
  tags$h3("Mutational Signature Analysis"),
  tags$p("A summary of the signatures identified in this study is reported below. For details about the specific single base substitution (SBS), click on the respective tabs on the right."),
  fluidRow(
    # column(4,
    #        tags$h3("Mutations in each sample"),
    #        tags$img(src = "img/mutational_sign_2.png", 
    #                 style = "width: 90%; height: auto;"
    #        )
    # ),
    # column(6,
    #        tags$h3("MSI levels in PTC tumors"),
    #        tags$img(src = "img/mutational_signature_4.png", 
    #                 style = "width: auto; height: 75%;"
    #        )
    # ),
    column(8,
          
           tabsetPanel(
             type = "tabs",
             tabPanel(
               title = "Mutations in each Signature",
               tags$img(src = "img/mutational_sign_2.png", 
                        style = "width: auto; height: 75%;"
               )
             ),
             tabPanel(
               title = "SBS Signature Image 1",
               tags$img(src = "img/mutational_sign_0.png", 
                        style = "width: auto; height: 75%;"
               )
             ),
             tabPanel(
               title = "SBS Signature Image 2",
               tags$img(src = "img/mutational_sign_1.png", 
                        style = "width: auto; height: 75%;"
               )
             )
             
           )
           # tags$h3("MSI levels in PTC tumors"),
           # tags$img(src = "img/mutational_signature_4.png", 
           #          style = "width: 90%; height: auto;"
           # )
    )
  ),
  hr(),
  br(),
  fluidRow(
    column(6,
           tags$h3("Tumor clonal evoluation"),
           tags$p("Clonal analysis of somatic variation identified signatures of mutational processes in tumors from participant 2, 17 and 18."),
           tags$img(src = "img/clonal_analysis.png",
                    style = "width: 90%; height: auto;"
           )
    ),
  # ),
  # hr(),
  # br(),
  column(6,
  tags$h3("Microsatellite instability (MSI) analysis"),
  tags$p("Subtype-wise distribution of MSI levels among the tumor samples."),
 # fluidRow(
    # column(12,
          # tags$h3("MSI levels in PTC tumors"),
           tags$img(src = "img/mutational_signature_4.png",
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  # fluidRow(
  #   tags$h3("SBS Signatures"),
  #   column(6,
  #          tags$img(src = "img/mutational_sign_0.png", 
  #                   style = "width: 90%; height: auto;"
  #          )
  #   ),
  #   column(6,
  #          tags$img(src = "img/mutational_sign_1.png", 
  #                   style = "width: 90%; height: auto;"
  #          )
  #   )
  # ),
  # br(),
  # hr(),
  # br(),
  
  br(),
  hr()
)

navbarPage(
     'Pediatric Thyroid Cancer Explorer',
      # tabPanel('About', home_page),
      tabPanel('By Gene', geneSearch_page),
     #  tabPanel('Variant Distribution', onco_plot),
        tabPanel('RNA-Seq', rna_page),
     #  tabPanel('RNA-Seq Fusions', rnaFusion_page),
     tabPanel('WES Additional Analysis', wes_page),
   #  tabPanel('DITTO', ditto_page),
     tabPanel('Download', download_page),
     tabPanel('User Metrics', userMetrics_page)
     #tabPanel('Docs', about_page),
)
