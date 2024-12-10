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

### Sample meta / home tab
# output$sample_meta <- renderUI({
#   fluidRow(column(
#     12,
#     selectInput("meta_col", "Sample Features", choices = colnames(sample_meta)[-c(1,4)]),
#   ))
#   
# })
# 
# 
# observeEvent(input$meta_col, {
#   output$meta_plot <- renderPlotly({
#     fs_meta_plot <- 12
#     if (input$meta_col %in% meta_fact_cols)
#     {
#      p1 <-  ggplot(sample_meta, aes(fill = Subtypes, x = !!sym(input$meta_col))) +
#         geom_bar(position = "dodge") +
#         labs(
#           title = paste0("Counts of feature: ", str_replace_all(input$meta_col, "_", " ")),
#           x = str_replace_all(input$meta_col, "_", " "),
#           fill = "Subtypes",
#           y = "Counts"
#         ) +
#        scale_x_discrete(labels = function(x) str_wrap(str_replace_all(x, "_", " "),
#                                                                width = 10)) +
#        theme_minimal() + 
#         theme(
#           plot.title = element_text(size = fs_meta_plot + 4, face = "bold"),
#           axis.title.x = element_text(size = fs_meta_plot + 2, margin = margin(t = 20), face = "bold"),             
#           axis.title.y = element_text(size = fs_meta_plot + 2, face = "bold"),           
#           axis.text.x = element_text(size = fs_meta_plot),#, angle = 20, hjust = 1),              
#           axis.text.y = element_text(size = fs_meta_plot),              
#           legend.title = element_text(size = fs_meta_plot + 2),         
#           legend.text = element_text(size = fs_meta_plot) 
#         ) + scale_fill_brewer(palette = "Set2")
#      
#      ggplotly(p1)
#      
#     }else if(input$meta_col %in% meta_num_cols){
#       
#       ggplot(sample_meta, aes(x = !!sym(input$meta_col))) +
#         geom_histogram(binwidth = 5, fill = "#ccd5ae", color = "black", alpha = 0.7) +
#         geom_density(aes(y = ..count..), color = "#132a13", size = 1, adjust = 1.5) + # Add density curve
#         labs(
#           title = paste0("Histogram of feature: ", str_replace_all(input$meta_col, "_", " ")),
#           x = "Values",
#           y = "Frequency"
#         ) +
#         theme_minimal() + 
#         theme(
#           plot.title = element_text(size = fs_meta_plot + 4, face = "bold"),
#           axis.title.x = element_text(size = fs_meta_plot + 2, margin = margin(t = 20), face = "bold"),             
#           axis.title.y = element_text(size = fs_meta_plot + 2, face = "bold"),           
#           axis.text.x = element_text(size = fs_meta_plot),#, angle = 20, hjust = 1),              
#           axis.text.y = element_text(size = fs_meta_plot),              
#           legend.title = element_text(size = fs_meta_plot + 2),         
#           legend.text = element_text(size = fs_meta_plot) 
#         ) 
#       
#     }
#     
#     
#     
#   })
#   
# })
# gostres_T_Vs_N <- readRDS("data/gostres_T_vs_N.rds")
# gostres_PTC_Vs_FTC <- readRDS("data/gostres_PTC_vs_FTC.rds")


##### server dec 10
# gprofilerServer("go_t_vs_n", res.T_vs_N$gene_name)
#gprofilerServer("go_PTC_vs_FTC", res.PTC_vs_FTC$gene_name)


# enrichrServer("enrichr_t_vs_n",clean_sig_df(res.T_vs_N, addRownames = TRUE), enrichr_dbs)
# enrichrServer("enrichr_PTC_vs_FTC",clean_sig_df(res.PTC_vs_FTC, addRownames = TRUE), enrichr_dbs)
#


# output$rna_fusion_1 <- renderPlot({
#   ggplot(rna_fusion_df,
#          aes(x = Phenotype_Subtype, fill = Known_Fusion)) +
#     geom_bar(position = "stack") +
#     labs(title = "Known vs. Novel Fusions by Phenotype Subtype", x = "Phenotype Subtype", y = "Count") +
#     scale_fill_manual(values = c("Yes" = "green", "No" = "red")) +
#     theme_minimal() +
#     theme(
#       axis.text.x = element_text(size = 20),
#       axis.text.y = element_text(size = 20),
#       legend.title = element_text(size = 20),
#       legend.text = element_text(size = 20)
#     )
# })
# 
# output$rna_fusion_2 <- renderPlot({
#   fusion_matrix <- dcast(rna_fusion_df, Phenotype_Subtype ~ Gene_Fusion, length)
#   
#   pheatmap(
#     as.matrix(fusion_matrix[, -1]),
#     labels_row = fusion_matrix[, 1],
#     cluster_rows = TRUE,
#     cluster_cols = TRUE,
#     main = "Heatmap of Gene Fusions Across Phenotypes",
#     fontsize = 14
#   )
# })
# 
#  output$sample_summary <-  renderPrint({
#   sample_meta_edit <- sample_meta[, -1]
#   colnames(sample_meta_edit)[1] <- "Participant ID (P_ID)"
#   skimr::skim(sample_meta_edit)
#   
# })
# 
# uiOutput("sample_meta"),
# plotlyOutput("meta_plot",  height = "550px")
# verbatimTextOutput("sample_summary")

#           includeMarkdown("desc/home_intro.Rmd")
# dtUI("sample_meta_df")


# output$gene_list_main <- renderUI({
#   req(sample_variants)
#   
#   fluidRow(
#     column(12,
#            selectInput("gene_name", "Gene Symbol", 
#                           choices = all_genes_main)
#            )
#   )
#   
# })

# updateSelectizeInput(session, 'gene_name', choices = all_genes_main, server = TRUE)
# 
# filtered_gene_df <- reactiveVal(sample_variants)
# 
# observeEvent(input$gene_name,{
#   
#   temp_gene_df <- sample_variants[sample_variants$Gene %in% input$gene_name, ]
#   filtered_gene_df(temp_gene_df)
#   
#   reactableServer("dds_all_deg_by_gene",
#                   clean_sig_df(res.T_vs_N, renameCols = TRUE, gene = input$gene_name),
#                   reactive_tbl = FALSE)
#   reactableServer("dds_subtype_deg_by_gene",
#                   clean_sig_df(res.PTC_vs_FTC, renameCols = TRUE, gene = input$gene_name),
#                   reactive_tbl = FALSE)
#   
#   rna_fusion_df_filtered <- rna_fusion_df[rna_fusion_df$geneA %in% input$gene_name |
#                                             rna_fusion_df$geneB %in% input$gene_name,
#   ]
#   reactableServer("rnafusion_df_by_gene",
#                   rna_fusion_df_filtered,
#                   reactive_tbl = FALSE)
#   
#   
# })
# 
# reactableServer("variant_df_by_gene",
#                 filtered_gene_df)
# 
# 
# 
# output$gene_info_main <- renderUI({
#   req(input$gene_name)
#   
#   gene_info(input$gene_name)
#   
# })
# byGene_deg <- dtServer("dds_all_deg", clean_sig_df(res.T_vs_N), returnRow = TRUE)
