onco_plot <- fluidPage(
  # Page title
  fluidRow(class = "text-center",
           column(12,
  h3("Sample Variant Information")
  )
  ),
  hr(),
  fluidRow(
    column(11,
           variantFilterUI("variant_table_with_filters")
          ),
    column(1,
           br(),
           br(),
           br(),
           br(),
           tags$p('
                  "DITTO (inspired by pokemon) is an explainable Neural network tool that can make pathogenicity predictions for any type of small genetic variants and their predicted functional impact on transcript(s). DITTO score ranges from (0-1), where higher scores translates to the variant being likely pathogenic.
"'))
  ),
  br(),
  hr(),
  fluidRow(class = "text-center",
           column(2,),
           column(8,
  h3("Interactive Oncoplot"),
  tags$p("A comprehensive analysis using whole exome sequencing identified 152 somatic and germline variants across 110 genes. These genetic alterations, derived from both tumor and normal samples, span six distinct subtypes, as illustrated in the interactive oncoplot below. On the right side, the box plots display the gene expression levels, contrasting tumor samples with normal ones. Variant information table follows the oncoplot that also include DITTO score for each variant. For more details on DITTO, please refer here."),
  column(2,)
  )
  ),
  hr(),
  br(),
  fluidRow(
    column(8, 
          
           originalHeatmapOutput("ht", 
                                 width = 1550,
                                 height = 2000,
                                 title = "Interactive Oncoplot: Select area to zoom")
    ),
    column(4,
           subHeatmapOutput("ht", 
                            width = 750,
                            height = 950,
                            title = "Sub-heatmap for selected area.")
    )
  ),
  br(),
  hr()
  
)
