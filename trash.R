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


# 
# 
# clean_sig_df <- function(sig_df,
#                          input_res = FALSE,
#                          addRownames = FALSE,
#                          renameCols = FALSE,
#                          gene = NULL) {
#   # print("Entering clean_sig_df")
#   # print(nrow(sig_df))
#   sig_df <- sig_df[!is.na(sig_df$padj), ]
#   
#   sig_df$pvalue <- signif(sig_df$pvalue, digits = 3)
#   sig_df$padj <- signif(sig_df$padj, digits = 3)
#   
#   sig_df$log2FoldChange <- round(sig_df$log2FoldChange, digits = 3)
#   
#   if (input_res) {
#     sig_df <- subset(sig_df, padj < 0.05 & abs(log2FoldChange) > 1.5)
#   }
#   if (addRownames) {
#     sig_df <- sig_df[!duplicated(sig_df$gene_name), ]
#     row.names(sig_df) <- sig_df$gene_name
#   }
#   if (renameCols) {
#     colnames(sig_df) <- c("ENTREZ ID",
#                           "SYMBOL",
#                           "ENSEMBL",
#                           "Log2FC",
#                           "P-Value",
#                           "Adj. P-Value")
#   }
#   
#   print(gene)
#   if(!is.null(gene)){
#     
#     sig_df <- sig_df[sig_df$SYMBOL %in% gene, ]
#     
#   }
#   
#   # sig_df[,c(4:6)] <- round(sig_df[,c(4:6)], 6)
#   # sig_1$Genes <- row.names(sig_1)
#   # sig_1 <- sig_1[,c(7,2,5,6)]
#   
#   return(sig_df)
#   
# }




########## Global.r dec 10

# sample_variant <- sample_variant[,c(1:9,12)]
# colnames(sample_variant)
# 
# # sample_meta <- read.csv("data/csv/ptc_meta_summary_appVer1_oct17.csv")
# # sample_variants <- read.csv("data/csv/ptc_df_onco_ditto_appVer1_oct23.csv")
# # sample_variants <- sample_variants[,c(1:9,12)]
# colnames(sample_variants) <- c("Participant ID","Phenotype",
#                                "Variant Type", "Gene", 
#                                "Variant", "Germline.Class",
#                                "Allelic Balance", "Chromosome",
#                                "Position", "DITTO.Score")
# categorical_features <- c(colnames(sample_meta[,c(3:12,14:17)]))
# 
# sample_variants[,"DITTO.Score"] <- round(sample_variants[,"DITTO.Score"], 4)



#sample_variants$Genes

# dds_noCounts <- readRDS("data/rna_seq/res_dds_T_N.rds")
# dds_group1_noCounts <- readRDS("data/rna_seq/res_dds_group1_PTC_FTC.rds")


# res.T_vs_N <- read.csv("data/csv/res_t_vs_n.csv")
# res.PTC_vs_FTC <- read.csv("data/csv/res_PTC_vs_FTC.csv")
# # 
# vsd_after_swap <- readRDS("data/rna_seq/vsd_limma_after_swap.rds")
# vsd_group1 <- readRDS("data/rna_seq/vsd_sub_limma_after_swap_group1.rds")

# 
# rna_fusion_df <- read.csv("data/rna_seq/RNA_fusions_updated.csv")
# rna_fusion_df$Participant_id <- as.factor(rna_fusion_df$Participant_id)

# res.aff.unaff <- read.csv("data/csv/res.aff.unaff_mod.csv", row.names = 1)

# Preprocess small data

