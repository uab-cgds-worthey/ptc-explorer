navbarPage(
  title = "Pediatric Thyroid Cancer Explorer",
  # title = tags$a(href = "#", "Pediatric Thyroid Cancer Explorer", 
  #        style = "text-decoration: none; color: white;"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")
  ),
  inverse = TRUE,
  collapsible = TRUE,
  tabPanel("Home", home_page),
  tabPanel("Variants Distribution", onco_plot),
  navbarMenu("RNA-Seq",
             tabPanel("RNA-Seq DGE", rna_page),
             tabPanel("RNA-Seq Fusions", rna_fusion_page),
  ),
  tabPanel("WES Additional Analysis", wes_page),
  tabPanel("Gene Search", gene_search_page),
  tabPanel("Download", download_page),
  tabPanel("Docs", docs_page),
  tabPanel("Contact", contact_page)
)
