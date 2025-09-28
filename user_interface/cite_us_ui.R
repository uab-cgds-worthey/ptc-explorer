cite_us_page <- fluidPage(
  fluidRow(
    column(12,
      div(
        class = "citation-container",
        style = "max-width: 800px; margin: 0 auto; padding: 20px;",
        
        h2("How to Cite PTCE", style = "color: darkred; text-align: center; margin-bottom: 30px;"),
        
        p("If you use the Pediatric Thyroid Cancer Explorer (PTCE) in your research, please cite our work using one of the formats below:", 
          style = "text-align: center; font-size: 18px; margin-bottom: 40px;"),
        
        # Journal Citation
        div(
          class = "citation-format",
          style = "background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 20px; margin: 20px 0;",
          h4("Journal Format", style = "color: darkred; margin-top: 0;"),
          div(
            id = "journal_citation",
            class = "citation-text",
            style = "background-color: white; border: 1px solid #ced4da; border-radius: 4px; padding: 15px; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.5;",
            "Author names to be updated. (2025). Pediatric Thyroid Cancer Explorer: An interactive web resource for genomic and transcriptomic analysis. Journal Name. DOI: [TO BE UPDATED]"
          ),
          br(),
          tags$button(
            "Copy Citation",
            class = "btn btn-outline-secondary copy-btn",
            style = "margin-top: 10px;",
            onclick = "copyToClipboard('journal_citation', this)"
          )
        ),
        
        # BibTeX Citation
        div(
          class = "citation-format",
          style = "background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 20px; margin: 20px 0;",
          h4("BibTeX Format", style = "color: darkgreen; margin-top: 0;"),
          div(
            id = "bibtex_citation",
            class = "citation-text",
            style = "background-color: white; border: 1px solid #ced4da; border-radius: 4px; padding: 15px; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.5;",
            HTML("@article{ptce2025,<br/>
            &nbsp;&nbsp;title={Pediatric Thyroid Cancer Explorer: An interactive web resource for genomic and transcriptomic analysis},<br/>
            &nbsp;&nbsp;author={Author names to be updated},<br/>
            &nbsp;&nbsp;journal={Journal Name},<br/>
            &nbsp;&nbsp;year={2025},<br/>
            &nbsp;&nbsp;doi={TO BE UPDATED},<br/>
            &nbsp;&nbsp;url={https://github.com/uab-cgds-worthey/ptc-explorer}<br/>
            }")
          ),
          br(),
          tags$button(
            "Copy Citation",
            class = "btn btn-outline-secondary copy-btn",
            style = "margin-top: 10px;",
            onclick = "copyToClipboard('bibtex_citation', this)"
          )
        ),
        
        # Software Citation
        div(
          class = "citation-format",
          style = "background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 20px; margin: 20px 0;",
          h4("Software Citation", style = "color: #6f42c1; margin-top: 0;"),
          div(
            id = "software_citation",
            class = "citation-text",
            style = "background-color: white; border: 1px solid #ced4da; border-radius: 4px; padding: 15px; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.5;",
            "Pediatric Thyroid Cancer Explorer (PTCE). (2025). Version 1.0. UAB Center for Computational Genomics and Data Science. Available at: https://github.com/uab-cgds-worthey/ptc-explorer"
          ),
          br(),
          tags$button(
            "Copy Citation",
            class = "btn btn-outline-secondary copy-btn",
            style = "margin-top: 10px;",
            onclick = "copyToClipboard('software_citation', this)"
          )
        ),
        
        # Additional Information
        hr(style = "margin: 40px 0;"),
        div(
          style = "background-color: #e9ecef; border-radius: 8px; padding: 20px; text-align: center;",
          h5("Additional Information", style = "color: #495057; margin-top: 0;"),
          p("This web application and associated data are provided for research and educational purposes.", style = "margin-bottom: 8px;"),
          p("For questions about citing specific datasets or analyses, please contact the development team.", style = "margin-bottom: 8px;"),
          p("DOI and publication details will be updated once the manuscript is published.", style = "font-style: italic; margin-bottom: 0; color: #6c757d;")
        )
      )
    )
  )
)