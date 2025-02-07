contact_page <- fluidPage(
  fluidRow(class = "text-center",
           column(12,
                  h3("Pediatric Thyroid Cancer Explorer Development Team")
           )
  ),
  hr(),
  fluidRow(class = "text-center",
           column(4,
                  profiledivUI("gk")
           ),
           column(4,
                  profiledivUI("sb")
           ),
           column(4,
                  profiledivUI("lw")
           )
  )
)