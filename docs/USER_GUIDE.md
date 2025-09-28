# Pediatric Thyroid Cancer Explorer - User Guide

## Quick Start Guide

Welcome to the Pediatric Thyroid Cancer Explorer (PTCE)! This guide will help you navigate and use the application effectively to explore pediatric thyroid cancer data.

### What is PTCE?

PTCE is an interactive web application that allows researchers and clinicians to explore genomic and transcriptomic data from 45 pediatric patients with differentiated thyroid cancer. The application integrates:

- **Whole-exome sequencing** data showing genomic variants
- **RNA-sequencing** data showing gene expression changes  
- **Clinical metadata** including patient demographics and pathology
- **Functional annotations** and pathway analysis

## Getting Started

### Navigation

The application has 9 main tabs accessible from the top navigation bar:

1. **Home** - Study overview and sample information
2. **Gene Search** - Search for specific genes across all datasets  
3. **Variants Distribution** - Explore genomic variants with interactive plots
4. **DGE Analysis** - Differential gene expression analysis
5. **RNA-Fusions Analysis** - RNA fusion detection results
6. **Signature, Clonal and MSI** - Additional genomic analyses
7. **Download** - Export data and results
8. **Docs** - Documentation and tutorials
9. **Team** - Development team information

## Detailed Tab Descriptions

### 1. Home Tab - Study Overview

**What you'll find here:**
- Study design flowchart showing the analysis workflow
- Interactive visualization of clinical features
- Complete sample metadata table

**How to use:**
- **Clinical Feature Exploration**: Use the dropdown menu to select different clinical variables (age, sex, subtype, etc.) and view their distribution as histograms
- **Sample Metadata Table**: Browse patient information, use column sorting and filtering to explore the dataset
- **Study Design**: Reference the workflow diagram to understand how the data was generated and analyzed

### 2. Gene Search Tab - Gene-Specific Information

**Purpose:** Find comprehensive information about any gene of interest.

**How to use:**
1. **Search for a gene**: Type a gene symbol (e.g., "BRAF", "RET", "TPO") in the search box
2. **View gene information**: See detailed annotations including:
   - Gene description and function
   - Chromosomal location
   - Links to external databases (NCBI, OMIM)
   - Presence in the current dataset

**Pro tip:** Use this tab to quickly check if a gene of interest is present in any of the datasets before exploring other tabs.

### 3. Variants Distribution Tab - Genomic Variants Analysis

**This is one of the most powerful features of PTCE!**

#### Variants Table (Left Side)
**Available Filters:**
- **Gene**: Search for specific genes
- **Chromosome**: Filter by chromosomal location  
- **Phenotype**: Tumor vs. Normal samples
- **Variant Type**: SNV, indel, etc.
- **Germline Class**: Pathogenic, VUS, benign, etc.

#### Interactive Oncoplot (Right Side)
**Key Features:**
- **Heatmap View**: Each row = gene, each column = sample
- **Color Coding**: Different colors represent variant types and significance
- **Clinical Annotations**: Patient metadata displayed above the heatmap
- **Expression Integration**: Gene expression levels shown alongside variants

**How to use the Oncoplot:**
1. **Apply Filters**: Use the left sidebar to filter variants by your criteria
2. **Select Genes**: Click on gene names or drag to select multiple genes
3. **View Sub-heatmap**: Selected genes appear in a detailed view on the right
4. **Explore Expression**: See if genes with variants also show expression changes
5. **Clinical Correlation**: Examine how variants correlate with patient subtypes

**Example Workflow:**
- Filter for "Pathogenic" variants in the "Germline Class" filter
- Look for genes that appear in multiple patients  
- Select interesting genes to see their distribution across subtypes
- Check the expression boxplots to see if variants correlate with expression changes

### 4. DGE Analysis Tab - Gene Expression Analysis

This tab contains three main sections:

#### A. Principal Component Analysis (PCA)
**Two PCA plots are shown:**
- **Left Plot**: Tumor vs. Normal comparison
- **Right Plot**: Subtype-specific analysis

**What this tells you:**
- How well tumor and normal samples separate
- Whether different subtypes cluster together
- Potential batch effects or outlier samples

#### B. Differential Gene Expression
**Available Contrasts:**
1. **Tumor vs. Normal**: Genes changed between tumor and normal tissue
2. **PTC vs. FTC**: Genes differentially expressed between papillary and follicular carcinomas

**Interactive Controls:**
- **P-value Threshold**: Adjust significance cutoff (default: 0.05)
- **Log2 Fold Change**: Set magnitude threshold (default: ±1.0)
- **Gene Table**: Browse all differentially expressed genes
- **Volcano Plot**: Interactive visualization of results

**How to use:**
1. **Choose your contrast** of interest (Tumor vs Normal or PTC vs FTC)
2. **Adjust thresholds** using the sliders to focus on the most significant changes
3. **Explore the volcano plot**: Hover over points to see gene names and statistics
4. **Browse the gene table**: Sort by fold change or p-value to find top genes

#### C. Enrichment Analysis
**What it shows:**
- Biological pathways that are up- or down-regulated
- Gene sets from multiple databases (GO, KEGG, Reactome)
- Statistical significance of pathway enrichment

**Search Functionality:**
- **Gene Search**: Find pathways containing your gene of interest
- **Pathway Search**: Look for specific biological processes

### 5. RNA-Fusions Analysis Tab

**What you'll find:**
- RNA fusion events detected in tumor samples
- Subtype-wise distribution of fusions
- Information about fusion partner genes

