# Load libraries/ Source Files
library(shiny)
library(shinybusy)
library(shinycssloaders)
library(shinyWidgets)

## Plots and data manipulation
library(dplyr)
library(reshape2)
library(scales)
library(stringr)
library(RColorBrewer)
library(plotly)

# Tables
library(DT)
library(reactable)

# Oncoplot
library(ComplexHeatmap)
library(InteractiveComplexHeatmap)

# API calls
library(httr)
library(jsonlite)

## Special plotting
library(EnhancedVolcano)
library(enrichR)

detach("package:shiny", unload = TRUE)
library(shiny)

# Load data/connections
app_data_main <- readRDS("data/app_data_pack_2025-09-26.rds")

sample_meta <- app_data_main$meta
sample_variants <- app_data_main$variant

sample_variants_n <- nrow(sample_variants)

rna_fusion_df <- app_data_main$fusion

res_t_vs_n <- app_data_main$t_vs_n
res_ptc_vs_ftc <- app_data_main$ptc_vs_ftc

meta_fact_cols <- app_data_main$meta_fact_col
meta_num_cols <- app_data_main$meta_num_col

all_genes_main <- app_data_main$all_genes
candidate_genes_main <- app_data_main$candidate_gens

oncoplot_rds <- readRDS("data/oncoplot_boxplot_2024-12-20.rds")

gostres_t_vs_n <- app_data_main$t_vs_n_gp
gostres_ptc_vs_ftc <- app_data_main$ptc_vs_ftc_gp

enrichr_t_vs_n <- app_data_main$t_vs_n_er
enrichr_ptc_vs_ftc <- app_data_main$ptc_vs_ftc_er

enrichr_dbs <- app_data_main$enrichr_dbs

sample_meta_display <- sample_meta
colnames(sample_meta_display) <- str_replace_all(colnames(sample_meta_display),
                                                 "_",
                                                 " ")
