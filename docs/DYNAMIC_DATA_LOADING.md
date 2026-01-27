# Dynamic Data Loading Documentation

## Overview

The PTC Explorer application implements dynamic data loading to automatically detect and load the most recent data files based on date patterns in filenames. This eliminates the need for hardcoded file paths and ensures the application always uses the latest available data.

## Implementation

### Core Function: `load_latest_data_file()`

```r
load_latest_data_file <- function(directory, pattern, 
                                  date_pattern = "\\d{4}-\\d{2}-\\d{2}") {
  # Scan directory for files matching pattern
  files <- list.files(directory, pattern = pattern, full.names = TRUE)
  
  # Extract dates from filenames
  dates <- stringr::str_extract(files, date_pattern)
  valid_files <- files[!is.na(dates)]
  
  # Validation
  if (length(valid_files) == 0) {
    stop(paste("No files found matching pattern:", pattern))
  }
  
  # Find file with latest date
  dates_parsed <- as.Date(dates[!is.na(dates)])
  latest_idx <- which.max(dates_parsed)
  latest_file <- valid_files[latest_idx]
  
  # Load and return data
  message(sprintf("Loading latest data file: %s", basename(latest_file)))
  readRDS(latest_file)
}
```

### Specialized Functions

#### `load_latest_app_data()`
Loads the most recent main application data file matching pattern `app_data_pack_YYYY-MM-DD.rds`.

#### `load_latest_onco_data()`
Loads the most recent oncoplot data file matching pattern `ptc_onco_obj_list_YYYY-MM-DD.rds`.

## File Naming Conventions

### Standard Patterns
- **Main Application Data**: `app_data_pack_YYYY-MM-DD.rds`
- **Oncoplot Data**: `ptc_onco_obj_list_YYYY-MM-DD.rds`
- **Archive Data**: `oncoplot_boxplot_YYYY-MM-DD.rds`

### Date Format
- **Required Format**: `YYYY-MM-DD` (ISO 8601 standard)
- **Examples**: 
  - `2025-01-15` (January 15, 2025)
  - `2024-12-31` (December 31, 2024)

## Usage in Application

### In `global.R`
```r
# Source utility functions
source("R/utils.R")

# Load latest data automatically
app_data_pack <- load_latest_app_data()
ptc_onco_obj_list <- load_latest_onco_data()
```

### Error Handling
The functions provide comprehensive error handling:

1. **No Files Found**: Clear error message if no files match the pattern
2. **Invalid Dates**: Skip files with unparseable date formats
3. **Loading Errors**: Propagate RDS loading errors with context

## Benefits

### Development Advantages
- **No Manual Updates**: Developers don't need to update hardcoded paths
- **Consistent Behavior**: Same loading logic across all environments
- **Version Safety**: Always uses most recent data version
- **Debugging Support**: Clear messages about which files are loaded

### Deployment Advantages
- **Zero Configuration**: Works immediately in production
- **Backward Compatibility**: Graceful handling of different file versions
- **Automatic Updates**: New data files are used without code changes
- **Rollback Capability**: Previous versions remain available

## Data Management Workflow

### Data Preparation Repository

The data files used by this application are created using scripts from the dedicated data preparation repository:

