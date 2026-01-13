# Pediatric Thyroid Cancer Explorer

<!-- markdown-link-check-disable -->

[![Perform linting - Markdown](https://github.com/uab-cgds-worthey/ptc-explorer/actions/workflows/linting.yml/badge.svg)](https://github.com/uab-cgds-worthey/ptc-explorer/actions/workflows/linting.yml) <!-- markdown-link-check-enable -->

Pediatric Thyroid Cancer Explorer is an open-access resource for interactive exploration of rare pediatric differentiated thyroid cancer. It characterizes the whole-exome and transcriptome from 45 formalin-fixed paraffin-embedded (FFPE) surgical samples (tumor-normal) from pediatric patients with female predominance (<19 years).

## Requirements

- R (4.4.2)
- R Studio (optional) "<https://posit.co/download/rstudio-desktop/>"
- R Packages listed in global.R
- Minimum 1GB RAM

## How to install

Step 1: Clone this repo locally

``` bash
git clone "https://github.com/uab-cgds-worthey/ptc-explorer.git"
cd ptc-explorer
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

## How to run

Step 4: Run the app

``` r
shiny::runApp()
```

Or open global.R in R Studio and click "Run App" selecting "Run External"

## Application Features

The PTCE application provides an intuitive interface with the following main sections:

- **Home**: Overview of the study design, sample metadata, and clinical features
- **Gene Search**: Interactive gene expression and variant lookup
- **WES Variants**: Whole exome sequencing variant analysis
- **WES Additional**: Additional genomic variant analyses (Signature, Clonal and MSI)
- **RNA Analysis**: Downstream RNA-seq analysis including differential gene expression
- **RNA Fusion**: Analysis of fusion gene events
- **Download**: Access to latest versioned datasets in RDS format
- **User Guide**: Comprehensive documentation for end users
- **Developer Guide**: Technical documentation for developers and contributors
- **Team**: Information about the research team
- **Cite Us**: Citation information and formats for academic use

## Repo's directory structure

The directory structure below shows the nature of files/directories used in this repo.

``` sh
$ tree -a ptc-explorer/
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
├── assets/             <-  Media files and resources
│   └── ptc-explorer-walkthrough.mp4 <- Application walkthrough video
│
├── global.R            <-  Load libraries, datasets
│
├── server.R            <-  Backend functions for shiny components
│
├── ui.R                <-  Frontend functions for shiny components
│
├── user_interface/     <-  UI components for each page
│   ├── cite_us_ui.R    <- Citation information page layout
│   ├── contact_ui.R    <- Team information page layout
│   ├── developer_guide_ui.R <- Developer documentation page layout
│   ├── download_ui.R   <- Data download page layout
│   ├── gene_search_ui.R <- Gene search page layout
│   ├── home_ui.R       <- Home/landing page layout
│   ├── rna_downstream_ui.R <- RNA downstream analysis page layout
│   ├── rna_fusion_ui.R <- RNA fusion analysis page layout
│   ├── user_guide_ui.R <- User documentation page layout
│   ├── wes_additional_ui.R <- Additional WES analysis page layout
│   └── wes_variant_ui.R <- WES variant analysis page layout
│
├── modules/            <-  Reusable UI and server modules
│   ├── dt_mod.R        <- Enhanced DataTable components
│   ├── enrichr_mod.R   <- Pathway enrichment analysis
│   ├── fusion_filter_mod.R <- RNA fusion filtering
│   ├── gene_info_mod.R <- Gene annotation services
│   ├── gene_search_mod.R <- Gene search functionality
│   ├── meta_plots_mod.R <- Clinical metadata visualization
│   ├── profile_mod.R   <- Team photo and social media display
│   ├── reactable_mod.R <- Modern interactive tables
│   ├── variant_filter_mod.R <- Genomic variant filtering
│   └── volcano_mod.R   <- Interactive volcano plots
│
├── data/               <-  Sample datasets
│   ├── app_data_pack_*.rds <- Main application datasets
│   └── oncoplot_boxplot_*.rds <- Visualization data
│
├── R/                  <-  Utility functions
│   ├── load_components.R <- Component loading functions
│   └── utils.R         <- General utility functions
│
├── docs/               <-  Documentation files
│   ├── DYNAMIC_DATA_LOADING.md <- Dynamic data loading guide
│   ├── LINTING_GUIDE.md <- Code linting and formatting guide
│   ├── MODULES_COMPONENTS.md <- Module and component reference
│   ├── TECHNICAL_REFERENCE.md <- Developer technical reference
│   ├── TESTING_GUIDE.md <- Testing framework documentation
│   └── USER_GUIDE_MERGED.md <- Comprehensive user guide
│
├── www/                <-  Static web assets
│   ├── css/            <- Stylesheets
│   ├── img/            <- Images and figures
│   └── js/             <- JavaScript files
│
├── archive/            <-  Archived data and analysis files
│
├── dev/                <-  Development scripts and utilities
│
├── supplementary/      <-  Additional project materials
│
└── Dockerfile          <-  For containerization
```

## Contributing

We welcome contributions! [See the docs for guidelines](./CONTRIBUTING.md).

## Author

Samuel Bharti [:email:](mailto:sbharti@uab.edu) | Graduate Research Assistant

