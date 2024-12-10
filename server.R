# Shiny Server
function(input, output, session) {
  
  #### Home tab/page
  metaPlotsServer("sample_meta_stats", sample_meta, meta_fact_cols, meta_num_cols)
  reactableServer("sample_meta_df", sample_meta_display, defaultColDef = colDef(
    na = "NA"), defaultPageSize = 25, reactive_tbl = FALSE,  bordered = TRUE)

  #### By gene search page
  geneSearchServer("geneSearch_main", geneList = all_genes_main,
                   var_table = sample_variants, 
                   deg_t_vs_n = res.T_vs_N,
                   deg_ptc_vs_ftc = res.PTC_vs_FTC,
                   fusion_table = rna_fusion_df)
  
  #### Oncoplot and sample variant tab
  output$variant_filters <- renderUI({
    req(sample_variants)
    
    fluidRow(
      column(6,
             selectizeInput(
               "gene_var",
               "Gene",
               choices = c("All", unique(sample_variants$Gene)),
               selected = "All",
               multiple = TRUE
             ),
             selectizeInput(
               "chr_var",
               "Chromosome",
               choices = c(substr(
                 unique(sample_variants$Chromosome), 4, 5
               )),
               selected = c(substr(
                 unique(sample_variants$Chromosome), 4, 5
               )),
               multiple = TRUE
             )
      ),
      column(
        6,
        pickerInput(
          "pheno_var",
          "Phenotype",
          choices = c(unique(sample_variants$Phenotype)),
          selected =  c(unique(sample_variants$Phenotype)),
          multiple = TRUE
        ),
        pickerInput(
          "type_var",
          "Variant Type",
          choices = c(unique(sample_variants$`Variant Type`)),
          selected = c(unique(sample_variants$`Variant Type`)),
          multiple = TRUE
        ),
        pickerInput(
          "germ_var",
          "Germline Class",
          choices = c(unique(sample_variants$`Germline Class`)),
          selected = c(unique(sample_variants$`Germline Class`)),
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
  
  
  filtered_sample_variants <- reactiveVal(sample_variants)
  
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
      temp_var_df <- sample_variants
      
      colnames(sample_variants)
      
      temp_var_df <- temp_var_df[temp_var_df$Phenotype %in% input$pheno_var, ]
      temp_var_df <- temp_var_df[temp_var_df$`Variant Type` %in% input$type_var, ]
      temp_var_df <- temp_var_df[temp_var_df$`Germline Class` %in% input$germ_var, ]
      
      
      temp_var_df <- temp_var_df[temp_var_df$Chromosome %in% paste0("chr", input$chr_var) , ]
      
      # print(length(input$gene_var))
      
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
          normalized <- (value - min(sample_variants$`DITTO Score`)) / (max(sample_variants$`DITTO Score`) - min(sample_variants$`DITTO Score`))
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
  
  
  
  
  
  
  #### RNA-seq tab
  
  byGene_deg <- dtServer("dds_all_deg", clean_sig_df(res.T_vs_N), returnRow = TRUE)
  
  
  
  makeInteractiveComplexHeatmap(input, output, session, oncoplot_rds, "ht")
  
  
 
  
  res.t_vs_n.sel <- dtServer("dds_all_deg",
                             clean_sig_df(res.T_vs_N, renameCols = TRUE),
                             returnRow = TRUE)
  res.PTC_vs_FTC.sel <- dtServer("dds_subtype_deg",
                                 clean_sig_df(res.PTC_vs_FTC, renameCols = TRUE),
                                 returnRow = TRUE)
  
  gene_infoServer("sel_gene_t_vs_n",
                  res.t_vs_n.sel,
                  clean_sig_df(res.T_vs_N),
                  2)
  gene_infoServer("sel_gene_PTC_vs_FTC",
                  res.PTC_vs_FTC.sel,
                  clean_sig_df(res.PTC_vs_FTC),
                  2)
  
  volcanoServer(
    "vol_aff_unaff",
    res.T_vs_N,
    "Affected vs Unaffected Samples",
    clean_sig_df(res.T_vs_N),
    res.t_vs_n.sel,
    2
  )
  volcanoServer(
    "vol_ptc_vs_ftc",
    res.PTC_vs_FTC,
    "Tumor Samples in PTCPlusThy vs FTC",
    clean_sig_df(res.PTC_vs_FTC),
    res.PTC_vs_FTC.sel,
    2
  )
  
  
  gprofilerServer("go_t_vs_n", gostres_T_vs_N, input_gostres = TRUE)
  gprofilerServer("go_PTC_vs_FTC", gostres_PTC_vs_FTC, input_gostres = TRUE)
  
  enrichrServer("enrichr_t_vs_n",enrichr_T_vs_N, enrichr_dbs, precalculate = TRUE)
  enrichrServer("enrichr_PTC_vs_FTC",enrichr_PTC_vs_FTC, enrichr_dbs, precalculate = TRUE)
  
  
  #### RNA-fusion tab
  
  output$rna_fusion_4 <- renderPlotly({
    p <- ggplot(rna_fusion_df, aes(x = Participant_id, y = Gene_Fusion)) +
      geom_point(aes(color = Phenotype_Subtype), size = 4) +
      labs(title = "Gene Fusions by Participant, Grouped by Phenotype Subtype", x = "Participant ID", y = "Gene Fusion") +
      scale_color_brewer(palette = "Set2") +  # Color based on phenotype subtype
      theme_minimal() +
      theme(
        axis.text.x = element_text(
          angle = 45,
          hjust = 1,
          size = 18
        ),
        axis.text.y = element_text(size = 14),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16)
      )
    
    ggplotly(p)
    
  })
  
  #### Genomics Analysis / WES page
  
}