**How to interpret:**
- Fusions are grouped by thyroid cancer subtype
- Each fusion shows the two genes involved and supporting evidence
- Consider fusions that are recurrent across multiple patients

### 6. Gene Search Tab - Cross-Dataset Gene Query

**Purpose:** Get a complete view of any gene across all data types.

**Information provided:**
- Gene annotation and description
- Presence in variant data
- Differential expression status
- Involvement in RNA fusions
- Links to external databases

### 7. Download Tab - Data Export

**Available downloads:**
- **Complete Datasets**: All data in ZIP format
- **Filtered Results**: Download only the data you're currently viewing
- **R Objects**: For further analysis in R/RStudio
- **Publication-Ready Plots**: High-resolution figures

**File Formats:**
- `.csv` - For Excel/spreadsheet programs
- `.rds` - For R users
- `.png/.pdf` - For presentations and publications

## Practical Use Cases

### Case Study 1: Investigating a Specific Gene

**Goal:** Explore the TPO gene across all data types

**Steps:**
1. **Start with Gene Search**: Search for "TPO" to confirm it's in the dataset
2. **Check Variants**: Go to "Variants Distribution" → Filter by Gene "TPO"
3. **View Expression**: In the oncoplot, see if TPO shows expression changes
4. **Pathway Analysis**: Go to "DGE Analysis" → Enrichment → Search for "TPO"
5. **Download Results**: Export TPO-related data for further analysis

### Case Study 2: Comparing Subtypes

**Goal:** Find differences between PTC and FTC

**Steps:**
1. **Expression Differences**: Go to "DGE Analysis" → Select "PTC vs FTC" contrast
2. **Identify Top Genes**: Sort by fold change to find most different genes
3. **Pathway Analysis**: Look at enriched pathways to understand biological differences
4. **Variant Correlation**: Check if differentially expressed genes also have variants

### Case Study 3: Clinical Correlation

**Goal:** Understand how molecular features relate to clinical characteristics

**Steps:**
1. **Explore Metadata**: Use "Home" tab to understand patient characteristics
2. **Subtype Analysis**: Use variants oncoplot to see how mutations distribute across subtypes
3. **Expression Patterns**: Check if certain subtypes have distinct expression profiles
4. **Integration**: Look for genes that show both variants and expression changes

## Tips for Effective Analysis

### Best Practices

1. **Start Broad, Then Focus**: Begin with overview visualizations, then drill down to specific genes or pathways

2. **Use Multiple Data Types**: Don't rely on just one type of evidence - look at variants, expression, and pathways together

3. **Consider Clinical Context**: Always relate molecular findings back to the clinical metadata

4. **Validate Findings**: If you find something interesting, look for supporting evidence across different tabs

5. **Export for Further Analysis**: Download data when you need to perform analyses not available in the app

### Common Workflows

**Discovery Workflow:**
Home → DGE Analysis → Variants Distribution → Gene Search → Download

**Hypothesis-Driven Workflow:**  
Gene Search → Variants Distribution → DGE Analysis → Enrichment Analysis

**Clinical Correlation Workflow:**
Home → Variants Distribution (filter by subtype) → DGE Analysis → Download

### Performance Tips

- **Use Filters**: Apply filters before generating large plots to improve performance
- **Be Patient**: Complex visualizations may take a few seconds to load
- **Clear Selections**: Reset filters between different analyses to avoid confusion
- **Download for Complex Analysis**: For advanced statistics, export data and use R/Python

## Interpreting Results

### Statistical Significance

- **P-values**: Lower p-values indicate more confident results
- **Adjusted P-values**: Used to account for multiple testing (more stringent)
- **Effect Size**: Consider both statistical significance AND biological magnitude

### Expression Analysis

- **Log2 Fold Change**: 
  - Positive values = higher in condition 1
  - Negative values = higher in condition 2
  - |2| = 4-fold change, |1| = 2-fold change

### Variant Interpretation

- **Pathogenic**: Likely disease-causing
- **VUS**: Variant of Uncertain Significance
- **Benign**: Likely not disease-causing
- **VAF**: Variant Allele Frequency (% of reads with the variant)

### Pathway Analysis

- **Enrichment Score**: Higher scores = stronger enrichment
- **Gene Ratio**: Proportion of genes in pathway that are in your gene set
- **Background Ratio**: Proportion in the genome

## Frequently Asked Questions

**Q: Why don't I see my gene of interest?**
A: The dataset only includes genes with variants or significant expression changes. Use Gene Search to confirm presence.

**Q: What do the colors in the oncoplot mean?**
A: Different colors represent different types of variants. Hover over the legend for details.

**Q: How do I know if a result is significant?**
A: Look at adjusted p-values (padj) < 0.05 for statistical significance.

**Q: Can I analyze my own data with this app?**
A: This version is specific to the pediatric thyroid cancer dataset. Contact the team about adapting it for other datasets.

**Q: How do I cite this resource?**
A: Citation information is available on the Team tab and in the documentation.

## Getting Help

If you encounter issues or have questions:

1. **Check the Docs tab** in the application
2. **Review this user guide**
3. **Visit the GitHub repository** for technical issues
4. **Contact the development team** (information on Team tab)

## Next Steps

After exploring the data through PTCE:

1. **Export interesting findings** using the Download tab
2. **Validate results** through literature review or experimental validation  
3. **Collaborate with the team** for deeper analysis
4. **Share your discoveries** with the research community

---

Happy exploring! The PTCE team hopes this resource accelerates your thyroid cancer research.