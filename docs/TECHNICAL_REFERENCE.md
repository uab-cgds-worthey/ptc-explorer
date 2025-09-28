# Pediatric Thyroid Cancer Explorer - Technical Reference

## Architecture Overview

### Technology Stack

- **Framework**: R Shiny (reactive web framework)
- **Backend**: R (statistical computing)
- **Frontend**: HTML5, CSS3, JavaScript
- **Visualization**: plotly, ggplot2, ComplexHeatmap
- **Data Processing**: dplyr, data.table
- **UI Components**: shinydashboard, DT, reactable

### Application Structure

```
ptc-app/
├── global.R                 # Global configuration and data loading
├── server.R                 # Main server logic
├── ui.R                     # Main UI structure
├── data/                    # Application datasets
│   └── app_data_pack_*.rds  # Main data bundle
├── modules/                 # Reusable Shiny modules
├── user_interface/          # Tab-specific UI components  
├── R/                       # Utility functions
├── www/                     # Static web assets
└── docs/                    # Documentation files
```

## Data Architecture

### Main Data Object Structure

```r
app_data_main <- list(
  meta = tibble,              # Sample metadata (n=90, 45 tumor-normal pairs)
  variant = tibble,           # Genomic variants (n=variable)
  fusion = tibble,            # RNA fusion events (n=variable)
  t_vs_n = tibble,           # DE results: tumor vs normal
  ptc_vs_ftc = tibble,       # DE results: PTC vs FTC
  meta_fact_col = character, # Factor column names
  meta_num_col = character,  # Numeric column names
  all_genes = character      # Complete gene universe
)
```

### Data Schemas

#### Sample Metadata (`meta`)
```r
tibble::tibble(
  participant_id = character(),    # Unique patient identifier
  sample_id = character(),         # Unique sample identifier
  sample_type = factor(),          # "tumor" or "normal"
  age_at_diagnosis = numeric(),    # Age in years
  sex = factor(),                  # "Male" or "Female"
  subtype = factor(),              # Cancer subtype classification
  ti_rads_score = numeric(),       # TI-RADS imaging score
  batch = factor(),                # Sequencing batch
  # Additional clinical variables...
)
```

#### Variant Data (`variant`)
```r
tibble::tibble(
  gene = character(),              # Gene symbol
  chromosome = character(),        # Chromosome (1-22, X, Y)
  position = numeric(),            # Genomic position
  ref = character(),               # Reference allele
  alt = character(),               # Alternate allele
  consequence = character(),       # Variant consequence
  clinical_significance = factor(), # Pathogenic/VUS/Benign
  participant_id = character(),    # Links to metadata
  sample_type = factor(),          # Tumor/Normal
  vaf = numeric(),                 # Variant allele frequency
  depth = numeric(),               # Read depth
  # Additional annotation columns...
)
```

#### Expression Data (`t_vs_n`, `ptc_vs_ftc`)
```r
tibble::tibble(
  gene = character(),              # Gene symbol
  baseMean = numeric(),            # Mean expression across samples
  log2FoldChange = numeric(),      # Log2 fold change
  lfcSE = numeric(),               # Standard error of LFC
  stat = numeric(),                # Test statistic
  pvalue = numeric(),              # Nominal p-value
  padj = numeric(),                # Adjusted p-value (FDR)
  # Additional columns may include confidence intervals
)
```

#### RNA Fusion Data (`fusion`)
```r
tibble::tibble(
  sample_id = character(),         # Sample identifier
  fusion_name = character(),       # Gene1--Gene2 format
  gene1 = character(),             # 5' fusion partner
  gene2 = character(),             # 3' fusion partner
  breakpoint1 = character(),       # Genomic breakpoint 1
  breakpoint2 = character(),       # Genomic breakpoint 2
  supporting_reads = numeric(),     # Evidence supporting fusion
  confidence = character(),         # High/Medium/Low confidence
  subtype = factor()               # Cancer subtype
)
```

## Module Architecture

### Core Modules

#### 1. Meta Plots Module (`meta_plots_mod.R`)

**Purpose**: Generate clinical metadata visualizations

