packages <- c(
  "bioc::EnhancedVolcano",
  "cran::gprofiler2",
  "bioc::ComplexHeatmap",
  "bioc::InteractiveComplexHeatmap"
)

message("Installing Bioconductor packages with pak")
pak::pkg_install(packages, upgrade = FALSE)
