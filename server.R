# Shiny Server
function(input, output, session) {
  #### Home tab/page
  meta_plots_server("sample_meta_stats",
                    sample_meta,
                    meta_fact_cols,
                    meta_num_cols)
  reactable_server(
    "sample_meta_df",
    sample_meta_display %>% 
      mutate(across(where(is.factor), ~ gsub("_", " ", .))),
#    sample_meta_display,
    defaultColDef = colDef(na = "NA", minWidth = 95),
    columns = list(
      `Participant id` = colDef(
        minWidth = 85,
      ),
      `TI RADS Score` = colDef(
        minWidth = 60,
      ),
      `Age at diagnosis` = colDef(
      minWidth = 120,
      name = "Age at diagnosis / Sex",
      # Show species under character names
      cell = function(value, index) {
        Sex <- sample_meta_display$Sex[index]
        Sex <- if (!is.na(Sex)) Sex else "Unknown"
        div(
          div(style = list(fontWeight = 600),
              value),
          div(style = list(#fontSize = "1rem"
            ),
              Sex)
        )
      }
    ),
      Sex = colDef(show = FALSE)
    ),
    defaultPageSize = 25,
    fullWidth = TRUE,
    reactive_tbl = FALSE,
    bordered = TRUE
  )
 
  #### Oncoplot and sample variant tab
  variant_filter_server("variant_table_with_filters", sample_variants)
  makeInteractiveComplexHeatmap(input, output, session,
                                oncoplot_rds,
                                "ht",
                                res = 110)
  #### RNA-seq tab
  res_t_vs_n_sel <- dt_server("dds_all_deg",
                                  clean_sig_df(res_t_vs_n, rename_cols = TRUE),
                                  return_row = TRUE)
  res_ptc_vs_ftc_sel <- dt_server("dds_subtype_deg",
                                  clean_sig_df(res_ptc_vs_ftc,
                                               rename_cols = TRUE),
                                  return_row = TRUE)
  gene_info_server("sel_gene_t_vs_n",
                   res_t_vs_n_sel,
                   clean_sig_df(res_t_vs_n),
                   2)
  gene_info_server("sel_gene_PTC_vs_FTC",
                   res_ptc_vs_ftc_sel,
                   clean_sig_df(res_ptc_vs_ftc),
                   2)
  volcano_server(
    "vol_aff_unaff",
    res_t_vs_n[, -c(1,7,8)],
    "Affected vs Unaffected Samples",
    res_t_vs_n[, -c(1,7,8)],
    res_t_vs_n_sel,
    1
  )
  volcano_server(
    "vol_ptc_vs_ftc",
    res_ptc_vs_ftc[, -c(1,7,8)],
    "Tumor Samples in PTCPlusThy vs FTC",
    res_ptc_vs_ftc[, -c(1,7,8)],
    res_ptc_vs_ftc_sel,
    1
  )
  enrichr_server_mod("enrichr_t_vs_n",
                     enrichr_t_vs_n,
                     enrichr_dbs,
                     precalculate = TRUE)
  enrichr_server_mod("enrichr_PTC_vs_FTC",
                     enrichr_ptc_vs_ftc,
                     enrichr_dbs,
                     precalculate = TRUE)
  
  #### RNA-fusion tab
  fusion_filter_server("rna_fusion_tbl",
                       rna_fusion_df[, -12])
  
  #### Genomics Analysis / WES page
  
  
  #### Gene search page
  gene_search_server(
    "geneSearch_main",
    gene_list = all_genes_main,
    var_table = sample_variants,
    deg_t_vs_n = res_t_vs_n,
    deg_ptc_vs_ftc = res_ptc_vs_ftc,
    fusion_table = rna_fusion_df,
    candidate_gene_list = candidate_genes_main
  )
}