```r
# UI Component
meta_plots_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("variable"), "Select Variable:", choices = NULL),
    plotlyOutput(ns("plot"))
  )
}

# Server Component  
meta_plots_server <- function(id, meta_data, factor_cols, numeric_cols) {
  moduleServer(id, function(input, output, session) {
    # Update variable choices
    observe({
      updateSelectInput(session, "variable", 
                       choices = c(factor_cols, numeric_cols))
    })
    
    # Generate plot
    output$plot <- renderPlotly({
      req(input$variable)
      # Plot generation logic...
    })
  })
}
```

#### 2. Gene Search Module (`gene_search_mod.R`)

**Purpose**: Provide gene search and annotation functionality

```r
# Key Functions
gene_search_ui <- function(id)
gene_search_server <- function(id, gene_list, annotation_data)

# Features
- Autocomplete gene search
- Gene annotation display  
- Cross-dataset presence checking
- External database links
```

#### 3. Volcano Plot Module (`volcano_mod.R`)

**Purpose**: Interactive volcano plots for differential expression

```r
# Configuration Options
volcano_config <- list(
  pvalue_threshold = 0.05,      # Default p-value cutoff
  fc_threshold = 1.0,           # Default fold change cutoff
  point_size = 2,               # Plot point size
  label_size = 10,              # Gene label size
  max_labels = 20               # Maximum gene labels
)
```

#### 4. Enrichment Analysis Module (`enrichR_mod.R`)

**Purpose**: Pathway enrichment visualization and analysis

```r
# Supported Databases
enrichr_databases <- c(
  "GO_Biological_Process_2023",
  "GO_Molecular_Function_2023", 
  "KEGG_2021_Human",
  "Reactome_2022",
  "WikiPathway_2023_Human"
)
```

### Utility Functions

#### Data Processing (`R/utils.R`)

```r
# Gene annotation functions
annotate_genes <- function(gene_list, species = "human") {
  # Gene annotation logic
}

# Data filtering functions  
filter_variants <- function(variants, filters = list()) {
  # Variant filtering logic
}

# Statistical functions
calculate_enrichment <- function(gene_set, background, database) {
  # Enrichment analysis logic
}
```

#### Data Loading (`R/load_components.R`)

```r
# Component loading functions
load_ui_components <- function() {
  # Load all UI files
}

load_server_modules <- function() {
  # Load all server modules  
}
```

## Reactive Programming Patterns

### Data Flow Architecture

```r
# Input Processing
user_input -> reactive_filter -> processed_data -> visualization

# Example Implementation
filtered_data <- reactive({
  data <- original_data
  
  # Apply user filters
  if (!is.null(input$gene_filter)) {
    data <- data %>% filter(gene %in% input$gene_filter)
  }
  
  if (!is.null(input$pvalue_filter)) {
    data <- data %>% filter(padj <= input$pvalue_filter)
  }
  
  return(data)
})

# Downstream usage
output$plot <- renderPlotly({
  plot_data <- filtered_data()
  # Generate visualization
})
```

### Performance Optimization

#### Reactive Debouncing
```r
# Prevent excessive computation from rapid input changes
debounced_input <- reactive({
  input$text_input
}) %>% debounce(1000)  # Wait 1 second after last input
```

#### Caching Expensive Operations
```r
# Cache computationally expensive operations
enrichment_results <- reactive({
  gene_list <- selected_genes()
  
  # Use cached results if gene list hasn't changed
  if (identical(gene_list, cache$last_genes)) {
    return(cache$results)
  }
  
  # Perform expensive computation
  results <- perform_enrichment_analysis(gene_list)
  
  # Update cache
  cache$last_genes <- gene_list
  cache$results <- results
  
  return(results)
})
```

#### Async Processing
```r
# For long-running operations
library(promises)
library(future)

# Configure parallel processing
plan(multisession)

# Async reactive
async_results <- reactive({
  future({
    # Long-running computation
    expensive_analysis(input_data())
  }) %...>% (function(result) {
    # Process results
    return(result)
  })
})
```

## Visualization Components

### Interactive Oncoplot

**Technology**: ComplexHeatmap + InteractiveComplexHeatmap

