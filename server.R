# Shiny Server
function(input, output, session) {
 
  #dtServer("sample_meta_df", sample_meta[,-1])
  reactableServer("sample_meta_df", sample_meta[,-1],
                  defaultColDef = colDef(
                    na = "NA"
                  ))
  output$sample_summary <-  renderPrint({
    
    sample_meta_edit <- sample_meta[,-1]
    colnames(sample_meta_edit)[1] <- "Participant ID (P_ID)"
    skimr::skim(sample_meta_edit)
    
  })
  
  
  # output$oncoplot_main <- renderPlot({
  #   
  #   oncoplot_rds
  #   
  # })
  # 
  makeInteractiveComplexHeatmap(input, output, session, oncoplot_rds,
                                "ht")
  
  # Remove static first
  # output$pca_cell_1 <- renderPlot({
  #   
  #   DESeq2::plotPCA(vsd_after_swap,
  #           intgroup = c("Phenotype")) + ggtitle("PCA by Phenotype")
  #   
  # })
  # 
  # output$pca_cell_2 <- renderPlot({
  #   
  #   DESeq2::plotPCA(vsd_group1,
  #           intgroup = c("Phenotype_Subtypes")) + ggtitle("PCA by Phenotype Subtypes")
  #   
  # })
  # 
  # outputOptions(output, "pca_cell_1", suspendWhenHidden = FALSE)
  # outputOptions(output, "pca_cell_2", suspendWhenHidden = FALSE)
  
  
  output$rna_fusion_1 <- renderPlot({
    
    ggplot(rna_fusion_df, aes(x = Phenotype_Subtype, fill = Known_Fusion)) +
      geom_bar(position = "stack") +
      labs(title = "Known vs. Novel Fusions by Phenotype Subtype", x = "Phenotype Subtype", y = "Count") +
      scale_fill_manual(values = c("Yes" = "green", "No" = "red")) +
      theme_minimal() +
      theme(axis.text.x = element_text(size = 20),
            axis.text.y = element_text(size = 20),
            legend.title=element_text(size = 20),
            legend.text=element_text(size = 20))
    
    
  })
  
  output$rna_fusion_2 <- renderPlot({
    
    
    fusion_matrix <- dcast(rna_fusion_df, Phenotype_Subtype ~ Gene_Fusion, length)
    
    pheatmap(as.matrix(fusion_matrix[, -1]), 
             labels_row = fusion_matrix[, 1],
             cluster_rows = TRUE, 
             cluster_cols = TRUE, 
             main = "Heatmap of Gene Fusions Across Phenotypes", 
             fontsize = 14)
    
    
  })
  
  # output$rna_fusion_3 <- renderPlot({
  #   
  #   ggplot(rna_fusion_df, aes(x = factor(Participant_id), y = Gene_Fusion)) +
  #     geom_point(aes(color = Phenotype_Subtype), size = 4) +
  #     facet_wrap(~Phenotype_Subtype, scales = "free_x") +  # Group by Phenotype Subtype, free x-axis
  #     labs(title = "Gene Fusions by Participant, Grouped by Phenotype Subtype",
  #          x = "Participant ID",
  #          y = "Gene Fusion") +
  #     theme_minimal() +
  #     scale_color_brewer(palette = "Set2") +  # Using a color palette for Phenotype Subtype
  #     theme(axis.text.x = element_text(angle = 45, hjust = 1, size=20),
  #           axis.text.y = element_text(size = 20),
  #           legend.title=element_text(size = 20),
  #           legend.text=element_text(size = 20))
  #   
  #   
  # })
  
  output$rna_fusion_4 <- renderPlotly({
    
  p <- ggplot(rna_fusion_df, aes(x = Participant_id, y = Gene_Fusion)) +
    geom_point(aes(color = Phenotype_Subtype), size = 4) +
    labs(title = "Gene Fusions by Participant, Grouped by Phenotype Subtype",
         x = "Participant ID",
         y = "Gene Fusion") +
    scale_color_brewer(palette = "Set2") +  # Color based on phenotype subtype
    theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18),
            axis.text.y = element_text(size = 14),
            legend.title=element_text(size = 16),
            legend.text=element_text(size = 16))
  
  ggplotly(p)
  
  })
  
  clean_sig_df <- function(sig_df, input_res = FALSE, addRownames = FALSE){
    
    # print("Entering clean_sig_df")
    # print(nrow(sig_df))
    sig_df <- sig_df[!is.na(sig_df$padj), ]
    if(input_res){
      sig_df <- subset(sig_df,
                       padj < 0.05 & abs(log2FoldChange) > 1.5 )
    }
    if(addRownames){
      sig_df <- sig_df[!duplicated(sig_df$gene_name), ]
      row.names(sig_df) <- sig_df$gene_name
    }
    
    # sig_df[,c(4:6)] <- round(sig_df[,c(4:6)], 6)
    # sig_1$Genes <- row.names(sig_1)
    # sig_1 <- sig_1[,c(7,2,5,6)]
    
    return(sig_df)
    
  }
  
  res.t_vs_n.sel <- dtServer("dds_all_deg", clean_sig_df(res.T_vs_N), returnRow = TRUE)
  res.PTC_vs_FTC.sel <- dtServer("dds_subtype_deg", clean_sig_df(res.PTC_vs_FTC), returnRow = TRUE)
  
  gene_infoServer("sel_gene_t_vs_n", res.t_vs_n.sel, clean_sig_df(res.T_vs_N), 2)
  gene_infoServer("sel_gene_PTC_vs_FTC", res.PTC_vs_FTC.sel, clean_sig_df(res.PTC_vs_FTC), 2)
  
  volcanoServer("vol_aff_unaff", res.T_vs_N, "Affected vs Unaffected Samples")
  volcanoServer("vol_ptc_vs_ftc", res.PTC_vs_FTC, "Tumor Samples in PTCPlusThy vs FTC")
  
  # gprofilerServer("go_t_vs_n", res.T_vs_N$gene_name)
  #gprofilerServer("go_PTC_vs_FTC", res.PTC_vs_FTC$gene_name)
  
  gprofilerServer("go_t_vs_n", gostres_T_Vs_N, input_gostres = TRUE)
  gprofilerServer("go_PTC_vs_FTC", gostres_PTC_Vs_FTC, input_gostres = TRUE)
 
  enrichrServer("enrichr_t_vs_n",clean_sig_df(res.T_vs_N, addRownames = TRUE), enrichr_dbs)
  enrichrServer("enrichr_PTC_vs_FTC",clean_sig_df(res.PTC_vs_FTC, addRownames = TRUE), enrichr_dbs)
 
  
  ### Genomics Analysis / WES page
  
