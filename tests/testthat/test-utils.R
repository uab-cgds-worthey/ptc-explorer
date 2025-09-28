# Tests for utility functions in R/utils.R

test_that("clean_sig_df function works correctly", {
  # Create sample test data
  test_df <- data.frame(
    entrez_id = c("1", "2", "3"),
    gene_name = c("GENE1", "GENE2", "GENE3"),
    ensembl_id = c("ENS1", "ENS2", "ENS3"),
    log2FoldChange = c(2.5, -1.8, 0.5),
    pvalue = c(0.001, 0.003, 0.4),
    padj = c(0.01, 0.02, 0.45),
    stringsAsFactors = FALSE
  )
  
  # Test basic functionality
  result <- clean_sig_df(test_df)
  expect_equal(nrow(result), 3)
  expect_equal(ncol(result), 6)
  
  # Test filtering with input_res = TRUE
  result_filtered <- clean_sig_df(test_df, input_res = TRUE)
  expect_equal(nrow(result_filtered), 1)  # Only GENE1 should pass filters
  expect_equal(result_filtered$gene_name[1], "GENE1")
  
  # Test column renaming
  result_renamed <- clean_sig_df(test_df, renameCols = TRUE)
  expect_true("SYMBOL" %in% colnames(result_renamed))
  expect_true("Log2FC" %in% colnames(result_renamed))
  expect_true("Adj. P-Value" %in% colnames(result_renamed))
  
  # Test gene filtering
  result_gene_filtered <- clean_sig_df(result_renamed, gene = "GENE2")
  expect_equal(nrow(result_gene_filtered), 1)
  expect_equal(result_gene_filtered$SYMBOL[1], "GENE2")
})

test_that("validate_gene_symbol function works correctly", {
  # Test valid gene symbols
  expect_equal(validate_gene_symbol("TP53"), "TP53")
  expect_equal(validate_gene_symbol("BRCA1"), "BRCA1")
  expect_equal(validate_gene_symbol("H3F3A"), "H3F3A")
  
  # Test gene symbols with special characters (should be cleaned)
  expect_equal(validate_gene_symbol("GENE@123"), "GENE123")
  expect_equal(validate_gene_symbol("GENE-NAME_1"), "GENE-NAME_1")
  
  # Test invalid inputs
  expect_null(validate_gene_symbol(""))
  expect_null(validate_gene_symbol(NULL))
  expect_null(validate_gene_symbol(NA))
  expect_null(validate_gene_symbol("!@#$%^&*()"))  # All special chars should result in NULL
  
  # Test whitespace handling
  expect_equal(validate_gene_symbol("  TP53  "), "TP53")
})