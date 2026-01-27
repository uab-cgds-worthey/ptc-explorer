navbarPage(
  title = "Pediatric Thyroid Cancer Explorer",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css?v=1.4"),
    tags$script(src = "js/script.js")
  ),
  inverse = FALSE,
  collapsible = TRUE,
  tabPanel("Home", home_page),
  tabPanel("Gene Search", gene_search_page),
  tabPanel("Variants Distribution", wes_variant_page),
  tabPanel("DGE Analysis", rna_downstream_page),
  tabPanel("RNA-Fusions Analysis", rna_fusion_page),
  tabPanel("Signature, Clonal and MSI", wes_additional_page),
  tabPanel("Download", download_page),
  tabPanel("User Guide", user_guide_page),
  tabPanel("Developer Guide", developer_guide_page),
  tabPanel("Team", contact_page),
  tabPanel("Cite Us", cite_us_page)
)

