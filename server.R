# Shiny Server
function(input, output, session) {
  clean_sig_df <- function(sig_df,
                           input_res = FALSE,
                           addRownames = FALSE,
                           renameCols = FALSE,
                           gene = NULL) {
    # print("Entering clean_sig_df")
    # print(nrow(sig_df))
    sig_df <- sig_df[!is.na(sig_df$padj), ]
    
    sig_df$pvalue <- signif(sig_df$pvalue, digits = 3)
    sig_df$padj <- signif(sig_df$padj, digits = 3)
    
    sig_df$log2FoldChange <- round(sig_df$log2FoldChange, digits = 3)
    
    if (input_res) {
      sig_df <- subset(sig_df, padj < 0.05 & abs(log2FoldChange) > 1.5)
    }
    if (addRownames) {
      sig_df <- sig_df[!duplicated(sig_df$gene_name), ]
      row.names(sig_df) <- sig_df$gene_name
    }
    if (renameCols) {
      colnames(sig_df) <- c("ENTREZ ID",
                            "SYMBOL",
                            "ENSEMBL",
                            "Log2FC",
                            "P-Value",
                            "Adj. P-Value")
    }
    
    print(gene)
    if(!is.null(gene)){
      
      sig_df <- sig_df[sig_df$SYMBOL %in% gene, ]
      
    }
    
    # sig_df[,c(4:6)] <- round(sig_df[,c(4:6)], 6)
    # sig_1$Genes <- row.names(sig_1)
    # sig_1 <- sig_1[,c(7,2,5,6)]
    
    return(sig_df)
    
  }
  
  
  output$sample_meta <- renderUI({
    fluidRow(column(
      12,
      selectInput("meta_col", "Sample Features", choices = colnames(sample_meta)),
    ))
    
  })
  
  
  observeEvent(input$meta_col, {
    output$meta_plot <- renderPlot({
      if (input$meta_col %in% categorical_features)
      {
        ggplot(sample_meta, aes(fill = Pathology, x = sample_meta[, input$meta_col])) +
          geom_bar(position = "dodge") +
          labs(
            title = "Title",
            x = input$meta_col,
            fill = "Pathology",
            y = "Counts"
          ) +
          theme_minimal()
      }
      
    })
    
  })
  
  
  #dtServer("sample_meta_df", sample_meta[,-1])
  reactableServer("sample_meta_df", sample_meta[, -1], defaultColDef = colDef(na = "NA"),
                  reactive_tbl = FALSE)
  output$sample_summary <-  renderPrint({
    sample_meta_edit <- sample_meta[, -1]
    colnames(sample_meta_edit)[1] <- "Participant ID (P_ID)"
    skimr::skim(sample_meta_edit)
    
  })
  
  
  byGene_deg <- dtServer("dds_all_deg", clean_sig_df(res.T_vs_N), returnRow = TRUE)
  
  
  
  makeInteractiveComplexHeatmap(input, output, session, oncoplot_rds, "ht")
  
  
  
  output$rna_fusion_1 <- renderPlot({
    ggplot(rna_fusion_df,
           aes(x = Phenotype_Subtype, fill = Known_Fusion)) +
      geom_bar(position = "stack") +
      labs(title = "Known vs. Novel Fusions by Phenotype Subtype", x = "Phenotype Subtype", y = "Count") +
      scale_fill_manual(values = c("Yes" = "green", "No" = "red")) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size = 20),
        legend.title = element_text(size = 20),
        legend.text = element_text(size = 20)
      )
    
    
  })
  
  output$rna_fusion_2 <- renderPlot({
    fusion_matrix <- dcast(rna_fusion_df, Phenotype_Subtype ~ Gene_Fusion, length)
    
    pheatmap(
      as.matrix(fusion_matrix[, -1]),
      labels_row = fusion_matrix[, 1],
      cluster_rows = TRUE,
      cluster_cols = TRUE,
      main = "Heatmap of Gene Fusions Across Phenotypes",
      fontsize = 14
    )
    
    
  })
  
  
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
  
  # gprofilerServer("go_t_vs_n", res.T_vs_N$gene_name)
  #gprofilerServer("go_PTC_vs_FTC", res.PTC_vs_FTC$gene_name)
  
  gprofilerServer("go_t_vs_n", gostres_T_Vs_N, input_gostres = TRUE)
  gprofilerServer("go_PTC_vs_FTC", gostres_PTC_Vs_FTC, input_gostres = TRUE)
  
  # enrichrServer("enrichr_t_vs_n",clean_sig_df(res.T_vs_N, addRownames = TRUE), enrichr_dbs)
  # enrichrServer("enrichr_PTC_vs_FTC",clean_sig_df(res.PTC_vs_FTC, addRownames = TRUE), enrichr_dbs)
  #
  #
  ### Genomics Analysis / WES page
  
  #  dtServer("sample_variant_df", sample_variants)
  ditto_pal <- function(x)
    rgb(colorRamp(c("#e4b1ab", "#cc444b"))(x), maxColorValue = 255)
  
  
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
          choices = c(unique(sample_variants$Germline.Class)),
          selected = c(unique(sample_variants$Germline.Class)),
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
      temp_var_df <- temp_var_df[temp_var_df$Phenotype %in% input$pheno_var, ]
      temp_var_df <- temp_var_df[temp_var_df$`Variant Type` %in% input$type_var, ]
      temp_var_df <- temp_var_df[temp_var_df$Germline.Class %in% input$germ_var, ]
      
      
      temp_var_df <- temp_var_df[temp_var_df$Chromosome %in% paste0("chr", input$chr_var) , ]
      
      print(length(input$gene_var))
      
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
  
  
  reactableServer(
    "sample_variant_df",
    filtered_sample_variants,
    #groupBy = "Gene",
    #  fullWidth = FALSE,
    columns = list(
      DITTO.Score = colDef(
        style = function(value) {
          normalized <- (value - min(sample_variants$DITTO.Score)) / (max(sample_variants$DITTO.Score) - min(sample_variants$DITTO.Score))
          color <- ditto_pal(normalized)
          list(fontWeight = 700, color = color)
        }
      )
      ,
      Germline.Class = colDef(
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
  
  
  ######## By gene search page
  
  output$gene_list_main <- renderUI({
    req(sample_variants)
    
    fluidRow(
      column(12,
             selectizeInput("gene_name", "Gene Symbol", 
                            choices = sort(unique(sample_variants$Gene)))
             )
    )
    
  })
  
  filtered_gene_df <- reactiveVal(sample_variants)
  
  observeEvent(input$gene_name,{
    
    temp_gene_df <- sample_variants[sample_variants$Gene %in% input$gene_name, ]
    filtered_gene_df(temp_gene_df)
    
    dtServer("dds_all_deg_by_gene",
             clean_sig_df(res.T_vs_N, renameCols = TRUE, gene = input$gene_name),
             returnRow = FALSE)
    dtServer("dds_subtype_deg_by_gene",
             clean_sig_df(res.PTC_vs_FTC, renameCols = TRUE, gene = input$gene_name),
             returnRow = FALSE)
    
  })
  
  reactableServer("variant_df_by_gene",
                  filtered_gene_df)
 
  
  
  output$gene_info_main <- renderUI({
    req(input$gene_name)
    
    gene_info(input$gene_name)
    
  })
  


  
}