**🔗 Repository**: [uab-cgds-worthey/ptc-explorer-data-prep](https://github.com/uab-cgds-worthey/ptc-explorer-data-prep)

**Available Scripts**:
- **`create_app_data_pack.R`** - Generate the main application data bundle (`app_data_pack_*.rds`)
- **`create_oncoplot_data.R`** - Create visualization-ready oncoplot objects (`ptc_onco_obj_list_*.rds`)  
- **Enrichment analysis scripts** - Perform pathway and gene set enrichment analysis
- **Data validation scripts** - Quality control and data integrity checking
- **Differential expression workflows** - Gene expression comparison pipelines
- **Variant annotation pipeline** - Genomic variant processing and annotation

### Adding New Data
1. **Use data preparation scripts** from: https://github.com/uab-cgds-worthey/ptc-explorer-data-prep
2. **Generate files** with naming convention: `app_data_pack_YYYY-MM-DD.rds`
3. **Place files** in `data/` directory
4. **Restart application** - new data loads automatically
5. **Previous versions** remain as backup for rollback capability

### Version Management
```r
# Check available versions
list.files("data", pattern = "app_data_pack_.*\\.rds$")

# Manually load specific version (if needed)
specific_data <- readRDS("data/app_data_pack_2025-01-10.rds")
```

### Cleanup Old Versions
```r
# Optional cleanup function (not automatically called)
cleanup_old_versions <- function(keep_latest_n = 3) {
  files <- list.files("data", pattern = "app_data_pack_.*\\.rds$", full.names = TRUE)
  dates <- stringr::str_extract(files, "\\d{4}-\\d{2}-\\d{2}")
  
  # Sort by date, keep only recent versions
  sorted_files <- files[order(as.Date(dates), decreasing = TRUE)]
  old_files <- sorted_files[(keep_latest_n + 1):length(sorted_files)]
  
  if (length(old_files) > 0) {
    file.remove(old_files)
    message(sprintf("Removed %d old data files", length(old_files)))
  }
}
```

## Testing

### Unit Tests
```r
test_that("load_latest_data_file works correctly", {
  # Create temporary test files
  temp_dir <- tempdir()
  writeRDS(list(data = "test1"), file.path(temp_dir, "test_2025-01-01.rds"))
  writeRDS(list(data = "test2"), file.path(temp_dir, "test_2025-01-15.rds"))
  
  # Test loading
  result <- load_latest_data_file(temp_dir, "test_.*\\.rds$")
  expect_equal(result$data, "test2")  # Should load the latest date
  
  # Cleanup
  unlink(file.path(temp_dir, "test_*.rds"))
})
```

### Integration Tests
```r
test_that("application loads with dynamic data", {
  # Test that global.R executes without errors
  expect_silent({
    source("global.R")
  })
  
  # Test that data objects are created
  expect_true(exists("app_data_pack"))
  expect_true(exists("ptc_onco_obj_list"))
})
```

## Troubleshooting

### Common Issues

#### No Files Found Error
```
Error: No files found matching pattern: app_data_pack_.*\.rds$
```
**Solution**: Ensure data files exist in the `data/` directory with correct naming pattern.

#### Date Parsing Issues
If files exist but aren't being detected:
1. Check filename follows exact pattern: `prefix_YYYY-MM-DD.rds`
2. Ensure date is valid (e.g., not `2025-02-30`)
3. Verify no extra characters in date portion

#### Loading Errors
```
Error in readRDS(latest_file): cannot read workspace version 'X'
```
**Solution**: File may be corrupted or created with incompatible R version.

### Debug Mode
Enable verbose logging:
```r
options(verbose = TRUE)
app_data <- load_latest_app_data()  # Will show detailed messages
```

### Manual Override
For testing or emergency situations:
```r
# Temporarily use specific file
app_data_pack <- readRDS("data/app_data_pack_2025-01-10.rds")
```

## Best Practices

### For Data Providers
1. **Consistent Naming**: Always use `YYYY-MM-DD` format
2. **Validation**: Test data files before deployment
3. **Documentation**: Include metadata about data generation date

### For Developers
1. **Error Handling**: Wrap data loading in try-catch blocks where appropriate
2. **Logging**: Monitor which data versions are being used
3. **Testing**: Include tests for different data scenarios

### For Deployment
1. **File Permissions**: Ensure application can read data directory
2. **Disk Space**: Monitor for accumulating data files
3. **Backup Strategy**: Consider automated backup of data files

## Migration Guide

### From Hardcoded Paths
If migrating from hardcoded file paths:

1. **Before**:
   ```r
   app_data_pack <- readRDS("data/app_data_pack_fixed_name.rds")
   ```

2. **After**:
   ```r
   source("R/utils.R")
   app_data_pack <- load_latest_app_data()
   ```

3. **Update File Names**: Rename existing files to include dates:
   - `app_data_pack_fixed_name.rds` → `app_data_pack_2025-01-15.rds`

### Testing Migration
1. Verify old and new systems produce same results
2. Test with multiple file versions
3. Validate error handling scenarios
4. Update documentation and tests

## Future Enhancements

### Potential Improvements
1. **Configuration**: Allow custom date patterns via config file
2. **Validation**: Built-in data integrity checking
3. **Caching**: Cache loaded data to improve startup time
4. **Monitoring**: Automated alerting for data loading issues
5. **Versioning**: Semantic versioning support alongside dates

### Integration Opportunities
1. **CI/CD**: Automated data validation in deployment pipeline
2. **Monitoring**: Integration with application monitoring tools
3. **Documentation**: Auto-generated data lineage documentation