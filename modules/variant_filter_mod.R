variant_filter_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(column(2, br(), br(), uiOutput(
    ns("variant_filters")
  )), column(10, reactable_ui(
    ns("sample_variant_df")
  ))))
}

variant_filter_server <- function(id, variant_table) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 output$variant_filters <- renderUI({
                   req(variant_table)
                   fluidRow(
                     column(
                       12,
                       tags$p(style = "color:darkred;",
                              "Filter the variants by:"),
                       selectizeInput(
                         ns("gene_var"),
                         "Gene *",
                         choices = c("All", unique(variant_table$Gene)),
                         selected = "All",
                         width = "100%",
                         multiple = TRUE
                       ),
                       selectizeInput(
                         ns("chr_var"),
                         "Chromosome *",
                         choices = c("All", substr(
                           unique(variant_table$Chromosome), 4, 5
                         )),
                         selected = "All",
                         width = "100%",
                         multiple = TRUE
                       ),
                     # ),
                     # column(
                     #   6,
                       pickerInput(
                         ns("pheno_var"),
                         "Phenotype",
                         choices = c(unique(variant_table$Phenotype)),
                         selected =  c(unique(variant_table$Phenotype)),
                         options = pickerOptions(container = "body", 
                                                 actionsBox = TRUE),
                         width = "100%",
                         multiple = TRUE
                       ),
                       pickerInput(
                         ns("type_var"),
                         "Variant Type",
                         choices = c(unique(variant_table$`Variant Type`)),
                         selected = c(unique(variant_table$`Variant Type`)),
                         options = pickerOptions(container = "body", 
                                                 actionsBox = TRUE),
                         width = "100%",
                         multiple = TRUE
                       ),
                       pickerInput(
                         ns("germ_var"),
                         "Germline Class",
                         choices = c(unique(variant_table$`Germline Class`)),
                         selected = c(unique(variant_table$`Germline Class`)),
                         options = pickerOptions(container = "body", 
                                                 actionsBox = TRUE),
                         width = "100%",
                         multiple = TRUE
                       ),
                     br(),
                     tags$p(style = "font-size: 85% !important; color:grey;",
                            "* To filter by 'Gene' and 'Chromosome' delete 'All' 
                            and select one or more options."),
                     tags$p(style = "font-size: 80% !important; color:grey;",
                     "DITTO Score: DITTO (inspired by pokemon) is an explainable Neural network tool
      that can make pathogenicity predictions for any type of small genetic 
      variants and their predicted functional impact on transcript(s). 
      DITTO score ranges from (0-1), where higher scores translates to the
      variant being likely pathogenic. For more details on DITTO, please refer here."
                     )
                     )
                   )
                 })
                 filtered_sample_variants <-
                   reactiveVal(variant_table)
                 observeEvent(
                   c(
                     input$pheno_var,
                     input$type_var,
                     input$germ_var,
                     input$chr_var,
                     input$gene_var,
                     input$ditto_var
                   ),
                   {
                     temp_var_df <-  variant_table
                     temp_var_df <-
                       temp_var_df[temp_var_df$Phenotype %in%
                                   input$pheno_var, ]
                     temp_var_df <-
                       temp_var_df[temp_var_df$`Variant Type` %in%
                                   input$type_var, ]
                     temp_var_df <-
                       temp_var_df[temp_var_df$`Germline Class` %in%
                                   input$germ_var, ]
                     if (!("All" %in% input$chr_var)) {
                       temp_var_df <-
                         temp_var_df[temp_var_df$Chromosome %in%
                                     paste0("chr", input$chr_var), ]
                     }
                     if (!("All" %in% input$gene_var)) {
                       temp_var_df <- temp_var_df[temp_var_df$Gene %in%
                                                    input$gene_var, ]
                     }
                     filtered_sample_variants(temp_var_df)
                   }
                 )
                 ditto_pal <- function(x, na_color = "transparent") {
                 #   cols <- grDevices::rgb(
                 #     grDevices::colorRamp(
                 #       c("#e4b1ab", "#cc444b")) (pmin(pmax(x,0),1)),
                 #     maxColorValue = 255
                 #     )
                 #   cols[is.na(x)] <- na_color
                 #   cols
                 if(is.na(x)) x <- 0
                   rgb(colorRamp(c("#e4b1ab", "#cc444b"))(x),
                       maxColorValue = 255)
                 }
                 reactable_server(
                   "sample_variant_df",
                   filtered_sample_variants,
                   bordered = TRUE,
                   defaultColDef = colDef(na = "NA", minWidth = 95,
                                          align = "left"),
                   defaultPageSize = 15,
                   columns = list(
                     `Participant id` = colDef(
                       minWidth = 85,
                     ),
                     # Phenotype  = colDef(
                     #   style = function(value) {
                     #     color <- if (value == "Tumor") {
                     #       "grey40"
                     #     } else if (value == "Normal") {
                     #       "grey90"
                     #     }
                     #     list(background = color,
                     #          color = c("white","black"))
                     #   }
                     # ),
                     `DITTO Score` = colDef(
                       minWidth = 85,
                       style = function(value) {
                         normalized <-
                           (value - min(variant_table$`DITTO Score`)) /
                           (max(variant_table$`DITTO Score`) -
                            min(variant_table$`DITTO Score`))
                         #color <- ditto_pal(normalized)
                         #list(fontWeight = 700), color = color)
                       }
                     ),
                     `Germline Class` = colDef(
                       style = function(value) {
                         color <- if (value == "P") {
                           "#cc444b"
                         } else if (value == "LP") {
                           "#df7373"
                         }  else if (value == "LB") {
                           "#008000"
                         } else if (value == "VUS") {
                           "#e4b1ab"
                         }
                         list(fontWeight = 700, color = color)
                       }
                     )
                   )
                 )
               })
}
