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
  fluidRow(
    h3("Differentially Expressed Genes"),
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
  h3("PCA plots of samples in contrast"),
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
           gprofilerUI("go_PTC_vs_FTC")
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
navbarPage(
     'Pediatric Thyroid Cancer Explorer',
#     tabPanel('Home', home_page),
    # tabPanel('By Gene', geneSearch_page),
     # tabPanel('Oncoplot', onco_plot),
     tabPanel('DEGs', rna_page),
     # tabPanel('RNA Fusions', rnaFusion_page),
     tabPanel('Genomic Analysis', wes_page),
     tabPanel('DITTO', ditto_page),
     tabPanel('Download', download_page),
     # tabPanel('User Metrics', userMetrics_page),
     tabPanel('About', about_page),
)
