# Pediatric Thyroid Cancer Explorer

Pediatric Thyroid Cancer Explorer is an open-access resource for interactive exploration of rare pediatric differentiated thyroid cancer. It characterizes the whole-exome and transcriptome from 45 formalin-fixed paraffin-embedded (FFPE) surgical samples (tumor-normal) from pediatric patients with female predominance (\<19 years).

# Current features included:

-   Sample Feature Exploration
-   Variant Analysis
-   Interactive Variant-Expression Oncoplot
-   Differentially Expressed Gene (DEG) Analysis
-   Enrichment Analysis
-   Gene Fusion Analysis
-   Mutational Signature Analysis
-   Clonal Evolution Analysis
-   MSI Analysis

# Deployment

The latest version can be accessed via shinyapps.io at --- link.

------------------------------------------------------------------------

# How to run this App locally?

# Requirements:

-   R (4.4.2)
-   R Packages listed in global.R
-   1GB RAM

Step 1: Clone this repo locally `git clone "https://github.com/uab-cgds-worthey/ptc-app"`

Step 2: Download and Install R and R Studio (optional) "<https://posit.co/download/rstudio-desktop/>"

Step 3: Install R packages listed in global.R

Step 4: Run `shiny::runApp()` in console or open global.R in R Studio and click "Run App" selecting "Run External"

------------------------------------------------------------------------

# Contribution

------------------------------------------------------------------------

Template developed by \@[samuelbharti](https://github.com/SamuelBharti). Use R package available at [samuelbharti/peacock](https://github.com/samuelbharti/peacock) for local development.
