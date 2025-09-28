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
                       tags$p(style = "color:darkred;",
                              "Filter the RNA-fusions by:"),
                       selectizeInput(
                         ns("gene_var"),
                         "Gene *",
                         choices = c("All", sort(union(rna_fusion_df$geneA,
                                                       rna_fusion_df$geneB))),
                         selected = "All",
                         width = "100%",
                         multiple = TRUE
                       ),
                       pickerInput(
                         ns("pheno_var"),
                         "Subtypes",
                         choices = c(unique(fusion_table$Phenotype_Subtype)),
                         selected = unique(fusion_table$Phenotype_Subtype),
                         options = pickerOptions(container = "body",
                                                 actionsBox = TRUE),
                         width = "100%",
                         multiple = TRUE
                       ),
                       pickerInput(
                         ns("known_var"),
                         "Known Fusion Status",
                         choices = c("Yes", "No"),
                         selected = c("Yes", "No"),
                         options = pickerOptions(container = "body",
                                                 actionsBox = TRUE),
                         width = "100%",
                         multiple = TRUE
                       ),
                       pickerInput(
                         ns("classification_var"),
                         "Classification",
                         choices = unique(fusion_table$Classification),
                         selected = unique(fusion_table$Classification),
                         options = pickerOptions(container = "body",
                                                 actionsBox = TRUE),
                         width = "100%",
                         multiple = TRUE
                       ),
                       br(),
                       tags$p(style = "font-size: 85% !important; color:grey;",
                              "* To filter by 'Gene' delete 'All'
                            and select one or more options."),
                     )
                   )
                 })
                 filtered_sample_fusions <- reactiveVal(fusion_table)
                 observeEvent(
                   c(
                     input$pheno_var,
                     input$classification_var,
                     input$gene_var,
                     input$known_var
                   ),
                   {
                     temp_var_df <-  fusion_table
                     temp_var_df <-
                       temp_var_df[temp_var_df$Known %in%
                                     input$known_var, ]

                     temp_var_df <-
                       temp_var_df[temp_var_df$Classification %in%
                                     input$classification_var, ]
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
                                          temp_var_df <- temp_var_df[, c(4, 5, 2, 13, 14, 1, 3, 6:12)]
                     filtered_sample_fusions(temp_var_df)
                   }
                 )
                 reactable_server(
                   "sample_fusion_df",
                   filtered_sample_fusions,
                   defaultColDef = colDef(na = "NA", align = "left"),
                   columns = list(
                     Phenotype_Subtype = colDef(
                       style = function(value) {
                         color <- if (value == "FA") {
                           "#E31A1C"
                         } else if (value == "FTC") {
                           "#FDBF6F"
                         } else if (value == "NIFTP") {
                           "#FF7F00"
                         } else if (value == "PTC") {
                           "#CAB2D6"
                         } else if (value == "PTCplusTHY") {
                           "#6A3D9A"
                         } else if (value == "THY") {
                           "#FFFF99"
                         }
                         fontcolor <- if (value == "FA") {
                           "white"
                         } else if (value == "FTC") {
                           "#000"
                         } else if (value == "NIFTP") {
                           "#000"
                         } else if (value == "PTC") {
                           "#000"
                         } else if (value == "PTCplusTHY") {
                           "white"
                         } else if (value == "THY") {
                           "#000"
                         }
                         list(fontWeight = 700,
                              background = color,
                              color = fontcolor)
                       }
                     ),
                     Known = colDef(
                       style = function(value) {
                         color <- if (value == "Yes") {
                           "darkgrey"
                         } else if (value == "No") {
                           "darkred"
                         }
                         list(fontWeight = 700, color = color)
                       }
                     ),
                     Classification = colDef(
                             style = function(value) {
                               color <- if (value == "Low") {
                                 "#e0e1dd"
                               } else if (value == "Moderate") {
                                 "#fcbf49"
                               }  else if (value == "High") {
                                 "#a7c957"
                               }
                               list(fontWeight = 700, background = color)
                             }
                           )
                   ),
                   defaultPageSize = 100,
                   reactive_tbl = TRUE,
                   bordered = TRUE
                 )

                 #   "sample_fusion_df",
                 #   filtered_sample_fusions,
                 #   bordered = TRUE,
                 #   columns = list(
                 #     `DITTO Score` = colDef(
                 #       style = function(value) {
                 #           (value - min(fusion_table$`DITTO Score`)) /
                 #           (max(fusion_table$`DITTO Score`) -
                 #       }
                 #     ),
                 #     `Germline Class` = colDef(
                 #       style = function(value) {
                 #           "#cc444b"
                 #         } else if (value == "LP") {
                 #           "#df7373"
                 #         }  else if (value == "LB") {
                 #           "#008000"
                 #         } else if (value == "VUS") {
                 #           "#e4b1ab"
                 #         }
                 #       }
                 #     )
                 #   )
                 # )
               })
}

