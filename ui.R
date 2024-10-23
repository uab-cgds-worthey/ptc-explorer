geneSearch_page <- fluidPage(
  fluidRow(
    column(3,
           h5("Gene Dropdown here")
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



onco_plot <- fluidPage(
  # Page title
  h3("Interactive Oncoplot"),
  fluidRow(
    column(8, 
           # plotOutput("oncoplot_main", height = "1400px")
           originalHeatmapOutput("ht", 
                                 width = 1600,
                                 height = 950,
                                 title = NULL)
    ),
    column(4,
           subHeatmapOutput("ht", 
                            width = 750,
                            height = 950,
                            title = NULL)
           )
  ),
  br(),
  hr()
)


rna_page <- fluidPage(
  # Page title
  #titlePanel('RNA-seq Analysis'),
  #hr(),
 
  h4("PCA plots of samples in contrast"),
  fluidRow(
    column(6, add_busy_bar(),
           h4('All Samples: Tumor Vs Normal'),
           plotOutput("pca_cell_1")
    ),
    column(6,
           h4('Tumor Samples: PTCPlusThy vs FTC'),
           plotOutput("pca_cell_2")
    )
  ),
  br(),
  hr(),
  fluidRow(
    h4("Differentially Expressed Genes"),
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
  br(),
  hr(),
  fluidRow(
    h5("DEG Analysis"),
    column(6, 
           volcanoUI("vol_aff_unaff")
    ),
    column(6, 
           volcanoUI("vol_ptc_vs_ftc"))
  ),
  br(),
  hr(),
  h3("Go Profiler Enrichment Anlaysis"),
  fluidRow(
    column(6,
           gprofilerUI("go_t_vs_n")),
    column(6,
         #  gprofilerUI("go_PTC_vs_FTC")
           )
 
  ),
  br(),
  hr(),
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

wes_page <- fluidPage(
  # Page title
  #  titlePanel('Whole Exome Sequencing Analysis'),
  #  hr(),
  fluidRow(
    h3("Sample Variant Information"),
    column(6, 
           dtUI("sample_variant_df")
    )
  ),
  br(),
  hr(),
  br(),
  fluidRow(
    column(12, tags$h3("Mutational Signature Analysis")
    )
  ),
  fluidRow(
    column(6,
           tags$h3("Mutations in each sample"),
           tags$img(src = "img/mutational_sign_2.png", 
                    style = "width: 90%; height: auto;"
           )
    ),
    column(6,
           tags$h3("MSI levels in PTC tumors"),
           tags$img(src = "img/mutational_signature_4.png", 
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  fluidRow(
    tags$h3("SBS Signatures"),
    column(6,
           tags$img(src = "img/mutational_sign_0.png", 
                    style = "width: 90%; height: auto;"
           )
    ),
    column(6,
           tags$img(src = "img/mutational_sign_1.png", 
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  br(),
  hr(),
  br(),
  fluidRow(
    tags$h3("Clonal Analysis"),
    column(12,
           tags$img(src = "img/clonal_analysis_1.png", 
                    style = "width: 90%; height: auto;"
           )
    )
  ),
  br(),
  hr()
)

navbarPage(
     'Pediatric Thyroid Cancer Explorer',
#     tabPanel('Home', home_page),
    # tabPanel('By Gene', geneSearch_page),
     # tabPanel('Oncoplot', onco_plot),
   #  tabPanel('DEGs', rna_page),
     # tabPanel('RNA Fusions', rnaFusion_page),
     tabPanel('Genomic Analysis', wes_page),
     tabPanel('DITTO', ditto_page),
     tabPanel('Download', download_page),
     # tabPanel('User Metrics', userMetrics_page),
     tabPanel('About', about_page),
)
