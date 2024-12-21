# Pediatric Thyroid Cancer Explorer

<!-- markdown-link-check-disable -->

[![Perform linting - Markdown](https://github.com/uab-cgds-worthey/cgds_repo_template/actions/workflows/linting.yml/badge.svg)](https://github.com/uab-cgds-worthey/cgds_repo_template/actions/workflows/linting.yml) <!-- markdown-link-check-enable -->

Pediatric Thyroid Cancer Explorer is an open-access resource for interactive exploration of rare pediatric differentiated thyroid cancer. It characterizes the whole-exome and transcriptome from 45 formalin-fixed paraffin-embedded (FFPE) surgical samples (tumor-normal) from pediatric patients with female predominance (\<19 years).

## Requirements

-   R (4.4.2)
-   R Studio (optional) "<https://posit.co/download/rstudio-desktop/>"
-   R Packages listed in global.R
-   Minimum 1GB RAM

## How to run

Step 1: Clone this repo locally

``` bash
git clone "https://github.com/uab-cgds-worthey/ptc-app.git"
cd ptc-app
```

Step 2: Run R in terminal or skip this step if using R Studio

``` bash
R
```

Step 3: Install R packages

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

## Repo's directory structure

The directory structure below shows the nature of files/directories used in this repo.

``` sh
$ tree -a ptc-app/
├── CONTRIBUTING.md   <- Contribution guidelines
│
├── LICENSE.md        <- License for the repo
│
├── README.md
│
├── .gitignore        <- Specifies intentionally untracked files to ignore by git
│
├── .markdownlint.json  <- Markdown linting config
│
├── global.R            <-  Load libraries, datasets
│
├── server.R            <-  Backend functions for shiny components
│
├── ui.R                <-  Frontend functions for shiny components
│
├── userInterface/      <-  UI components for each page
│
├── modules/            <-  UI and server modules
│
├── data/               <-  Sample datasets
│
├── R/                  <-  Utility functions
│
├── Dockerfile          <-  For containerization
│
├── .github
│   ├── ISSUE_TEMPLATE            <- Github issue templates
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── PULL_REQUEST_TEMPLATE     <- Github PR templates
│   │   └── pull_request_template.md
│   └── workflows                 <- Github actions workflows for automated processes (eg. linting, etc)
│       └── linting.yml
```

## Contributing

We welcome contributions! [See the docs for guidelines](./CONTRIBUTING.md).
