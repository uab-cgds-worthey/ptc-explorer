fusion_filter_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(column(2, br(), br(), uiOutput(
    ns("fusion_filters")
  )), column(10, reactable_ui(
    ns("sample_fusion_df")
  ))))
}

fusion_filter_server <- function(id, fusion_table) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 output$fusion_filters <- renderUI({
                   req(fusion_table)
                   fluidRow(
                     column(
                       12,
                       selectizeInput(
                         ns("gene_var"),
                         "Genes",
                         choices = c("All", sort(union(rna_fusion_df$geneA,
                                                       rna_fusion_df$geneB))),
                         selected = "All",
                         multiple = TRUE
                       ),
                       selectizeInput(
                         ns("pheno_var"),
                         "Subtypes",
                         choices = c("All", 
                                     unique(fusion_table$Phenotype_Subtype)),
                         selected = "All",
                         multiple = TRUE
                       ),
                       selectizeInput(
                         ns("known_var"),
                         "Known Fusion Status",
                         choices = c("Yes","No"),
                         selected = c("Yes","No"),
                         multiple = TRUE
                       )
                     ),
                 #     column(
                 #       6,
                 #       pickerInput(
                 #         ns("pheno_var"),
                 #         "Phenotype",
                 #         choices = c(unique(fusion_table$Phenotype)),
                 #         selected =  c(unique(fusion_table$Phenotype)),
                 #         multiple = TRUE
                 #       ),
                 #       pickerInput(
                 #         ns("type_var"),
                 #         "fusion Type",
                 #         choices = c(unique(fusion_table$`fusion Type`)),
                 #         selected = c(unique(fusion_table$`fusion Type`)),
                 #         multiple = TRUE
                 #       ),
                 #       pickerInput(
                 #         ns("germ_var"),
                 #         "Germline Class",
                 #         choices = c(unique(fusion_table$`Germline Class`)),
                 #         selected = c(unique(fusion_table$`Germline Class`)),
                 #         multiple = TRUE
                 #       )
                 #     )
                   )
                 })
                 filtered_sample_fusions <- reactiveVal(fusion_table)
                 observeEvent(
                   c(
                     input$pheno_var,
                     # input$type_var,
                     # input$germ_var,
                     # input$chr_var,
                     input$gene_var,
                     input$known_var
                   ),
                   {
                     # print(input$pheno_var)
                     print(nrow(fusion_table))
                     temp_var_df <-  fusion_table
                     temp_var_df <-
                       temp_var_df[temp_var_df$Known_Fusion %in%
                                     input$known_var, ]
                 #     temp_var_df <-
                 #       temp_var_df[temp_var_df$`fusion Type` %in%
                 #                     input$type_var, ]
                 #     temp_var_df <-
                 #       temp_var_df[temp_var_df$`Germline Class` %in%
                 #                     input$germ_var, ]
                     if (!("All" %in% input$pheno_var)) {
                       temp_var_df <-
                         temp_var_df[temp_var_df$Phenotype_Subtype %in% 
                                       input$pheno_var, ]
                     }
                     if (!("All" %in% input$gene_var)) {
                       temp_var_df <- temp_var_df[temp_var_df$geneA %in%
                                                    input$gene_var |
                                                    temp_var_df$geneB %in%
                                                    input$gene_var, ]
                     }
                     print(nrow(temp_var_df))
                     filtered_sample_fusions(temp_var_df)
                   }
                 )
                 # ditto_pal <- function(x) {
                 #   rgb(colorRamp(c("#e4b1ab", "#cc444b"))(x),
                 #       maxColorValue = 255)
                 # }
                 reactable_server(
                   "sample_fusion_df",
                   filtered_sample_fusions, #[, c(1, 2, 6, 7, 4, 5)],
                   defaultColDef = colDef(na = "NA"),
                   defaultPageSize = 100,
                   reactive_tbl = TRUE,
                   bordered = TRUE
                 )
                 
                 # reactable_server(
                 #   "sample_fusion_df",
                 #   filtered_sample_fusions,
                 #   bordered = TRUE,
                 #   columns = list(
                 #     `DITTO Score` = colDef(
                 #       style = function(value) {
                 #         normalized <-
                 #           (value - min(fusion_table$`DITTO Score`)) /
                 #           (max(fusion_table$`DITTO Score`) -
                 #              min(fusion_table$`DITTO Score`))
                 #         color <- ditto_pal(normalized)
                 #         list(fontWeight = 700, color = color)
                 #       }
                 #     ),
                 #     `Germline Class` = colDef(
                 #       style = function(value) {
                 #         color <- if (value == "P") {
                 #           "#cc444b"
                 #         } else if (value == "LP") {
                 #           "#df7373"
                 #         }  else if (value == "LB") {
                 #           "#008000"
                 #         } else if (value == "VUS") {
                 #           "#e4b1ab"
                 #         }
                 #         list(fontWeight = 700, color = color)
                 #       }
                 #     )
                 #   )
                 # )
               })
}
