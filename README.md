# Pediatric Thyroid Cancer Explorer

Pediatric Thyroid Cancer Explorer is an open-access resource for interactive exploration of rare pediatric differentiated thyroid cancer. It characterizes the whole-exome and transcriptome from 45 formalin-fixed paraffin-embedded (FFPE) surgical samples (tumor-normal) from pediatric patients with female predominance (\<19 years).

## Current analysis included:

-   Sample Feature Exploration
-   Variant Analysis
-   Interactive Variant-Expression Oncoplot
-   Differentially Expressed Gene (DEG) Analysis
-   Enrichment Analysis
-   Gene Fusion Analysis
-   Mutational Signature Analysis
-   Clonal Evolution Analysis
-   MSI Analysis

## Deployment

The latest version can be accessed via shinyapps.io at --- link.

------------------------------------------------------------------------

## How to run this App locally?

### Requirements:

-   R (4.4.2)
-   R Studio (optional) "<https://posit.co/download/rstudio-desktop/>"
-   R Packages listed in global.R
-   1GB RAM

Step 1: Clone this repo locally

``` bash
git clone "https://github.com/uab-cgds-worthey/ptc-app.git"
cd ptc-app
```

Step 2: Install R packages

``` r
install.packages(c("shinybusy","shinycssloaders","shinyWidgets","BiocManager","dplyr","reshape2","scales","stringr","RColorBrewer","plotly","DT","reactable","httr","jsonlite", "devtools"))
devtools::install_github("wjawaid/enrichR")
BiocManager::install(c("EnhancedVolcano","gprofiler2","ComplexHeatmap","InteractiveComplexHeatmap"))
```

Step 4: Run the app

``` r
shiny::runApp()
```

Or open global.R in R Studio and click "Run App" selecting "Run External"

------------------------------------------------------------------------

## Developer Guide

1.  Codebase Overview:

``` markdown
├── global.R             # Load libraries, datasets
├── server.R             # Backend functions for shiny components
├── ui.R                 # Frontend functions for shiny components
├── userInterface/       # UI components for each page
├── modules/             # UI and server modules
├── data/                # Sample datasets
├── R/                   # Utility functions
├── Dockerfile           # For containerization
└── README.md            # Documentation
```

2.  Docker build:

``` bash
docker build -t ptc-app-dev .
docker run -p 3838:3838 ptc-app-dev
```

3.  Contribution Guidelines:

------------------------------------------------------------------------

Shiny app template developed using R package available at [samuelbharti/peacock](https://github.com/samuelbharti/peacock).
