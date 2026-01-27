# Test Dynamic Data Loading Functions
# This file tests the data loading utilities in R/utils.R

library(testthat)

# Source the utilities (adjust path as needed)
source("../R/utils.R")

test_that("load_latest_data_file works with valid files", {
  # Create temporary directory for testing
  temp_dir <- tempdir()

  # Create test data files with different dates
  test_data1 <- list(version = "1.0", data = "old")
  test_data2 <- list(version = "2.0", data = "new")

  file1 <- file.path(temp_dir, "test_data_2025-01-01.rds")
  file2 <- file.path(temp_dir, "test_data_2025-01-15.rds")

  saveRDS(test_data1, file1)
  saveRDS(test_data2, file2)

  # Test that latest file is loaded
  result <- load_latest_data_file(temp_dir, "test_data_.*\\.rds$")

  expect_equal(result$version, "2.0")
  expect_equal(result$data, "new")

  # Cleanup
  unlink(c(file1, file2))
})

test_that("load_latest_data_file handles no files error", {
  temp_dir <- tempdir()

  # Test error when no matching files
  expect_error(
    load_latest_data_file(temp_dir, "nonexistent_.*\\.rds$"),
    "No files found matching pattern"
  )
})

test_that("load_latest_data_file handles invalid dates gracefully", {
  temp_dir <- tempdir()

  # Create files with valid and invalid date patterns
  saveRDS(list(data = "valid"), file.path(temp_dir, "test_2025-01-01.rds"))
  saveRDS(list(data = "invalid"), file.path(temp_dir, "test_invalid_date.rds"))

  # Should load the file with valid date
  result <- load_latest_data_file(temp_dir, "test_.*\\.rds$")
  expect_equal(result$data, "valid")

  # Cleanup
  unlink(file.path(temp_dir, "test_*.rds"))
})

test_that("specialized loading functions work correctly", {
  # Test that functions exist and can be called
  # (This assumes test data exists in the data directory)

  expect_true(exists("load_latest_app_data"))
  expect_true(exists("load_latest_onco_data"))

  # These functions should be callable (but may error if no data files exist)
  expect_is(load_latest_app_data, "function")
  expect_is(load_latest_onco_data, "function")
})

test_that("gene annotation functions exist", {
  # Test that gene functions are loaded
  expect_true(exists("validate_gene_symbol"))
  expect_true(exists("gene_query"))
  expect_true(exists("gene_annotated"))

  expect_is(validate_gene_symbol, "function")
  expect_is(gene_query, "function")
  expect_is(gene_annotated, "function")
})

# Integration test (only run if data directory exists)
if (dir.exists("../data")) {
  test_that("application data loading works in context", {
    # Test that we can load data without errors
    expect_silent({
      # This should either succeed or give a clear error message
      tryCatch({
        app_data <- load_latest_app_data()
        expect_true(is.list(app_data))
      }, error = function(e) {
        # Acceptable if no data files exist
        expect_true(grepl("No files found", e$message))
      })
    })
  })
}

cat("Dynamic data loading tests completed.\n")
cat("Note: Integration tests require actual data files in ../data directory.\n")

