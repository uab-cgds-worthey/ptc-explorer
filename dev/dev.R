# Use this script to test code blocks for app dev. 
# Make sure to add this "dev" directory 
# in your gitignore after template initialization.


sample_variants
sample_variants <- sample_variants[sample_variants$Germline_Class != "VUS",]
sample_variants[duplicated(sample_variants[,c("Genes","Variant","Type","DITTO")]),]

sample_var_test <- sample_variants[!duplicated(sample_variants[,c("Genes","Variant","Type", "DITTO")]),]

nrow(sample_var_test)

plot(sample_var_test[sample_var_test$chrom == "chr7","pos"],
     sample_var_test[sample_var_test$chrom == "chr7","DITTO"])

plot(log2(sample_var_test$DITTO))


ggplot(sample_var_test[sample_var_test$Genes == "DICER1",], aes(x=Variant, y=DITTO, fill = Germline_Class)) + 
  geom_bar(stat="identity",  width=0.2) +
  theme_minimal()+
  coord_flip()

table(sample_var_test$chrom)
table(sample_var_test$Genes)
ggplot(sample_var_test[sample_var_test$chrom == "chr7",], aes(x=Variant, y=DITTO, fill = Genes)) + 
  geom_bar(stat="identity",  width=0.2) +
  theme_minimal()+
  coord_flip()
  # geom_text(
  #   label=sample_variants$Variant[sample_var_test$Genes == "BRSK1"], 
  #  # nudge_x = 0.25, nudge_y = 0.25, 
  #   check_overlap = T
  # )

library(reactable)
ditto_pal <- function(x) rgb(colorRamp(c("#e4b1ab", "#cc444b"))(x), maxColorValue = 255)
reactable(
  sample_variants,
  #groupBy = "Genes",
  #defaultExpanded = TRUE,
  columns = list(
    DITTO = colDef(style = function(value) {
      normalized <- (value - min(sample_variants$DITTO)) / (max(sample_variants$DITTO) - min(sample_variants$DITTO))
      color <- ditto_pal(normalized)
      list(background = color)
    }),
    Germline_Class = colDef(style = function(value) {
      color <- if(value == "P") {
        "#cc444b"
      } else if (value == "LP") {
        "#df7373"
      }  else if(value == "LB"){
        "#008000"
      } else if(value == "VUS"){
        "#e4b1ab"
      } 
      list(fontWeight = 600, background = color)
    }
    )
  )
)


library(ggpattern)

ggplot(sample_var_test[sample_var_test$chrom == "chr8",], aes(x=Variant, y=DITTO, fill = Genes)) +
geom_col_pattern(
  aes(pattern=Type,
      pattern_angle=Type,
      pattern_spacing=Type
  ),
#  fill            = 'white',
  colour          = 'black', 
  pattern_density = 0.2, 
  pattern_fill    = 'black',
  pattern_colour  = 'darkgrey')
  
  

plotly(sample_variants$Participant_id,
       sample_variants$DITTO)
sample_variants$pos



###### Save gprofiler results

res.T_vs_N <- read.csv("data/csv/res_t_vs_n.csv")
res.PTC_vs_FTC <- read.csv("data/csv/res_PTC_vs_FTC.csv")


gostres.T_vs_N <- gost(
  query = res.T_vs_N$gene_id,
  organism = "hsapiens",
  ordered_query = FALSE,
  multi_query = FALSE,
  significant = TRUE,
  exclude_iea = FALSE,
  measure_underrepresentation = FALSE,
  evcodes = FALSE,
  user_threshold = 0.05,
  correction_method = "g_SCS", # "bonferroni", # "g_SCS",
  domain_scope = "annotated",
  custom_bg = NULL,
  numeric_ns = "",
  sources = NULL,
  as_short_link = FALSE,
  highlight = TRUE
)


gostres.PTC_vs_FTC <- gost(
  query = res.PTC_vs_FTC$gene_id,
  organism = "hsapiens",
  ordered_query = FALSE,
  multi_query = FALSE,
  significant = TRUE,
  exclude_iea = FALSE,
  measure_underrepresentation = FALSE,
  evcodes = FALSE,
  user_threshold = 0.05,
  correction_method = "g_SCS", # "bonferroni", # "g_SCS",
  domain_scope = "annotated",
  custom_bg = NULL,
  numeric_ns = "",
  sources = NULL,
  as_short_link = FALSE,
  highlight = TRUE
)


saveRDS(gostres.T_vs_N, "./data/gostres_T_vs_N.rds")

saveRDS(gostres.PTC_vs_FTC, "./data/gostres_PTC_vs_FTC.rds")


####### Saving PCA

vsd_after_swap <- readRDS("data/rna_seq/vsd_limma_after_swap.rds")
vsd_group1 <- readRDS("data/rna_seq/vsd_sub_limma_after_swap_group1.rds")


DESeq2::plotPCA(vsd_after_swap, intgroup = c("Phenotype", "Batch")) + 
  ggtitle("Grouped by Phenotype") + 
  labs(color = "Group: Phenotype") +
  theme_minimal()

DESeq2::plotPCA(vsd_group1, intgroup = c("Phenotype_Subtypes")) + 
  ggtitle("Grouped by Phenotype Subtypes") + 
  labs(color = "Group: Phenotype Subtype") +
  theme_minimal()


ggplotly(DESeq2::plotPCA(vsd_after_swap,
                  intgroup = c("Phenotype")) + ggtitle("Grouped by Phenotype"))

ggplotly(DESeq2::plotPCA(vsd_group1,
                  intgroup = c("Phenotype_Subtypes")) + 
           ggtitle("Grouped by Phenotype Subtypes") + 
           labs(color = "Group: Phenotype Subtype") +
           theme_minimal())



p_interactive <- ggplotly(p, tooltip = c("x", "y", "label"))



######## Prepare gene list
# gene_names <- rownames(assay(vsd_after_swap))
# gene_names_group1 <- rownames(assay(vsd_group1))
# 

genes_deg_t_vs_n <- res.T_vs_N$gene_id
genes_deg_ptc_vs_ftc <- res.PTC_vs_FTC$gene_id

length(genes_deg_t_vs_n)
length(genes_deg_ptc_vs_ftc)

genes_deg <- genes_deg_t_vs_n + genes_deg_ptc_vs_ftc


##### Fusions

rna_fusion_df <- read.csv("data/rna_seq/RNA_fusions.csv")

gene_a <- unlist(strsplit(rna_fusion_df$Gene_Fusion[6], "--"))[2]
gene_a

rna_fusion_df$geneA <- sapply(rna_fusion_df$Gene_Fusion, function(x){
  unlist(strsplit(x, "--"))[1]
})

rna_fusion_df$geneB <- sapply(rna_fusion_df$Gene_Fusion, function(x){
  unlist(strsplit(x, "--"))[2]
})


write.csv(rna_fusion_df, "data/rna_seq/RNA_fusions_updated.csv", row.names = FALSE)

genes_rna_fusion <- unlist(strsplit(rna_fusion_df$Gene_Fusion, "--"))
length(genes_rna_fusion)

genes_rna_fusion <- genes_rna_fusion[!duplicated(genes_rna_fusion)]
length(genes_rna_fusion)

any(duplicated(genes_rna_fusion))




