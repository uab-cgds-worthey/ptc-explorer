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
  tabPanel("Variants Distribution", onco_plot),
  tabPanel("DGE Analysis", rna_page),
  tabPanel("RNA-Fusions Analysis", rna_fusion_page),
  tabPanel("Signature, Clonal and MSI", wes_page),
  # navbarMenu("WES Analysis",
  #            tabPanel("Variants Distribution", onco_plot),
  #            tabPanel("Additional Analysis", wes_page),
  # ),
  # navbarMenu("RNA-Seq Analysis",
  #            tabPanel("DGE Analysis", rna_page),
  #            tabPanel("RNA-Fusions Analysis", rna_fusion_page),
  # ),
  tabPanel("Download", download_page),
  tabPanel("Docs", docs_page),
  tabPanel("Team", contact_page)
)