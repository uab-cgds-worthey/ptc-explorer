download_page <- fluidPage(fluidRow(class = "text-center",
                                    column(
                                      12,
                                      h3("Download options for dataset:"),
                                      br(),
                                      div(
                                        class = "text-center",
                                        a(
                                          href = "alldata.zip",
                                          "All dataset zip",
                                          download = NA,
                                          target = "_blank"
                                        ),
                                        br(),
                                        a(
                                          href = "alldata.rds",
                                          "All dataset RDS",
                                          download = NA,
                                          target = "_blank"
                                        )
                                      )
                                    )))