```r
# Core implementation
generate_oncoplot <- function(variant_data, clinical_data, expression_data) {
  
  # Create mutation matrix
  mut_mat <- variant_data %>%
    select(gene, participant_id, variant_type) %>%
    pivot_wider(names_from = participant_id, 
                values_from = variant_type,
                values_fill = "") %>%
    column_to_rownames("gene") %>%
    as.matrix()
  
  # Define color mapping
  col_mapping <- c(
    "SNV" = "#1f77b4",
    "Indel" = "#ff7f0e", 
    "CNV" = "#2ca02c"
  )
  
  # Create annotations
  clinical_annotation <- HeatmapAnnotation(
    subtype = clinical_data$subtype,
    age = clinical_data$age_at_diagnosis,
    col = list(
      subtype = subtype_colors,
      age = colorRamp2(c(0, 18), c("white", "red"))
    )
  )
  
  # Generate heatmap
  ht <- oncoPrint(
    mut_mat,
    col = col_mapping,
    top_annotation = clinical_annotation,
    show_column_names = FALSE,
    show_row_names = TRUE
  )
  
  return(ht)
}
```

### Volcano Plots

**Technology**: EnhancedVolcano + plotly

```r
create_volcano_plot <- function(de_results, 
                               pCutoff = 0.05,
                               FCcutoff = 1.0) {
  
  p <- EnhancedVolcano(
    de_results,
    lab = rownames(de_results),
    x = 'log2FoldChange',
    y = 'padj',
    pCutoff = pCutoff,
    FCcutoff = FCcutoff,
    pointSize = 2.0,
    labSize = 4.0,
    col = c('grey30', 'forestgreen', 'royalblue', 'red2'),
    colAlpha = 0.7,
    legendPosition = 'bottom',
    legendLabSize = 12,
    legendIconSize = 4.0
  )
  
  # Convert to interactive plotly
  ggplotly(p, tooltip = c("text"))
}
```

## Database Integration

### External API Calls

#### Gene Annotation APIs
```r
# NCBI Gene API
get_gene_info <- function(gene_symbol) {
  url <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/",
                "esearch.fcgi?db=gene&term=", gene_symbol, 
                "[gene]&retmode=json")
  
  response <- httr::GET(url)
  content <- httr::content(response, as = "parsed")
  
  return(content)
}

# Enrichr API  
perform_enrichr_analysis <- function(gene_list, databases) {
  # Submit gene list
  enrichr_data <- enrichR::enrichr(gene_list, databases)
  
  # Process results
  results <- enrichr_data %>%
    bind_rows(.id = "database") %>%
    filter(Adjusted.P.value < 0.05) %>%
    arrange(Adjusted.P.value)
    
  return(results)
}
```

### Local Database Queries

```r
# Gene annotation lookup
lookup_gene_annotation <- function(gene_symbols, annotation_db) {
  annotations <- annotation_db %>%
    filter(symbol %in% gene_symbols) %>%
    select(symbol, description, chromosome, start, end, strand)
    
  return(annotations)
}
```

## Configuration Management

### Application Settings

```r
# global.R configuration
app_config <- list(
  # Data settings
  data_version = "2025-09-26",
  max_variants_display = 10000,
  
  # UI settings  
  default_page_size = 25,
  max_plot_points = 5000,
  
  # Analysis settings
  default_pvalue_threshold = 0.05,
  default_fc_threshold = 1.0,
  
  # Performance settings
  enable_caching = TRUE,
  cache_timeout = 3600,
  
  # External APIs
  enrichr_timeout = 30,
  ncbi_timeout = 10
)
```

### Environment Variables

```r
# Optional environment configuration
get_config_value <- function(key, default = NULL) {
  env_value <- Sys.getenv(paste0("PTCE_", toupper(key)))
  if (env_value == "") {
    return(default)
  }
  return(env_value)
}

# Usage
database_url <- get_config_value("database_url", "local_file.rds")
```

## Testing Framework

### Unit Tests

```r
# tests/testthat/test-data-processing.R
library(testthat)

test_that("variant filtering works correctly", {
  # Setup test data
  test_variants <- tibble(
    gene = c("BRAF", "RET", "TPO"),
    participant_id = c("P001", "P001", "P002"),
    pvalue = c(0.01, 0.1, 0.001)
  )
  
  # Test filtering
  filtered <- filter_variants(test_variants, 
                             list(pvalue_threshold = 0.05))
  
  # Assertions
  expect_equal(nrow(filtered), 2)
  expect_true(all(filtered$pvalue <= 0.05))
})
```

