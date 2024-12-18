variantFilterUI <- function(id) {
  ns <- NS(id)
  tagList(
  fluidRow(
    column(4,
           br(),
           br(),
           uiOutput(ns("variant_filters"))
           
    ),
    column(8, 
           reactableUI(ns("sample_variant_df"))
    ),
  )
  )
}

variantFilterServer <- function(id, variant_table) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ns <- session$ns
      output$variant_filters <- renderUI({
        req(variant_table)
        
        fluidRow(
          column(6,
                 selectizeInput(
                   ns("gene_var"),
                   "Gene",
                   choices = c("All", unique(variant_table$Gene)),
                   selected = "All",
                   multiple = TRUE
                 ),
                 selectizeInput(
                   ns("chr_var"),
                   "Chromosome",
                   choices = c(substr(
                     unique(variant_table$Chromosome), 4, 5
                   )),
                   selected = c(substr(
                     unique(variant_table$Chromosome), 4, 5
                   )),
                   multiple = TRUE
                 )
          ),
          column(
            6,
            pickerInput(
              ns("pheno_var"),
              "Phenotype",
              choices = c(unique(variant_table$Phenotype)),
              selected =  c(unique(variant_table$Phenotype)),
              multiple = TRUE
            ),
            pickerInput(
              ns("type_var"),
              "Variant Type",
              choices = c(unique(variant_table$`Variant Type`)),
              selected = c(unique(variant_table$`Variant Type`)),
              multiple = TRUE
            ),
            pickerInput(
              ns("germ_var"),
              "Germline Class",
              choices = c(unique(variant_table$`Germline Class`)),
              selected = c(unique(variant_table$`Germline Class`)),
              multiple = TRUE
            )#,
            # pickerInput("ditto_var",
            #                "DITTO Score",
            #                choices = c("More Pathogenic: > 0.88",
            #                            "More Benign: < 0.20"
            #                            ),
            #                selected = c("More Pathogenic: > 0.88",
            #                             "More Benign: < 0.20"
            #                ),
            #                multiple = TRUE
            # )
            #
          )
          
        )
      })
      
      
      filtered_sample_variants <- reactiveVal(variant_table)
      
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
     
          temp_var_df <- temp_var_df[temp_var_df$Phenotype %in% input$pheno_var, ]
          temp_var_df <- temp_var_df[temp_var_df$`Variant Type` %in% input$type_var, ]
          temp_var_df <- temp_var_df[temp_var_df$`Germline Class` %in% input$germ_var, ]
          
          
          temp_var_df <- temp_var_df[temp_var_df$Chromosome %in% paste0("chr", input$chr_var), ]
          
 
          if (length(input$gene_var) > 1 &&
              !("All" %in% input$gene_var)) {
            temp_var_df <- temp_var_df[temp_var_df$Gene %in% input$gene_var, ]
            
          }
          
          # print(input$ditto_var)
          #
          # if(!("More  Benign: < 0.20" %in% input$ditto_var)){
          #   temp_var_df <- temp_var_df[temp_var_df$DITTO.Score >= 0.88, ]
          # }else if(!("More Pathogenic: > 0.88" %in% input$ditto_var)){
          #   temp_var_df <- temp_var_df[temp_var_df$DITTO.Score <= 0.20, ]
          #
          # }
  
          # print(head(temp_var_df))
          # temp_var_df <- temp_var_df[temp_var_df$Phenotype %in% input$pheno_var,  ]
          
          filtered_sample_variants(temp_var_df)
          
        }
      )
      
      ditto_pal <- function(x)
        rgb(colorRamp(c("#e4b1ab", "#cc444b"))(x), maxColorValue = 255)
      
      reactableServer(
        "sample_variant_df",
        filtered_sample_variants,
        #groupBy = "Gene",
        #  fullWidth = FALSE,
        bordered = TRUE,
        columns = list(
          `DITTO Score` = colDef(
            style = function(value) {
              normalized <- (value - min(variant_table$`DITTO Score`)) / (max(variant_table$`DITTO Score`) - min(variant_table$`DITTO Score`))
              color <- ditto_pal(normalized)
              list(fontWeight = 700, color = color)
            }
          )
          ,
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
      
      
    }
  )
}