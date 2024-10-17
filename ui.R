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

navbarPage(
     'Pediatric Thyroid Cancer Explorer',
     tabPanel('Home', home_page),
     tabPanel('Oncoplot', onco_plot),
     tabPanel('DEGs', rna_page),
     tabPanel('RNA Fusions', rnaFusion_page),
     tabPanel('Genomic Analysis', wes_page),
     tabPanel('Download', download_page),
     # tabPanel('User Metrics', userMetrics_page),
     tabPanel('About', about_page),
)
