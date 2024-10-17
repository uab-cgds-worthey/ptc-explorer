# Shiny Server
function(input, output, session) {
 
  dtServer("sample_meta_df", sample_meta[,-1])
  
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
  makeInteractiveComplexHeatmap(input, output, session, draw(oncoplot_rds),
                                "ht")
  
  output$pca_cell_1 <- renderPlot({
    
    DESeq2::plotPCA(vsd_after_swap,
            intgroup = c("Phenotype")) + ggtitle("PCA by Phenotype")
    
  })
  
  output$pca_cell_2 <- renderPlot({
    
    DESeq2::plotPCA(vsd_group1,
            intgroup = c("Phenotype_Subtypes")) + ggtitle("PCA by Phenotype Subtypes")
    
  })
  
  
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
  
  output$rna_fusion_4 <- renderPlot({
    
  ggplot(rna_fusion_df, aes(x = as.factor(Participant_id), y = Gene_Fusion)) +
    geom_point(aes(color = Phenotype_Subtype), size = 4) +
    labs(title = "Gene Fusions by Participant, Grouped by Phenotype Subtype",
         x = "Participant ID",
         y = "Gene Fusion") +
    scale_color_brewer(palette = "Set2") +  # Color based on phenotype subtype
    theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size=20),
            axis.text.y = element_text(size = 20),
            legend.title=element_text(size = 20),
            legend.text=element_text(size = 20))
  
  })
  
  clean_sig_df <- function(sig_df, input_res = TRUE){
    
    sig_df <- sig_df[!is.na(sig_df$padj), ]
    if(input_res){
      sig_df <- subset(sig_df,
                       padj < 0.05 & abs(log2FoldChange) > 1.5 )
    }
    
    sig_1 <- round(as.data.frame(sig_df), 5)
    sig_1$Genes <- row.names(sig_1)
    sig_1 <- sig_1[,c(7,2,5,6)]
    
    return(sig_1)
    
  }
  
  dtServer("dds_all_deg", clean_sig_df(dds_noCounts))
  dtServer("dds_subtype_deg", clean_sig_df(dds_group1_noCounts))
  
  
  volcanoServer("vol_aff_unaff", res.aff.unaff, "Affected vs Unaffected Individuals")
  
  
  
  
  ### Genomics Analysis / WES page
  
  dtServer("sample_variant_df", sample_variants[,-1])
  
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
