# Pediatric Thyroid Cancer Explorer - User Guide

## About PTCE

PTCE is an interactive web application for exploring genomic and transcriptomic data from 45 pediatric patients with differentiated thyroid cancer. The application integrates whole-exome sequencing, RNA-sequencing, and clinical metadata.

## Navigation Overview

The application has 9 main tabs:

1. **Home** - Study design and sample metadata
2. **Gene Search** - Search for specific genes across datasets  
3. **Variants Distribution** - Interactive oncoplot and variant exploration
4. **DGE Analysis** - Differential gene expression with PCA and volcano plots
5. **RNA-Fusions Analysis** - RNA fusion detection results
6. **Signature, Clonal and MSI** - Additional genomic analyses
7. **Download** - Export data in multiple formats
8. **User Guide** - This documentation
9. **Developer Guide** - Technical documentation

---

## How to Use Each Tab

### 🏠 Home Tab

**Study Design & Overview**
- View the analysis workflow diagram
- Understand how RNA-Seq and WES data were processed

**Sample Statistics**
- Use the dropdown to select clinical variables (age, sex, subtype, etc.)
- View interactive histograms showing distribution of patient characteristics

**Sample Metadata Table**
- Browse detailed patient information including participant IDs
- Use column sorting and filtering to explore the dataset
- Search for specific samples or characteristics

### 🔍 Gene Search Tab

**Gene Information**
- Search for any gene by symbol or name
- View comprehensive gene annotations
- See gene occurrence across all datasets (variants, expression, fusions)

**How to Search**
- Enter gene symbol in the search box
- Select from dropdown suggestions
- View detailed annotations and dataset presence

### 📊 Variants Distribution Tab

**Variants Table**
- Explore genomic variants identified from whole-exome sequencing
- Use filters on the left panel:
  - Gene name
  - Chromosome
  - Phenotype (tumor/normal)
  - Variant type
  - Germline classification

**Interactive Oncoplot**
- Visualize variant patterns across samples
- View gene expression data (tumor vs normal) alongside variants
- Select genes to create focused sub-heatmaps
- Explore variant distribution within six cancer subtypes

**Tips for Use**
- Start with broad filters, then narrow down
- Use the oncoplot to identify patterns across samples
- Select multiple genes to compare variant patterns

### 📈 DGE Analysis Tab

**Principal Component Analysis (PCA)**
- **Left plot**: Tumor vs normal samples with batch and sex correction
- **Right plot**: Six phenotype subtypes showing clustering patterns

**Differential Gene Expression**
- Browse lists of differentially expressed genes (DEGs)
- Two main comparisons available:
  - Tumor vs Normal
  - PTC vs FTC subtypes
- View functional annotations for each gene

**Volcano Plots**
- Interactive exploration of gene expression changes
- Filter by adjusted p-value (padj) and Log2FoldChange
- Click points to see gene details

**Enrichment Analysis**
- Explore upregulated and downregulated pathways
- Results from Enrichr pathway databases
- Search by gene name or pathway name
- Separate results for each comparison

### 🧬 RNA-Fusions Analysis Tab

**Fusion Detection Results**
- View RNA fusions detected in tumor samples
- Explore subtype-wise distribution of fusion events
- Filter by confidence level and supporting evidence

### 🔬 Signature, Clonal and MSI Tab

**Additional Genomic Analyses**
- Mutational signatures
- Clonal evolution analysis  
- Microsatellite instability (MSI) results

### 📥 Download Tab

**Data Export Options**
- **ZIP format**: All datasets for external analysis
- **RDS objects**: R-compatible format for RStudio
- **CSV format**: Individual tables for spreadsheet analysis
- **Results**: Analysis outputs and visualizations

---

## Tips for Effective Use

### Getting Started
1. **Begin with Home tab** to understand the dataset structure
2. **Review Study Design** to understand analysis workflow
3. **Explore Sample Statistics** to familiarize yourself with patient characteristics

### Data Exploration
1. **Start broad, then narrow**: Use filters progressively to focus on specific subsets
2. **Cross-reference tabs**: A gene found in variants may also show up in DGE analysis
3. **Use Gene Search**: When you find interesting genes, search for comprehensive information

### Visual Analysis
1. **Oncoplot**: Look for patterns across samples and subtypes
2. **Volcano plots**: Focus on genes with high significance and fold change
3. **PCA plots**: Understand sample relationships and batch effects

### Advanced Features
1. **Interactive plots**: Most visualizations allow zooming and selection
2. **Table filtering**: Use search and column filters for precise data retrieval
3. **Export functionality**: Download specific results or entire datasets

---

## Common Use Cases

### Research Question: "What variants are common in PTC?"
1. Go to **Variants Distribution** tab
2. Filter by phenotype = "tumor" and subtype = "PTC"
3. Examine the oncoplot for frequently mutated genes
4. Use **Gene Search** for detailed information on interesting genes

### Research Question: "Which pathways are dysregulated in thyroid cancer?"
1. Visit **DGE Analysis** tab
2. Review the **Enrichment Analysis** section
3. Search for pathways related to cancer or thyroid function
4. Cross-reference with **Variants Distribution** to see if pathway genes have mutations

### Research Question: "Are there subtype-specific fusion events?"
1. Use **RNA-Fusions Analysis** tab
2. Examine subtype distribution plots
3. Note fusion partners and frequency across subtypes

---

## Data Download and Citation

### Downloading Data
- All datasets are available through the **Download** tab
- Choose format based on your analysis needs:
  - **CSV**: For spreadsheet analysis
  - **RDS**: For R/RStudio analysis
  - **ZIP**: Complete dataset package

### Using the Data
- Data is provided for research and educational purposes
- Please cite the original publication when using results
- Refer to the **Team** tab for contact information

---

## Getting Help

### Technical Issues
- Check browser compatibility (modern browsers recommended)
- Clear browser cache if visualizations don't load
- Ensure JavaScript is enabled

### Data Questions
- Refer to **Developer Guide** for technical details
- Use **Team** tab to contact the development team
- Check the original publication for methodology details

### Feature Requests
- Contact information available in **Team** tab
- Provide specific use cases and requirements