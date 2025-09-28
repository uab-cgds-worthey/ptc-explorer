# Pediatric Thyroid Cancer Explorer - Module and Component Reference

## Overview

This document explains the organization and purpose of the modular components in the Pediatric Thyroid Cancer Explorer application. The application follows a modular architecture with reusable components separated into two main directories: `modules/` (server-side logic and UI components) and `user_interface/` (tab-specific UI layouts).

## Table of Contents

1. [Modules Directory](#modules-directory)
2. [User Interface Directory](#user-interface-directory)
3. [File Organization Principles](#file-organization-principles)

---

## Modules Directory

The `modules/` directory contains reusable Shiny modules that provide both UI components and server-side logic. Each module follows the standard Shiny module pattern with `_ui()` and `_server()` functions.

### Data Table Modules

#### `dt_mod.R` - Enhanced DataTable Components
**Purpose**: Provides interactive data tables with export functionality, filtering, and custom styling.

**Key Features**:
- Responsive data tables with pagination
- Export options (Excel, PDF, CSV)
- Column-based filtering and sorting
- Loading spinners and validation
- Custom styling with cell formatting

**Usage**: Used throughout the app for displaying variant tables, metadata tables, and analysis results.

#### `reactable_mod.R` - Modern Interactive Tables
**Purpose**: Creates modern, highly interactive tables with advanced filtering and custom cell rendering.

**Key Features**:
- Advanced column formatting and styling
- Interactive filtering and grouping
- Custom cell renderers (links, formatting)
- Expandable rows and nested data
- Mobile-responsive design

**Usage**: Primarily used for the main sample metadata table on the Home page.

### Visualization Modules

#### `volcano_mod.R` - Interactive Volcano Plots
**Purpose**: Generates interactive volcano plots for differential gene expression analysis.

**Key Features**:
- Dynamic threshold adjustment (p-value and fold change)
- Gene selection and highlighting
- Hover tooltips with gene information
- Export functionality for plots
- Color-coded significance levels

**Usage**: Used in the DGE Analysis tab for both tumor vs normal and PTC vs FTC comparisons.

#### `meta_plots_mod.R` - Clinical Metadata Visualization
**Purpose**: Creates various plot types for exploring clinical metadata and patient characteristics.

**Key Features**:
- Histogram plots for continuous variables
- Bar charts for categorical variables
- Dynamic variable selection
- Interactive plotly integration
- Automatic plot type selection based on data type

**Usage**: Used on the Home page for exploring patient demographics and clinical features.

### Analysis Modules

#### `gene_search_mod.R` - Gene Search and Annotation
**Purpose**: Provides comprehensive gene search functionality with cross-dataset presence checking.

**Key Features**:
- Autocomplete gene search across all datasets
- Gene annotation display with external database links
- Cross-dataset presence indicators (variants, expression, fusions)
- Gene category filtering (all genes vs candidate genes)
- Integration with NCBI, OMIM, and other databases

**Usage**: Powers the Gene Search tab and provides gene lookup throughout the application.

#### `enrichr_mod.R` - Pathway Enrichment Analysis
**Purpose**: Performs and visualizes pathway enrichment analysis using multiple databases.

**Key Features**:
- Integration with EnrichR API
- Multiple pathway databases (GO, KEGG, Reactome, etc.)
- Interactive pathway tables with search functionality
- Pathway visualization and export
- Gene-to-pathway mapping

**Usage**: Used in the DGE Analysis tab for functional annotation of differentially expressed genes.

#### `variant_filter_mod.R` - Genomic Variant Filtering
**Purpose**: Provides advanced filtering capabilities for genomic variants with multiple criteria.

**Key Features**:
- Multi-criteria filtering (gene, chromosome, variant type, etc.)
- Clinical significance filtering (pathogenic, VUS, benign)
- VAF (Variant Allele Frequency) range filtering
- Sample type filtering (tumor vs normal)
- Real-time filter application with counts

**Usage**: Used in the Variants Distribution tab for filtering the oncoplot and variant tables.

#### `fusion_filter_mod.R` - RNA Fusion Filtering
**Purpose**: Specialized filtering for RNA fusion events with fusion-specific criteria.

**Key Features**:
- Fusion partner gene filtering
- Confidence level filtering
- Supporting read count thresholds
- Subtype-specific filtering
- Recurrence frequency analysis

**Usage**: Used in the RNA-Fusions Analysis tab for exploring fusion events.

### Utility Modules

#### `profile_mod.R` - Performance Monitoring
**Purpose**: Monitors application performance and resource usage during development.

**Key Features**:
- Memory usage tracking
- Reactive execution timing
- Performance bottleneck identification
- Resource usage alerts
- Development-time profiling tools

**Usage**: Primarily used during development and testing for performance optimization.

#### `gene_info_mod.R` - Gene Annotation Services
**Purpose**: Retrieves additional gene information from external databases and APIs.

**Key Features**:
- External API integration (NCBI, OMIM, HGNC)
- Gene annotation caching
- Error handling for API failures
- Standardized gene information formatting
- Batch gene annotation processing

**Usage**: Supporting module used by gene_search_mod.R and other components requiring gene annotations.

---

## User Interface Directory

The `user_interface/` directory contains the UI layouts for each major tab of the application. Each file defines the complete UI structure for its corresponding tab.

### Tab UI Components

#### `home_ui.R` - Landing Page Layout
**Purpose**: Defines the layout for the Home tab with study overview and metadata exploration.

**Components**:
- Study design flowchart display
- Clinical feature selection and histogram visualization
- Sample metadata table with interactive features
- Welcome text and study description

#### `gene_search_ui.R` - Gene Search Interface
**Purpose**: Creates the layout for the Gene Search tab with search functionality and results display.

**Components**:
- Gene search input with autocomplete
- Gene category selection (all vs candidate genes)
- Gene information display panel
- Cross-dataset presence indicators
- External database links

#### `oncoplot_ui.R` - Variant Distribution Visualization
**Purpose**: Defines the complex layout for variant exploration with filtering and interactive plots.

**Components**:
- Multi-criteria filtering sidebar
- Interactive oncoplot (ComplexHeatmap)
- Variant data table
- Gene expression integration
- Sub-heatmap generation for selected genes

#### `rna_ui.R` - RNA-seq Analysis Interface
**Purpose**: Creates the layout for differential gene expression analysis and pathway enrichment.

**Components**:
- PCA plot displays
- Contrast selection (tumor vs normal, PTC vs FTC)
- Interactive volcano plots with threshold controls
- Differential expression results tables
- Pathway enrichment analysis section

#### `rna_fusion_ui.R` - RNA Fusion Analysis Layout
**Purpose**: Defines the layout for exploring RNA fusion events across cancer subtypes.

**Components**:
- Fusion event filtering options
- Subtype-wise fusion distribution plots
- Fusion partner information tables
- Confidence level indicators
- Supporting evidence display

#### `wes_ui.R` - WES Analysis Interface
**Purpose**: Creates the layout for additional whole-exome sequencing analyses.

**Components**:
- Mutational signature analysis
- Clonal evolution visualization
- MSI (Microsatellite Instability) status display
- Additional genomic metrics

#### `download_ui.R` - Data Export Interface
**Purpose**: Defines the layout for data download and export functionality.

**Components**:
- Dataset selection options
- File format choices (CSV, RDS, ZIP)
- Download progress indicators
- Export customization options
- File size information

#### `docs_ui.R` - Documentation Display
**Purpose**: Simple layout for displaying application documentation and tutorials.

**Components**:
- Markdown content rendering
- Navigation within documentation
- Tutorial and FAQ display

#### `contact_ui.R` - Team Information Layout
**Purpose**: Creates the layout for displaying team information and contact details.

**Components**:
- Team member information
- Contact details and affiliations
- Project acknowledgments
- Institutional information

---

## File Organization Principles

### Modular Design Philosophy

1. **Separation of Concerns**: UI layout (`user_interface/`) is separate from interactive logic (`modules/`)

2. **Reusability**: Modules can be used across multiple tabs and contexts

3. **Maintainability**: Each file has a single, clear responsibility

4. **Scalability**: New features can be added as new modules without affecting existing code

### Naming Conventions

- **Modules**: Follow the pattern `[functionality]_mod.R` (e.g., `volcano_mod.R`, `gene_search_mod.R`)
- **UI Components**: Follow the pattern `[tab_name]_ui.R` (e.g., `home_ui.R`, `rna_ui.R`)
- **Functions**: Module functions follow the pattern `[module_name]_ui()` and `[module_name]_server()`

### Integration Pattern

The main `ui.R` file imports and organizes the UI components:

```r
# ui.R structure
navbarPage(
  title = "Pediatric Thyroid Cancer Explorer",
  tabPanel("Home", home_page),           # from home_ui.R
  tabPanel("Gene Search", gene_search_page),  # from gene_search_ui.R
  tabPanel("Variants Distribution", onco_plot), # from oncoplot_ui.R
  # ... other tabs
)
```

The main `server.R` file calls the module server functions:

```r
# server.R structure
function(input, output, session) {
  # Call module servers
  meta_plots_server("sample_meta_stats", ...)
  gene_search_server("gene_search", ...)
  volcano_server("volcano_plot", ...)
  # ... other module servers
}
```

This modular architecture ensures that the Pediatric Thyroid Cancer Explorer remains maintainable, extensible, and follows Shiny best practices for complex applications.