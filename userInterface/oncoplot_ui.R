onco_plot <- fluidPage(
  # Page title
  fluidRow(class = "text-center",
           column(12,
                  h3("Variants Table"),
                  tags$p(style = "color:darkred;",
                         "Variant information table is visualized using the oncoplot 
                         shown below.")
                  )
           ), 
  hr(),
  fluidRow(
    column(12,
           variant_filter_ui("variant_table_with_filters"))#,
    # column(
    #   1,
    #   br(),
    #   br(),
    #   br(),
    #   br(),
    #  
    # )
  ),
  br(),
  hr(),
  fluidRow(class = "text-center",
           column(2, ),
           column(
             8,
             h3("Interactive Oncoplot"),
             tags$p(style = "color:darkred;",
               "A comprehensive analysis using whole exome sequencing 
               identified 132 somatic and germline variants across 110 genes. 
               These genetic alterations, derived from both tumor and normal 
               samples, span six distinct subtypes, as illustrated in the 
               interactive oncoplot below. On the right side, the box plots 
               display the gene expression levels, contrasting tumor samples 
               with normal ones."
             ),
             column(2, )
           )),
  hr(),
  br(),
  fluidRow(
    id ="high_res",
    column(
      8,
      originalHeatmapOutput(
        "ht",
        width = 1150,
        height = 2150,
        title = "Interactive Oncoplot: Select area to zoom"
      )
    ),
    column(
      4,
      subHeatmapOutput(
        "ht",
        width = 600,
        height = 850,
        title = "Sub-heatmap for selected area."
      )
    )
  ),
  fluidRow(
    id ="low_res",
    column(
      12,
      h2("Your screen resolution is too small"),
      p("Please use a larger screen resolution to view this section.")
    )
  ),
  br(),
  hr()
)
