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
# library(promises)
# library(future)
library(shinycssloaders)
library(dplyr)
library(shinyWidgets)
library(scales) 
library(stringr)
library(RColorBrewer)


# plan(multisession)

# Load data/connections
app_data_main <- readRDS("data/app_data_pack_dec10.rds")

sample_meta <- app_data_main$meta
sample_variants <- app_data_main$variant

rna_fusion_df <- app_data_main$fusion

res.T_vs_N <- app_data_main$t_vs_n
res.PTC_vs_FTC <- app_data_main$ptc_vs_ftc

meta_fact_cols <- app_data_main$meta_fact_col
meta_num_cols <- app_data_main$meta_num_col

all_genes_main <- app_data_main$all_genes

oncoplot_rds <- readRDS("data/oncoplot_boxplot_2024-12-11.rds")
# oncoplot_rds = draw(oncoplot_rds)

gostres_T_vs_N <- app_data_main$t_vs_n_gp
gostres_PTC_vs_FTC <- app_data_main$ptc_vs_ftc_gp

enrichr_T_vs_N <- app_data_main$t_vs_n_er
enrichr_PTC_vs_FTC <- app_data_main$ptc_vs_ftc_er

enrichr_dbs <- app_data_main$enrichr_dbs

sample_meta_display <- sample_meta
colnames(sample_meta_display) <- str_replace_all(colnames(sample_meta_display), "_", " ")

