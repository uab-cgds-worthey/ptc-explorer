navbarPage(
  title = "Pediatric Thyroid Cancer Explorer",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")
  ),
  tabPanel("About", home_page),
  tabPanel("By Gene", gene_search_page),
  tabPanel("Variant Distribution", onco_plot),
  tabPanel("RNA-Seq", rna_page),
  tabPanel("RNA-Seq Fusions", rna_fusion_page),
  tabPanel("WES Additional Analysis", wes_page),
  tabPanel("Download", download_page)
)
