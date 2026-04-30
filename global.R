# options(bitmapType = "cairo") # Enable for oncoprint when deploying to shiny-server 
# Load libraries/ Source Files
library(shiny)
library(shinybusy)
library(shinycssloaders)
library(shinyWidgets)
library(markdown)
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

# Load utility functions
source("R/utils.R")

# Load data/connections using latest date files
app_data_result <- load_latest_app_data()
app_data_main <- app_data_result$data
app_data_version <- app_data_result$version
app_data_file_info <- app_data_result$file_info

sample_meta <- app_data_main$meta
sample_variants <- app_data_main$variant

# Backward/forward compatibility for renamed variant columns
if ("Case_id" %in% colnames(sample_variants) && !("Case id" %in% colnames(sample_variants))) {
  colnames(sample_variants)[colnames(sample_variants) == "Case_id"] <- "Case id"
}
if ("Participant ID" %in% colnames(sample_variants) && !("Case id" %in% colnames(sample_variants))) {
  colnames(sample_variants)[colnames(sample_variants) == "Participant ID"] <- "Case id"
}
if ("User_Classification" %in% colnames(sample_variants) && !("Germline Class" %in% colnames(sample_variants))) {
  colnames(sample_variants)[colnames(sample_variants) == "User_Classification"] <- "Germline Class"
}

sample_variants_n <- nrow(sample_variants)

# Load clonal analysis mapping
clonal_res_mapping <- read.csv("data/clonal_res_mapping.csv")

rna_fusion_df <- app_data_main$fusion

res_t_vs_n <- app_data_main$t_vs_n
res_ptc_vs_ftc <- app_data_main$ptc_vs_ftc

meta_fact_cols <- app_data_main$meta_fact_col
meta_num_cols <- app_data_main$meta_num_col

all_genes_main <- app_data_main$all_genes
candidate_genes_main <- if ("candidate_genes" %in% names(app_data_main)) {
  app_data_main$candidate_genes
} else {
  app_data_main$candidate_gens
}


gostres_t_vs_n <- app_data_main$t_vs_n_gp
gostres_ptc_vs_ftc <- app_data_main$ptc_vs_ftc_gp

enrichr_t_vs_n <- app_data_main$t_vs_n_er
enrichr_ptc_vs_ftc <- app_data_main$ptc_vs_ftc_er

enrichr_dbs <- app_data_main$enrichr_dbs

sample_meta_display <- sample_meta
colnames(sample_meta_display) <- str_replace_all(
  colnames(sample_meta_display),
  "_",
  " "
)
if ("Participant id" %in% colnames(sample_meta_display) && !("Case id" %in% colnames(sample_meta_display))) {
  colnames(sample_meta_display)[colnames(sample_meta_display) == "Participant id"] <- "Case id"
}
sample_meta_display[] <- lapply(sample_meta_display, function(col) {
  if (is.factor(col)) {
    col <- as.character(col)
    col[is.na(col)] <- "NA"
    col
  } else if (is.character(col)) {
    col[is.na(col)] <- "NA"
    col
  } else {
    col
  }
})
if ("Case id" %in% colnames(sample_meta_display)) {
  sample_meta_display <- sample_meta_display[order(sample_meta_display[["Case id"]]), ]
}

# Load oncoplot data using latest date file
onco_result <- load_latest_onco_data()
onco_obj_list <- onco_result$data
onco_data_version <- onco_result$version
onco_file_info <- onco_result$file_info

oncoplot <- rlang::exec(
  oncoPrint,
  mat = onco_obj_list$mat,
  alter_fun = onco_obj_list$alter_fun,
  !!!onco_obj_list$params
)

# Use null device to prevent Rplots.pdf creation during app startup
# pdf(NULL) # when deploying to shiny-server 
invisible(grid::grid.grabExpr({
  ptc_oncoprint_draw <- draw(
    oncoplot,
    heatmap_legend_list = onco_obj_list$lgd,
    merge_legend = TRUE,
    legend_gap = unit(0.75, "cm")
  )
}))
# dev.off()  # when deploying to shiny-server 