#  dtServer("sample_variant_df", sample_variants)
  ditto_pal <- function(x) rgb(colorRamp(c("#e4b1ab", "#cc444b"))(x), maxColorValue = 255)
  reactableServer("sample_variant_df", sample_variants,
                  #groupBy = "Gene",
                #  fullWidth = FALSE,
                  columns = list(
                    DITTO.Score = colDef(style = function(value) {
                      normalized <- (value - min(sample_variants$DITTO.Score)) / (max(sample_variants$DITTO.Score) - min(sample_variants$DITTO.Score))
                      color <- ditto_pal(normalized)
                      list(fontWeight = 700, color = color)
                    })
                    ,
                    Germline.Class = colDef(style = function(value) {
                      color <- if(value == "P") {
                        "#cc444b"
                      } else if (value == "LP") {
                        "#df7373"
                      }  else if(value == "LB"){
                        "#008000"
                      } else if(value == "VUS"){
                        "#e4b1ab"
                      }
                      list(fontWeight = 700, color = color)
                    }
                    )
                  )
                  )
  # output$my.volcano <- renderPlot({
  #   req(res.aff.unaff)
  #   v.mat <- na.omit(res.aff.unaff)
  #   v.title <- paste0("DEGs in ","Affected vs Unaffected Individuals")
  #   
  #   v.xlims <- c(floor(min(v.mat["log2FoldChange"])), ceiling(max(v.mat["log2FoldChange"])))
  #   v.ylims <- c(0,ceiling(-log10(min(v.mat["pvalue"])))+1)
  #   
  #   b <- EnhancedVolcano(v.mat,
  #                        lab = rownames(v.mat),
  #                        x = 'log2FoldChange',
  #                        y = 'pvalue',
  #                        title = v.title,
  #                        subtitle = "",
  #                        pCutoff = 0.05,
  #                        #pCutoffCol = "padj",
  #                        FCcutoff = 0.5,
  #                        legendPosition = 'right',
  #                        pointSize = 3.0,
  #                        labSize = 6.0,
  #                        #raster = TRUE,
  #                        ylim = v.ylims,
  #                        xlim = v.xlims,
  #                        legendLabSize = 12,
  #                        legendIconSize = 4.0,
  #                        drawConnectors = TRUE,
  #                        widthConnectors = 1.0,
  #                        colConnectors = 'black',
  #                        boxedLabels = TRUE,
  #                        # legendLabels=c('Not sig.',
  #                        #                'Log (base 2) FC',
  #                        #                'p-value',
  #                        #                'p-value [0.001 padj] & Log (base 2) FC [1.5]'),
  #                        caption = paste0("Total = ", nrow(v.mat), " genes"),
  #   )
    
  #   return(b)
  #   
  # })
  
}
