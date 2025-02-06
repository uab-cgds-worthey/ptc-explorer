navbarPage(
  title = "Pediatric Thyroid Cancer Explorer",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    tags$script(src = "js/script.js")
  ),
  inverse = FALSE,
  collapsible = TRUE,
  tabPanel("Home", home_page),
  navbarMenu("WES",
             tabPanel("Variants Distribution", onco_plot),
             tabPanel("Additional Analysis", wes_page),
  ),
  navbarMenu("RNA-Seq",
             tabPanel("RNA-Seq DGE", rna_page),
             tabPanel("RNA-Seq Fusions", rna_fusion_page),
  ),
  tabPanel("Gene Search", gene_search_page),
  tabPanel("Download", download_page),
  tabPanel("Docs", docs_page),
  tabPanel("Contact", contact_page)
)