### Integration Tests

```r
# tests/testthat/test-app-integration.R
test_that("app launches without errors", {
  # Test app startup
  expect_no_error({
    source("global.R")
    ui <- source("ui.R")$value
    server <- source("server.R")$value
  })
})
```

## Deployment Options

### Local Deployment

```r
# Standard local launch
shiny::runApp(port = 3838, host = "127.0.0.1")

# With custom options
options(shiny.maxRequestSize = 100*1024^2)  # 100MB max upload
shiny::runApp(launch.browser = TRUE)
```

### Server Deployment

#### Shiny Server Configuration

```nginx
# /etc/shiny-server/shiny-server.conf
server {
  listen 3838;
  location /ptc-app {
    site_dir /srv/shiny-server/ptc-app;
    log_dir /var/log/shiny-server;
    directory_index on;
  }
}
```

#### Docker Deployment

```dockerfile
# Dockerfile
FROM rocker/shiny:4.4.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Install R packages
RUN R -e "install.packages(c('shiny', 'DT', 'plotly', 'dplyr'))"

# Copy application
COPY . /srv/shiny-server/ptc-app/

# Expose port
EXPOSE 3838

# Run application
CMD ["/usr/bin/shiny-server"]
```

## Security Considerations

### Input Validation

```r
# Sanitize user inputs
validate_gene_input <- function(gene_list) {
  # Remove special characters
  cleaned <- gsub("[^A-Za-z0-9,-]", "", gene_list)
  
  # Split and validate
  genes <- strsplit(cleaned, ",")[[1]]
  genes <- trimws(genes)
  
  # Check against known gene list
  valid_genes <- genes[genes %in% all_genes_main]
  
  return(valid_genes)
}
```

### Data Access Control

```r
# Implement access logging
log_access <- function(session, action, resource) {
  log_entry <- data.frame(
    timestamp = Sys.time(),
    session_id = session$token,
    action = action,
    resource = resource,
    ip_address = session$clientData$url_hostname
  )
  
  # Write to log file
  write.table(log_entry, "access.log", append = TRUE)
}
```

## Performance Monitoring

### Resource Usage Tracking

```r
# Monitor memory usage
monitor_memory <- function() {
  mem_info <- pryr::mem_used()
  
  if (mem_info > 1e9) {  # > 1GB
    warning("High memory usage detected: ", 
            format(mem_info, units = "MB"))
  }
  
  return(mem_info)
}

# Monitor reactive execution
monitor_reactives <- function() {
  if (getOption("shiny.reactlog", FALSE)) {
    reactlog::reactlog_show()
  }
}
```

### Error Logging

```r
# Global error handler
options(shiny.error = function() {
  error_info <- list(
    timestamp = Sys.time(),
    error = geterrmessage(),
    session_info = sessionInfo()
  )
  
  # Log error
  saveRDS(error_info, paste0("error_", Sys.Date(), ".rds"))
  
  # User-friendly error message
  showNotification("An error occurred. Please try again or contact support.",
                   type = "error")
})
```

## Maintenance and Updates

### Data Update Procedures

```r
# Script to update main data file
update_app_data <- function(new_data_path) {
  # Validate new data structure
  validate_data_structure(new_data_path)
  
  # Backup current data
  backup_current_data()
  
  # Update data file
  file.copy(new_data_path, "data/app_data_pack_current.rds")
  
  # Update version info
  update_version_info()
  
  # Test application
  test_app_functionality()
}
```

### Version Control

```r
# Version information
app_version <- list(
  version = "2.0.0",
  release_date = "2025-09-27",
  data_version = "2025-09-26",
  r_version = R.version.string,
  package_versions = sessionInfo()$otherPkgs
)

# Save version info
saveRDS(app_version, "version_info.rds")
```

This technical reference provides comprehensive documentation for developers working with or extending the Pediatric Thyroid Cancer Explorer application. It covers all major architectural components, data structures, and implementation patterns used in the application.