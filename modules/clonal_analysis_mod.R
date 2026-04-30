clonal_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      style = "display: flex; justify-content: center;",
      uiOutput(ns("clonal_image_container"))
    )
  )
}

clonal_analysis_server <- function(id, case_id, clonal_mapping) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$clonal_image_container <- renderUI({
      req(case_id())
      
      # Get image_id(s) for the selected case_id
      image_ids <- clonal_mapping[clonal_mapping$case_id == case_id(), "image_id"]
      
      if (length(image_ids) == 0) {
        return(
          tags$p(
            style = "color:darkred;",
            "No significant clones were determined for this case."
          )
        )
      }
      
      # Create image outputs dynamically with spinners
      lapply(seq_along(image_ids), function(i) {
        img_id <- image_ids[i]
        imageOutput(ns(paste0("clonal_img_", img_id)), height = "auto") %>% withSpinner(color = "darkred", type = 8)
      })
    })
    
    # Observe case_id changes and render each image with delay
    observe({
      req(case_id())
      image_ids <- clonal_mapping[clonal_mapping$case_id == case_id(), "image_id"]
      
      # Render each image using renderImage
      lapply(image_ids, function(img_id) {
        local({
          id_str <- paste0("clonal_img_", img_id)
          output[[id_str]] <- renderImage({
            # Add delay for smooth loading
            Sys.sleep(0.25)
            
            img_path <- sprintf("data/clonal/clonal_analysis-%02d.png", img_id)
            list(
              src = img_path,
              contentType = "image/png",
              width = "100%",
              height = "auto",
              style = "max-width: 900px; margin: 10px 0; border-radius: 6px;"
            )
          }, deleteFile = FALSE)
        })
      })
    })
  })
}
