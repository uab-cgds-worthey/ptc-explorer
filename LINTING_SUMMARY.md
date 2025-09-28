# R Code Linting

This project uses [lintr](https://github.com/r-lib/lintr) to enforce R code style standards.

## Configuration

Linting rules are defined in `.lintr` with the following key settings:
- Line length limit: 120 characters
- Standard R style guidelines (spacing, indentation, etc.)
- Disabled: `object_usage_linter`, `object_name_linter`

## Usage

### Check all files
```r
library(lintr)
lint_dir()
```

### Check specific file
```r
lint("path/to/file.R")
```

## GitHub Integration

Linting runs automatically on pull requests via GitHub Actions (`.github/workflows/lint-project.yaml`). All R code must pass linting checks before merging.

## IDE Setup

### RStudio
Install the lintr package and it will show linting warnings in the editor.

### VS Code
Install the R extension which includes lintr support.