# Load libraries/ Source Files
library(shiny)
library(plotly)
library(EnhancedVolcano)
library(data.table)
library(DT)
library(rmarkdown)
library(shinybusy)
library(reshape2)
library(pheatmap)
library(ComplexHeatmap)
library(InteractiveComplexHeatmap)
library(httr)
library(jsonlite)
library(enrichR)
library(gprofiler2)

library(reactable)
detach("package:shiny", unload = TRUE)
library(shiny)
library(promises)
library(future)
library(shinycssloaders)

plan(multisession)

# Load data/connections

sample_meta <- read.csv("data/csv/ptc_meta_summary_appVer1_oct17.csv")
sample_variants <- read.csv("data/csv/ptc_df_onco_ditto_appVer1_oct23.csv")
sample_variants <- sample_variants[,c(1:9,12)]
colnames(sample_variants) <- c("Participant ID","Phenotype",
                               "Variant Type", "Gene", 
                               "Variant", "Germline.Class",
                               "Allelic Balance", "Chromosome",
                               "Position", "DITTO.Score")

sample_variants[,"DITTO.Score"] <- round(sample_variants[,"DITTO.Score"], 4)

oncoplot_rds <- readRDS("data/oncoplot_noExp_oct17.rds")

#sample_variants$Genes

# dds_noCounts <- readRDS("data/rna_seq/res_dds_T_N.rds")
# dds_group1_noCounts <- readRDS("data/rna_seq/res_dds_group1_PTC_FTC.rds")


res.T_vs_N <- read.csv("data/csv/res_t_vs_n.csv")
res.PTC_vs_FTC <- read.csv("data/csv/res_PTC_vs_FTC.csv")

vsd_after_swap <- readRDS("data/rna_seq/vsd_limma_after_swap.rds")
vsd_group1 <- readRDS("data/rna_seq/vsd_sub_limma_after_swap_group1.rds")

gostres_T_Vs_N <- readRDS("data/gostres_T_vs_N.rds")
gostres_PTC_Vs_FTC <- readRDS("data/gostres_PTC_vs_FTC.rds")

rna_fusion_df <- read.csv("data/rna_seq/RNA_fusions_updated.csv")
rna_fusion_df$Participant_id <- as.factor(rna_fusion_df$Participant_id)

res.aff.unaff <- read.csv("data/csv/res.aff.unaff_mod.csv", row.names = 1)

# Preprocess small data
 

enrichr_dbs <- c(
  "KEGG_2019_Human",
  "Reactome_2022",
  "WikiPathway_2023_Human",
  "HDSigDB_Human_2021",
   "Panther_2015"
)
