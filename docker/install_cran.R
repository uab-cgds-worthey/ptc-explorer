packages <- c(
  "markdown",
  "shinybusy",
  "shinycssloaders",
  "shinyWidgets",
  "dplyr",
  "reshape2",
  "scales",
  "stringr",
  "RColorBrewer",
  "plotly",
  "DT",
  "reactable",
  "httr",
  "jsonlite"
)

message("Installing CRAN packages with pak")
pak::pkg_install(packages, upgrade = FALSE)
