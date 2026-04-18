tagList(
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
  ),
  div(
    style = "text-align: center; padding: 20px; background-color: #f8f9fa; margin-top: 20px; border-top: 1px solid #dee2e6;",
    p("Pediatric Thyroid Cancer Explorer | v1.0.0", style = "margin: 0; color: #6c757d;")
  )
)
