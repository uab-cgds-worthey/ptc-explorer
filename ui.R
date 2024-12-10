navbarPage(
     'Pediatric Thyroid Cancer Explorer',
      tabPanel('About', home_page),
      tabPanel('By Gene', geneSearch_page),
      tabPanel('Variant Distribution', onco_plot),
      tabPanel('RNA-Seq', rna_page),
      tabPanel('RNA-Seq Fusions', rnaFusion_page),
      tabPanel('WES Additional Analysis', wes_page),
      tabPanel('Download', download_page),
     #tabPanel('User Metrics', userMetrics_page)
)
