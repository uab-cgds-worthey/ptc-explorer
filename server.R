# Shiny Server
function(input, output, session) {
  #### Home tab/page
  meta_plots_server(
    "sample_meta_stats",
    sample_meta,
    meta_fact_cols,
    meta_num_cols
  )
  reactable_server(
    "sample_meta_df",
    sample_meta_display %>%
      mutate(across(where(is.factor), ~ gsub("_", " ", .))),
    #    sample_meta_display,
    defaultColDef = colDef(na = "NA", minWidth = 95, align = "left"),
    columns = list(
      `Case id` = colDef(
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
            div(
              style = list(fontWeight = 600),
              value
            ),
            div(
              style = list( # fontSize = "1rem"
              ),
              Sex
            )
          )
        }
      ),
      Sex = colDef(show = FALSE),
      Subtypes = colDef(
        style = function(value) {
          if (is.null(value) || is.na(value)) {
            return(NULL)
          }
          color <- if (value == "FA") {
            "#E31A1C"
          } else if (value == "FTC") {
            "#FDBF6F"
          } else if (value == "NIFTP") {
            "#FF7F00"
          } else if (value == "PTC") {
            "#CAB2D6"
          } else if (value == "PTCplusTHY") {
            "#6A3D9A"
          } else if (value == "THY") {
            "#FFFF99"
          }
          fontcolor <- if (value == "FA") {
            "white"
          } else if (value == "FTC") {
            "#000"
          } else if (value == "NIFTP") {
            "#000"
          } else if (value == "PTC") {
            "#000"
          } else if (value == "PTCplusTHY") {
            "white"
          } else if (value == "THY") {
            "#000"
          }
          list(
            fontWeight = 700,
            background = color,
            color = fontcolor
          )
        }
      ),
      `ATA Pediatric Risk Level` = colDef(
        style = function(value) {
          if (is.null(value) || is.na(value)) {
            return(NULL)
          }
          color <- if (value == "High risk") {
            "#FF0000"
          } else if (value == "Intermediate risk") {
            "#FF8C00"
          } else if (value == "Low risk") {
            "#3CB371"
          }
          list(
            fontWeight = 700,
            background = color # ,
            # color = fontcolor
          )
        }
      )
    ),
    defaultPageSize = 25,
    fullWidth = TRUE,
    reactive_tbl = FALSE,
    bordered = TRUE
  )

  #### Oncoplot and sample variant tab
  variant_filter_server("variant_table_with_filters", sample_variants)
  makeInteractiveComplexHeatmap(input, output, session,
    ptc_oncoprint_draw,
    "ht",
    res = 110
  )
  #### RNA-seq tab
  res_t_vs_n_sel <- dt_server("dds_all_deg",
    clean_sig_df(res_t_vs_n, rename_cols = TRUE),
    return_row = TRUE
  )
  res_ptc_vs_ftc_sel <- dt_server("dds_subtype_deg",
    clean_sig_df(res_ptc_vs_ftc,
      rename_cols = TRUE
    ),
    return_row = TRUE
  )
  gene_info_server(
    "sel_gene_t_vs_n",
    res_t_vs_n_sel,
    clean_sig_df(res_t_vs_n),
    2
  )
  gene_info_server(
    "sel_gene_PTC_vs_FTC",
    res_ptc_vs_ftc_sel,
    clean_sig_df(res_ptc_vs_ftc),
    2
  )
  volcano_server(
    "vol_aff_unaff",
    res_t_vs_n[, -c(1, 7, 8)],
    "Affected vs Unaffected Samples",
    res_t_vs_n[, -c(1, 7, 8)],
    res_t_vs_n_sel,
    1
  )
  volcano_server(
    "vol_ptc_vs_ftc",
    res_ptc_vs_ftc[, -c(1, 7, 8)],
    "Tumor Samples in PTCPlusThy vs FTC",
    res_ptc_vs_ftc[, -c(1, 7, 8)],
    res_ptc_vs_ftc_sel,
    1
  )
  enrichr_server("enrichr_t_vs_n",
    enrichr_t_vs_n,
    enrichr_dbs,
    precalculate = TRUE
  )
  enrichr_server("enrichr_PTC_vs_FTC",
    enrichr_ptc_vs_ftc,
    enrichr_dbs,
    precalculate = TRUE
  )

  #### RNA-fusion tab
  fusion_filter_server(
    "rna_fusion_tbl",
    rna_fusion_df[, -12]
  )

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


  ######## Contact us
  profile_server(
    "gk",
    name = "Gurpreet Kaur, Ph.D.",
    img_url = "gurpreet_kaur.jpg",
    title = "Project lead, App Ideation and Planning",
    email = "gurpreet.bioinfo@gmail.com",
    linkedin_url = "https://www.linkedin.com/in/gurpreet-bioin4/",
    x_url = "https://x.com/gurpreet_bioin4"
  )

  profile_server(
    "sb",
    name = "Samuel Bharti",
    img_url = "samuel_bharti.jpg",
    title = "App Development, Testing and Deployment",
    email = "sbharti@uab.edu",
    linkedin_url = "https://www.linkedin.com/in/samuelbharti/",
    x_url = "#",
    img_style = "width:100%;"
  )

  profile_server(
    "lw",
    name = "Elizabeth Worthey, Ph.D.",
    img_url = "liz_worthey.jpg",
    title = "Funding and Principal Investigator",
    email = "eaworthey@uabmc.edu",
    linkedin_url = "https://www.linkedin.com/in/lizworthey/",
    x_url = "https://x.com/lizworthey",
    img_style = "width:100%;"
  )

  #### Download handlers
  output$download_app_data <- downloadHandler(
    filename = function() {
      # Generate filename with current date
      paste0("app_data_pack_", Sys.Date(), ".rds")
    },
    content = function(file) {
      # Load the latest app data and save to download file
      latest_data <- load_latest_app_data()
      saveRDS(latest_data, file)
    },
    contentType = "application/octet-stream"
  )

  output$download_onco_data <- downloadHandler(
    filename = function() {
      # Generate filename with current date
      paste0("ptc_onco_obj_list_", Sys.Date(), ".rds")
    },
    content = function(file) {
      # Load the latest onco data and save to download file
      latest_onco <- load_latest_onco_data()
      saveRDS(latest_onco, file)
    },
    contentType = "application/octet-stream"
  )
}
