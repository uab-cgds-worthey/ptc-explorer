######
### Server trash

# output$oncoplot_main <- renderPlot({
#     #   oncoplot_rds
## })

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


# output$lineup1 <- renderLineup({
#   vars <- sample_variants %>%
#     mutate(across(all_of(c(2:4,6,8)),as.factor)) %>%
#   lineup(vars, width = "100%",
#          options = c(
#            sidePanel = FALSE,
#            hierarchyIndicator = FALSE
#          ))
# })


# test_page <- fluidPage(
#   fluidRow(
#     column(12,
#            lineupOutput("lineup1")
#            )
#   )
# )
