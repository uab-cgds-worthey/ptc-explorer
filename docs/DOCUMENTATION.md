# Pediatric Thyroid Cancer Explorer - Complete Documentation

## Table of Contents

1. [Overview](#overview)
2. [System Requirements](#system-requirements)
3. [Installation Guide](#installation-guide)
4. [Application Architecture](#application-architecture)
5. [User Interface Guide](#user-interface-guide)
6. [Data Sources and Methodology](#data-sources-and-methodology)
7. [API Reference](#api-reference)
8. [Troubleshooting](#troubleshooting)
9. [Contributing](#contributing)
10. [Support](#support)

## Overview

The Pediatric Thyroid Cancer Explorer (PTCE) is an interactive web application built with R Shiny that provides comprehensive analysis and visualization tools for exploring pediatric differentiated thyroid cancer data. The application integrates whole-exome sequencing (WES) and RNA-sequencing data from 45 FFPE surgical samples (tumor-normal pairs) from pediatric patients (<19 years) with female predominance.

### Key Features

- **Interactive Data Exploration**: Browse and filter genomic variants, gene expression data, and clinical metadata
- **Advanced Visualizations**: Oncoplots, volcano plots, PCA plots, and enrichment analysis
- **Multi-omics Integration**: Combined analysis of genomic variants and transcriptomic data
- **RNA Fusion Detection**: Analysis of fusion genes detected from RNA-sequencing
- **Pathway Enrichment**: Functional annotation and pathway analysis
- **Data Export**: Download capabilities for all datasets and analyses

### Study Design

The application is built around a comprehensive study that includes:
- 45 pediatric patients with differentiated thyroid cancer
- Paired tumor-normal FFPE samples
- Whole-exome sequencing (WES) analysis
- RNA-sequencing analysis
- Clinical metadata and pathological annotations

## System Requirements

### Minimum Requirements

- **RAM**: 1GB minimum (2GB+ recommended)
- **Storage**: 500MB free disk space
- **Operating System**: Windows 10+, macOS 10.12+, or Linux (Ubuntu 18.04+)
- **Internet Connection**: Required for package installation and enrichment analysis

### Software Dependencies

- **R**: Version 4.4.2 or higher
- **RStudio**: Optional but recommended (latest version from <https://posit.co/download/rstudio-desktop/>)
- **Git**: For cloning the repository

## Installation Guide

### Step 1: Clone the Repository

```bash
git clone "https://github.com/uab-cgds-worthey/ptc-app.git"
cd ptc-app
```

### Step 2: Install R Dependencies

Launch R (or RStudio) and run the following commands:

```r
# Install CRAN packages
install.packages(c(
  "shiny", "shinybusy", "shinycssloaders", "shinyWidgets",
  "BiocManager", "dplyr", "reshape2", "scales", "stringr", 
  "RColorBrewer", "plotly", "DT", "reactable", "httr", 
  "jsonlite", "devtools"
))

# Install GitHub packages
devtools::install_github("wjawaid/enrichR")

# Install Bioconductor packages
BiocManager::install(c(
  "EnhancedVolcano", "gprofiler2", "ComplexHeatmap", 
  "InteractiveComplexHeatmap"
))
```

### Step 3: Launch the Application

#### Option A: Command Line
```r
shiny::runApp()
```

#### Option B: RStudio
1. Open `global.R` in RStudio
2. Click "Run App" button
3. Select "Run External" for better performance

### Troubleshooting Installation

**Common Issues:**

1. **Package Installation Failures**:
   - Update R to the latest version
   - Install packages one by one to identify problematic dependencies
   - Use `BiocManager::install()` for Bioconductor packages

2. **Memory Issues**:
   - Increase R memory limit: `memory.limit(size=4000)` on Windows
   - Close other applications to free up RAM

3. **Network Issues**:
   - Check internet connection for package downloads
   - Configure proxy settings if behind a firewall

## Application Architecture

### File Structure

```
ptc-app/
├── global.R              # Global variables, libraries, and data loading
├── server.R              # Server-side logic and reactive functions  
├── ui.R                  # Main UI structure and navigation
├── data/                 # Application datasets (.rds files)
├── user_interface/       # UI components for each tab
├── modules/              # Reusable Shiny modules
├── R/                    # Utility functions
├── www/                  # Static web assets (CSS, JS, images)
├── docs/                 # Documentation files
└── archive/              # Archived data and analysis files
```

### Key Components

#### 1. Global Environment (`global.R`)
- Loads required R packages
- Imports and processes main datasets
- Sets up global variables and constants
- Configures data structures for the application

#### 2. User Interface (`ui.R` + `user_interface/`)
- `ui.R`: Main navigation structure using `navbarPage`
- Individual UI files for each tab:
  - `home_ui.R`: Landing page with study overview
  - `gene_search_ui.R`: Gene search functionality
  - `oncoplot_ui.R`: Variant distribution visualization
  - `rna_ui.R`: RNA-seq differential expression analysis
  - `rna_fusion_ui.R`: RNA fusion analysis
  - `wes_ui.R`: WES signature and clonal analysis
  - `download_ui.R`: Data download interface
  - `docs_ui.R`: Documentation page
  - `contact_ui.R`: Team information

#### 3. Server Logic (`server.R` + `modules/`)
- `server.R`: Main server function with reactive logic
- Modular server functions:
  - `meta_plots_mod.R`: Clinical metadata visualization
  - `gene_search_mod.R`: Gene search and annotation
  - `volcano_mod.R`: Volcano plot generation
  - `enrichr_mod.R`: Pathway enrichment analysis
  - `variant_filter_mod.R`: Variant filtering logic
  - `fusion_filter_mod.R`: RNA fusion filtering
  - `reactable_mod.R`: Interactive table components

#### 4. Data Layer
- **Main Dataset**: `app_data_pack_2025-09-26.rds`
  - Sample metadata
  - Genomic variants
  - RNA fusion data
  - Differential expression results
  - Gene annotations

### Data Processing Pipeline

1. **Data Loading**: Raw datasets loaded in `global.R`
2. **Data Preprocessing**: Variables transformed and prepared for visualization
3. **Reactive Processing**: User inputs trigger reactive computations
4. **Visualization Rendering**: Processed data rendered as interactive plots/tables
5. **Export Functions**: Filtered data prepared for download

## User Interface Guide

### Navigation Structure

The application uses a tabbed interface with the following main sections:

#### 1. Home Tab
**Purpose**: Provides study overview and sample metadata exploration

**Components**:
- Study design flowchart
- Interactive clinical feature histograms
- Sample metadata table with sorting/filtering
- Patient demographic visualization

**Usage**:
- Select clinical variables from dropdown to visualize distributions
- Filter and sort the metadata table to explore patient characteristics
- Use the study design diagram to understand the analytical workflow

#### 2. Gene Search Tab
**Purpose**: Search and explore individual genes across all data types

**Components**:
- Gene search autocomplete input
- Gene annotation display
- Cross-dataset gene occurrence summary
- Links to external databases (NCBI, OMIM, etc.)

**Usage**:
- Type gene symbol or name to search
- View comprehensive gene information
- See gene presence across variants, expression, and fusion datasets

#### 3. Variants Distribution Tab
**Purpose**: Explore genomic variants through interactive oncoplot

**Key Features**:
- **Variants Table**: Filterable table of all identified variants
- **Interactive Oncoplot**: Heatmap visualization with metadata
- **Expression Integration**: Gene expression data alongside variants

**Filters Available**:
- Gene symbol
- Chromosome
- Phenotype (tumor/normal)
- Variant type (SNV, indel, etc.)
- Germline classification

**Usage Tips**:
- Use left-side filters to narrow down variants of interest
- Click on genes in the oncoplot to see detailed information
- Select rows to generate sub-heatmaps for focused analysis
- Hover over cells for detailed variant information

#### 4. DGE Analysis Tab (RNA-seq)
**Purpose**: Differential gene expression analysis and visualization

**Components**:

1. **PCA Analysis**:
   - Tumor vs. Normal comparison
   - Subtype-specific analysis
   - Batch effect visualization

2. **Differential Expression**:
   - Interactive volcano plots
   - Gene expression tables with statistics
   - Adjustable significance thresholds

3. **Enrichment Analysis**:
   - Pathway enrichment results
   - Multiple database sources (GO, KEGG, Reactome)
   - Searchable pathway tables

**Controls**:
- **P-value threshold**: Adjust significance cutoff
- **Log2 fold change**: Set magnitude threshold
- **Search functionality**: Find specific genes or pathways

#### 5. RNA-Fusions Analysis Tab
**Purpose**: Explore detected RNA fusion events

**Features**:
- Subtype-wise fusion distribution
- Fusion partner gene information
- Clinical correlation analysis
- Filterable fusion event table

#### 6. Signature, Clonal and MSI Tab
**Purpose**: WES-specific analyses including mutational signatures

**Components**:
- Mutational signature analysis
- Clonal evolution plots
- Microsatellite instability (MSI) status
- Additional WES-derived metrics

#### 7. Download Tab
**Purpose**: Export data and results for external analysis

**Available Downloads**:
- Complete datasets (ZIP format)
- R objects (.rds files)
- Filtered results based on current selections
- Analysis summaries and plots

**File Formats**:
- `.csv`: Tabular data
- `.rds`: R data objects
- `.png/.pdf`: High-resolution plots
- `.zip`: Compressed data packages

#### 8. Docs Tab
**Purpose**: User documentation and tutorials

**Contents**:
- Application overview
- Step-by-step tutorials
- Case study examples
- FAQ section

#### 9. Team Tab
**Purpose**: Information about the development team and collaborators

### Interactive Features

#### Search and Filter Capabilities
- **Global Search**: Find genes across all datasets
- **Advanced Filters**: Multiple criteria selection
- **Dynamic Updates**: Real-time filtering of visualizations

#### Plot Interactions
- **Zoom and Pan**: Navigate large datasets
- **Selection Tools**: Click/drag to select data points
- **Hover Information**: Detailed tooltips
- **Linked Views**: Selections propagate across related plots

#### Data Table Features
- **Sorting**: Click column headers to sort
- **Pagination**: Navigate large tables efficiently
- **Column Filtering**: Individual column search boxes
- **Export Options**: Download filtered results

## Data Sources and Methodology

### Sample Characteristics

- **Cohort Size**: 45 pediatric patients
- **Age Range**: <19 years
- **Sex Distribution**: Female predominance
- **Sample Type**: FFPE tumor-normal pairs
- **Histological Subtypes**:
  - PTC: Papillary Thyroid Carcinoma
  - FTC: Follicular Thyroid Carcinoma
  - NIFTP: Non-invasive Follicular Thyroid Neoplasm with Papillary-like nuclear features
  - FA: Follicular Adenoma
  - THY: Thyroidectomy samples
  - PTCplusTHY: Combined presentations

### Analytical Methods

#### Whole-Exome Sequencing (WES)
- **Platform**: Illumina sequencing
- **Coverage**: Average 100x depth
- **Variant Calling**: GATK best practices
- **Annotation**: VEP + custom databases
- **Quality Control**: Multiple QC metrics applied

#### RNA Sequencing
- **Platform**: Illumina RNA-seq
- **Library Prep**: TruSeq RNA Library Prep
- **Alignment**: STAR aligner
- **Quantification**: RSEM/featureCounts
- **Differential Expression**: DESeq2

#### Fusion Detection
- **Tools**: STAR-Fusion, FusionInspector
- **Validation**: Manual review of fusion calls
- **Filtering**: Remove likely false positives

#### Pathway Analysis
- **Databases**: GO, KEGG, Reactome, WikiPathways
- **Tools**: EnrichR, gprofiler2
- **Statistics**: Hypergeometric testing with FDR correction

### Data Processing Workflow

1. **Quality Control**
   - Sequence quality assessment
   - Adapter trimming
   - Contamination screening

2. **Alignment and Mapping**
   - Reference genome alignment
   - Post-alignment processing
   - Quality metrics calculation

3. **Variant Detection**
   - SNV and indel calling
   - Structural variant detection
   - Copy number analysis

4. **Expression Quantification**
   - Gene-level expression
   - Transcript-level analysis
   - Normalization procedures

5. **Statistical Analysis**
   - Differential expression testing
   - Pathway enrichment
   - Clinical correlation analysis

6. **Data Integration**
   - Multi-omics data merging
   - Consistent annotation
   - Quality control metrics

## API Reference

### Reactive Functions

The application uses several key reactive functions:

#### Data Filtering
```r
# Example reactive filter for variants
filtered_variants <- reactive({
  variants <- sample_variants
  
  if (!is.null(input$gene_filter)) {
    variants <- variants %>% filter(gene %in% input$gene_filter)
  }
  
  if (!is.null(input$chr_filter)) {
    variants <- variants %>% filter(chromosome %in% input$chr_filter)
  }
  
  return(variants)
})
```

#### Plot Generation
```r
# Example volcano plot reactive
volcano_plot <- reactive({
  data <- differential_expression_data()
  
  EnhancedVolcano(data,
    lab = rownames(data),
    x = 'log2FoldChange',
    y = 'padj',
    pCutoff = input$pvalue_threshold,
    FCcutoff = input$fc_threshold
  )
})
```

### Module Functions

#### Gene Search Module
```r
# UI function
gene_search_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectizeInput(ns("gene_select"), "Search Gene:", 
                   choices = NULL, options = list(...)
    ),
    verbatimTextOutput(ns("gene_info"))
  )
}

# Server function  
gene_search_server <- function(id, gene_list) {
  moduleServer(id, function(input, output, session) {
    # Server logic here
  })
}
```

#### Plot Modules
Each major plot type has its own module:
- `meta_plots_mod.R`: Clinical metadata visualizations
- `volcano_mod.R`: Volcano plot generation
- `enrichr_mod.R`: Pathway enrichment plots

### Data Structures

#### Main Data Object
```r
app_data_main <- list(
  meta = sample_metadata,           # Clinical/phenotype data
  variant = variant_data,           # WES variant calls
  fusion = rna_fusion_data,         # RNA fusion events
  t_vs_n = tumor_vs_normal_de,      # Differential expression: tumor vs normal
  ptc_vs_ftc = ptc_vs_ftc_de,      # Differential expression: PTC vs FTC
  meta_fact_col = factor_columns,   # Categorical clinical variables
  meta_num_col = numeric_columns,   # Continuous clinical variables
  all_genes = complete_gene_list    # Master gene list
)
```

#### Key Data Formats

**Variant Data Structure**:
```r
# Columns: gene, chromosome, position, ref, alt, consequence, 
#          clinical_significance, participant_id, sample_type, etc.
```

**Expression Data Structure**:
```r
# Columns: gene, baseMean, log2FoldChange, lfcSE, stat, pvalue, padj
```

**Metadata Structure**:
```r
# Columns: participant_id, age, sex, subtype, ti_rads_score, etc.
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Application Won't Start

**Symptoms**: Error messages when launching the app

**Possible Causes**:
- Missing R packages
- Incorrect working directory
- Data file corruption

**Solutions**:
```r
# Check if all packages are installed
required_packages <- c("shiny", "DT", "plotly", "dplyr")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(missing_packages)) install.packages(missing_packages)

# Check working directory
getwd()  # Should be the ptc-app directory

# Verify data files exist
file.exists("data/app_data_pack_2025-09-26.rds")
```

#### 2. Slow Performance

**Symptoms**: Long loading times, unresponsive interface

**Possible Causes**:
- Insufficient RAM
- Large dataset operations
- Network latency for enrichment analysis

**Solutions**:
- Increase R memory limit
- Filter data before complex operations
- Use "Run External" mode in RStudio
- Close other memory-intensive applications

#### 3. Plot Rendering Issues

**Symptoms**: Plots not displaying or appearing corrupted

**Solutions**:
```r
# Clear plot cache
if (dev.cur() > 1) dev.off()

# Check graphics device
capabilities()

# Update graphics packages
update.packages(c("plotly", "ggplot2"))
```

#### 4. Data Table Problems

**Symptoms**: Tables not loading or filtering incorrectly

**Solutions**:
- Check DT package version
- Clear browser cache
- Verify data format consistency

#### 5. Download Failures

**Symptoms**: Downloads fail or produce empty files

**Debugging Steps**:
```r
# Check data object structure
str(filtered_data())

# Verify file write permissions
file.access(".", mode = 2)  # Check write permission

# Test download function manually
write.csv(sample_data, "test_download.csv")
```

### Error Messages and Meanings

| Error Message | Cause | Solution |
|---------------|-------|----------|
| "Object not found" | Missing data file | Check data directory and file paths |
| "Package not installed" | Missing R package | Install required packages |
| "Memory allocation error" | Insufficient RAM | Increase memory limit or filter data |
| "Connection timeout" | Network issues | Check internet connection |
| "Invalid input" | Wrong data format | Verify input data structure |

### Performance Optimization

#### For Large Datasets
- Use data filtering before complex operations
- Implement pagination for large tables
- Use reactive debouncing for frequent updates
- Cache expensive computations

#### For Slow Networks
- Implement progress indicators
- Use async processing where possible
- Optimize image and asset loading
- Enable data compression

#### Memory Management
```r
# Monitor memory usage
pryr::mem_used()

# Clean up large objects
rm(large_object)
gc()  # Garbage collection
```

### Browser Compatibility

**Supported Browsers**:
- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

**Known Issues**:
- Internet Explorer: Not supported
- Safari < 13: Limited interactive features
- Mobile browsers: Limited functionality on small screens

### Logging and Debugging

Enable detailed logging for troubleshooting:
```r
# In global.R, add:
options(shiny.trace = TRUE)
options(shiny.error = browser)

# For detailed reactivity debugging
options(shiny.reactlog = TRUE)
reactlog::reactlog_enable()
```

## Contributing

We welcome contributions to the Pediatric Thyroid Cancer Explorer! Please see our [Contributing Guidelines](CONTRIBUTING.md) for detailed information.

### Development Setup

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/ptc-app.git
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Install development dependencies**:
   ```r
   install.packages(c("testthat", "devtools", "roxygen2"))
   ```

### Coding Standards

- Follow [Google's R Style Guide](https://google.github.io/styleguide/Rguide.html)
- Use meaningful variable names
- Comment complex logic
- Test new features thoroughly

### Submission Process

1. **Test your changes** locally
2. **Update documentation** if necessary
3. **Submit a pull request** with clear description
4. **Respond to review feedback** promptly

### Types of Contributions

- **Bug Reports**: Use GitHub issues with detailed reproduction steps
- **Feature Requests**: Propose new functionality with use cases
- **Code Contributions**: Bug fixes, new features, performance improvements
- **Documentation**: Improve user guides, API documentation, examples

## Support

### Getting Help

1. **Check Documentation**: Review this guide and the in-app docs
2. **Search Issues**: Look for similar problems on GitHub
3. **Create an Issue**: Report bugs or request features
4. **Contact Team**: Email the development team for urgent issues

### Contact Information

- **Primary Contact**: Samuel Bharti (sbharti@uab.edu)
- **GitHub Issues**: [https://github.com/uab-cgds-worthey/ptc-app/issues](https://github.com/uab-cgds-worthey/ptc-app/issues)
- **Institution**: UAB Center for Computational Genomics and Data Science

### Citing the Application

If you use this application in your research, please cite:

```
Bharti, S., et al. (2025). Pediatric Thyroid Cancer Explorer: An Interactive 
Resource for Exploring Pediatric Differentiated Thyroid Cancer. 
UAB Center for Computational Genomics and Data Science.
```

### License

This project is licensed under the MIT License. See the [LICENSE.md](LICENSE.md) file for details.

### Acknowledgments

- UAB Center for Computational Genomics and Data Science
- Research participants and families
- Open-source R community
- Bioconductor project

---

**Last Updated**: September 27, 2025  
**Version**: 2.0  
**Documentation Version**: 1.0