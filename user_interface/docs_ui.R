docs_page <- fluidPage(
  fluidRow(
    column(3,),
    column(6,
           style = "display: flex; flex-direction: column;
          justify-content: center;
          align-items: left; height: 100%;",
           # h3("FAQs and Tutorial"),
           includeMarkdown("docs/ptce_docs.Rmd")),
    br(),
    column(3,)
  ),
  br(),
)