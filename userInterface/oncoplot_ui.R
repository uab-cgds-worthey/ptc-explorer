onco_plot <- fluidPage(
  # Page title
  h3("Sample Variant Information"),
  hr(),
  fluidRow(
    column(3,
           br(),
           br(),
           uiOutput("variant_filters")
           
    ),
    column(8, 
           #dtUI("sample_variant_df")
           reactableUI("sample_variant_df")
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
  hr()
  
)
