# Shiny Server
function(input, output, session) {
  #### Home tab/page
  metaPlotsServer("sample_meta_stats",
                  sample_meta,
                  meta_fact_cols,
                  meta_num_cols)
  reactableServer(
    "sample_meta_df",
    sample_meta_display,
    defaultColDef = colDef(na = "NA"),
    defaultPageSize = 25,
    reactive_tbl = FALSE,
    bordered = TRUE
  )
  
  #### By gene search page
  geneSearchServer(
    "geneSearch_main",
    geneList = all_genes_main,
    var_table = sample_variants,
    deg_t_vs_n = res.T_vs_N,
    deg_ptc_vs_ftc = res.PTC_vs_FTC,
    fusion_table = rna_fusion_df
  )
  
  #### Oncoplot and sample variant tab
  variantFilterServer("variant_table_with_filters", sample_variants)
  
  makeInteractiveComplexHeatmap(input, output, session,
                                oncoplot_rds,
                                "ht",
                                res = 110)
  
  
  #### RNA-seq tab
  res.t_vs_n.sel <- dtServer("dds_all_deg",
                             clean_sig_df(res.T_vs_N, renameCols = TRUE),
                             returnRow = TRUE)
  res.PTC_vs_FTC.sel <- dtServer("dds_subtype_deg",
                                 clean_sig_df(res.PTC_vs_FTC, renameCols = TRUE),
                                 returnRow = TRUE)
  
  gene_infoServer("sel_gene_t_vs_n",
                  res.t_vs_n.sel,
                  clean_sig_df(res.T_vs_N),
                  1)
  gene_infoServer("sel_gene_PTC_vs_FTC",
                  res.PTC_vs_FTC.sel,
                  clean_sig_df(res.PTC_vs_FTC),
                  1)
  
  volcanoServer(
    "vol_aff_unaff",
    res.T_vs_N,
    "Affected vs Unaffected Samples",
    clean_sig_df(res.T_vs_N),
    res.t_vs_n.sel,
    2
  )
  volcanoServer(
    "vol_ptc_vs_ftc",
    res.PTC_vs_FTC,
    "Tumor Samples in PTCPlusThy vs FTC",
    clean_sig_df(res.PTC_vs_FTC),
    res.PTC_vs_FTC.sel,
    2
  )
  
  gprofilerServer("go_t_vs_n", gostres_T_vs_N, input_gostres = TRUE)
  gprofilerServer("go_PTC_vs_FTC", gostres_PTC_vs_FTC, input_gostres = TRUE)
  
  enrichrServer("enrichr_t_vs_n",
                enrichr_T_vs_N,
                enrichr_dbs,
                precalculate = TRUE)
  enrichrServer("enrichr_PTC_vs_FTC",
                enrichr_PTC_vs_FTC,
                enrichr_dbs,
                precalculate = TRUE)
  
  
  #### RNA-fusion tab
  output$rna_fusion_4 <- renderPlotly({
    p <- ggplot(rna_fusion_df, aes(x = Participant_id, y = Gene_Fusion)) +
      geom_point(aes(color = Phenotype_Subtype), size = 4) +
      labs(title = "Gene Fusions by Participant,
           Grouped by Phenotype Subtype",
           x = "Participant ID",
           y = "Gene Fusion") +
      scale_color_brewer(palette = "Set2") +  # Color based on phenotype subtype
      theme_minimal() +
      theme(
        axis.text.x = element_text(
          angle = 45,
          hjust = 1,
          size = 18
        ),
        axis.text.y = element_text(size = 14),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16)
      )
    
    ggplotly(p)
    
  })
  
  #### Genomics Analysis / WES page
  
}
