rna_page <- fluidPage(
# Page title
#titlePanel('RNA-seq Analysis'),
#hr(),
fluidRow(
  h3("Differentially Expressed Genes"),
  column(6, 
         h4('All Samples: Tumor Vs Normal'),
         dtUI("dds_all_deg")
         ),
  column(6, 
         h4('Tumor Samples: PTCPlusThy vs FTC'),
         dtUI("dds_subtype_deg")
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
          h2('Column size 3'),
          volcanoUI("vol_aff_unaff")
          ),
   column(6,h2('Column size 6'))
 ),
br(),
hr(),
br()
)
