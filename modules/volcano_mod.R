volcanoUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(3,
             uiOutput(ns("volcano_opt.pval")),
             br(),
             uiOutput(ns("volcano_opt.logFC"))
      ),
      column(9,
             plotOutput(ns("my.volcano"), height = "600px") %>% withSpinner()
             )
      )
  )
}

volcanoServer <- function(id, mat, contrast, tbl = NULL, selected_row = NULL, 
                          gene_symbol_col = NULL, ...) {
  moduleServer(
    id,
    function(input, output, session) {
     
      ns <- session$ns
    
      output$volcano_opt.pval <- renderUI({
        req(mat)
        sliderInput(ns("vol_pval"),
                    "Adjusted P-Value",
                    min = 0.005,
                    max = 0.05,
                    value = 0.05,
                    step = 0.005)

        
      }) 
      
      output$volcano_opt.logFC <- renderUI({
        req(mat)
        sliderInput(ns("vol_logFC"),
                    "Log2FoldChange",
                    min = 1,
                    max = 20,
                    value = 5,
                    step = 1)
        
        
      }) 
      
      output$my.volcano <- renderPlot({
        req(mat)
        v.title <- paste0("DEGs in ",contrast)
        v.mat <- na.omit(mat)

        validate(
          need(!is.null(input$vol_pval), "Please set adjusted p-value cut-off"),
          need(!is.null(input$vol_logFC), "Please set Log2 Fold Change Cut-off"))
        
        highlight_gene <- tbl[selected_row(),gene_symbol_col]

        b <- EnhancedVolcano(v.mat,
                             lab = v.mat[,"gene_name"],
                             x = 'log2FoldChange',
                             y = 'pvalue',
                             title = v.title,
                             subtitle = "",
                             selectLab = highlight_gene,
                             pCutoff = input$vol_pval, # 0.05
                             pCutoffCol = "padj",
                             FCcutoff = input$vol_logFC, # 1.5
                             legendPosition = 'bottom',
                             pointSize = 3.0,
                             labSize = 6.0,
                             # ylim = v.ylims,
                             # xlim = v.xlims,
                             legendLabSize = 16,
                             legendIconSize = 5.0,
                             drawConnectors = TRUE,
                             widthConnectors = 1.0,
                             colConnectors = 'black',
                             boxedLabels = TRUE,
                             # legendLabels=c('Not sig.',
                             #                'Log (base 2) FC',
                             #                'p-value',
                             #                'p-value [0.001 padj] & Log (base 2) FC [1.5]'),
                             caption = paste0("Total = ", nrow(v.mat), " genes")
        )
        
         return(b)
        
      })
    }
  )
}