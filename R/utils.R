## Utility functions for cleaning and formatting

# Helper function to validate and clean gene symbols
validate_gene_symbol <- function(gene_symbol) {
  if (is.null(gene_symbol) || is.na(gene_symbol) || gene_symbol == "") {
    return(NULL)
  }
  
  # Convert to character and trim whitespace
  gene_clean <- trimws(as.character(gene_symbol))
  
  # Remove any problematic characters that might break URLs
  gene_clean <- gsub("[^A-Za-z0-9._-]", "", gene_clean)
  
  # Return NULL if the cleaned symbol is empty
  if (gene_clean == "") {
    return(NULL)
  }
  
  return(gene_clean)
}

# Function to load the latest data file based on date pattern
load_latest_data_file <- function(data_dir = "data", 
                                  file_pattern, 
                                  date_format = "%Y-%m-%d") {
  # Check if data directory exists
  if (!dir.exists(data_dir)) {
    stop(paste("Data directory not found:", data_dir))
  }
  
  # Get all files matching the pattern
  all_files <- list.files(data_dir, pattern = paste0(file_pattern, ".*\\.rds$"), full.names = TRUE)
  
  if (length(all_files) == 0) {
    stop(paste("No files found matching pattern:", file_pattern, "in directory:", data_dir))
  }
  
  # Extract dates from filenames
  file_dates <- character(length(all_files))
  valid_files <- logical(length(all_files))
  
  for (i in seq_along(all_files)) {
    # Extract filename without extension
    filename <- tools::file_path_sans_ext(basename(all_files[i]))
    
    # Remove the pattern prefix to get the date part
    date_part <- gsub(paste0("^", file_pattern, "_?"), "", filename)
    
    # Try to parse the date
    tryCatch({
      parsed_date <- as.Date(date_part, format = date_format)
      if (!is.na(parsed_date)) {
        file_dates[i] <- as.character(parsed_date)
        valid_files[i] <- TRUE
      }
    }, error = function(e) {
      # Skip files with unparseable dates
      valid_files[i] <- FALSE
    })
  }
  
  # Filter to valid files only
  valid_file_paths <- all_files[valid_files]
  valid_file_dates <- file_dates[valid_files]
  
  if (length(valid_file_paths) == 0) {
    stop(paste("No files with valid dates found for pattern:", file_pattern))
  }
  
  # Find the file with the latest date
  latest_date_index <- which.max(as.Date(valid_file_dates))
  latest_file <- valid_file_paths[latest_date_index]
  latest_date <- valid_file_dates[latest_date_index]
  
  # Load and return the RDS file
  cat(paste("Loading latest data file:", basename(latest_file), "(Date:", latest_date, ")\n"))
  
  tryCatch({
    data <- readRDS(latest_file)
    return(list(
      data = data,
      file_path = latest_file,
      date = latest_date,
      filename = basename(latest_file)
    ))
  }, error = function(e) {
    stop(paste("Failed to load RDS file:", latest_file, "Error:", e$message))
  })
}

# Convenience functions for specific data types
load_latest_app_data <- function(data_dir = "data") {
  result <- load_latest_data_file(data_dir, "app_data_pack")
  return(result$data)
}

load_latest_onco_data <- function(data_dir = "data") {
  result <- load_latest_data_file(data_dir, "ptc_onco_obj_list")
  return(result$data)
}

clean_sig_df <- function(sig_df,
                         input_res = FALSE,
                         add_rownames = FALSE,
                         rename_cols = FALSE,
                         gene = NULL) {
  padj <- log2FoldChange <- NULL

  if (input_res) {
    sig_df <- subset(sig_df, padj < 0.05 & abs(log2FoldChange) > 1.5)
  }
  if (add_rownames) {
    sig_df <- sig_df[!duplicated(sig_df$gene_name), ]
    row.names(sig_df) <- sig_df$gene_name
  }
  #                      "Ensembl_ID")]
  if (rename_cols) {
    colnames(sig_df) <- c("ENTREZ ID",
                          "SYMBOL",
                          "ENSEMBL",
                          "Log2FC",
                          "P-Value",
                          "Adj. P-Value",
                          "Gene Type",
                          "Synonyms"
                          )
  }
  if (!is.null(gene)) {
    sig_df <- sig_df[sig_df$SYMBOL %in% gene, ]
  }
  return(sig_df)
}

############## Gene Annotation by Entrez or Ensembl
gene_annotated <- function(gene,
                           species = "human",
                           ...) {
  # Validate gene identifier (less strict for Entrez IDs)
  if (is.null(gene) || is.na(gene) || gene == "") {
    return(HTML("<strong>Error:</strong> No gene identifier provided."))
  }
  
  # Clean the gene identifier but allow numbers for Entrez IDs
  gene_clean <- trimws(as.character(gene))
  if (gene_clean == "") {
    return(HTML("<strong>Error:</strong> Invalid gene identifier provided."))
  }
  
  gene_encoded <- utils::URLencode(gene_clean, reserved = TRUE)
  
  base_url <- "https://mygene.info/v3/gene/"
  
  # Build query parameters properly
  params <- list(
    species = species,
    fields = "name,symbol,entrezgene,ensembl.gene,summary"
  )
  
  # Construct the full URL
  query_string <- paste(names(params), params, sep = "=", collapse = "&")
  api_url <- paste0(base_url, gene_encoded, "?", query_string)
  
  tryCatch({
    response <- httr::GET(api_url)
    # Check if the request was successful (status code 200)
    if (httr::status_code(response) == 200) {
      # Parse the JSON response
      response_content <-
        httr::content(response, as = "text", encoding = "UTF-8")
      parsed_data <- jsonlite::fromJSON(response_content)
      
      # Check if we got valid data
      if (is.null(parsed_data) || length(parsed_data) == 0) {
        return(HTML(paste0("<strong>No Information Found:</strong> No data available for gene '", 
                           gene_clean, "'.")))
      }
      
      # Extract relevant fields from the response
      gene_symbol <- ifelse(is.null(parsed_data[["symbol"]]),
                            "NA", parsed_data[["symbol"]])
      gene_name   <- ifelse(is.null(parsed_data[["name"]]),
                            "NA", parsed_data[["name"]])
      gene_entrezgene   <-
        ifelse(is.null(parsed_data[["entrezgene"]]),
               "NA", parsed_data[["entrezgene"]])
      gene_ensembl   <-
        ifelse(is.null(parsed_data$ensembl[["gene"]]),
               "NA",
               parsed_data$ensembl[["gene"]])
      gene_summary <- ifelse(is.null(parsed_data[["summary"]]),
                             "NA", parsed_data[["summary"]])
      result <- paste0(
        "<strong>Gene Symbol:</strong> ",
        gene_symbol,
        "</br>",
        "<strong>Name:</strong> ",
        gene_name,
        "</br>",
        "<strong>Entrez Id:</strong> ",
        gene_entrezgene,
        "</br>",
        "<strong>Ensembl Id:</strong> ",
        gene_ensembl,
        "</br>",
        "<strong>Summary:</strong> ",
        gene_summary
      )
      return(HTML(result))
    } else {
      return(HTML(paste0("<strong>API Error:</strong> Status code ", 
                         httr::status_code(response), ". Unable to retrieve gene information.")))
    }
  }, error = function(e) {
    return(HTML(paste0("<strong>Error:</strong> Unable to fetch gene information for '", 
                       gene_clean, "'. ", e$message)))
  })
}

############### Gene query by symbol
gene_query <- function(gene,
                       species = "human",
                       hit = 1,
                       ...) {
  # Validate and clean gene symbol
  gene_clean <- validate_gene_symbol(gene)
  if (is.null(gene_clean)) {
    return(HTML("<strong>Error:</strong> Invalid or empty gene symbol provided."))
  }
  
  # URL encode the gene symbol
  gene_encoded <- utils::URLencode(gene_clean, reserved = TRUE)
  
  base_url <- "https://mygene.info/v3/query"
  
  # Build query parameters properly
  params <- list(
    q = paste0("symbol:", gene_encoded),
    size = as.character(hit),
    species = species,
    fields = "name,symbol,entrezgene,ensembl.gene,summary"
  )
  
  # Construct the full URL with proper encoding
  query_string <- paste(names(params), params, sep = "=", collapse = "&")
  api_url <- paste0(base_url, "?", query_string)
  
  tryCatch({
    response <- httr::GET(api_url)
    # Check if the request was successful (status code 200)
    if (httr::status_code(response) == 200) {
      # Parse the JSON response
      response_content <-
        httr::content(response, as = "text", encoding = "UTF-8")
      parsed_data <- jsonlite::fromJSON(response_content)
      if (length(parsed_data$hits) == 0) {
        gene_annotated(gene_clean)
      } else {
        # Extract relevant fields from the response
        gene_symbol <- ifelse(is.null(parsed_data$hits[["symbol"]]),
                              "NA", parsed_data$hits[["symbol"]])
        gene_name   <- ifelse(is.null(parsed_data$hits[["name"]]),
                              "NA", parsed_data$hits[["name"]])
        gene_entrezgene   <-
          ifelse(is.null(parsed_data$hits[["entrezgene"]]),
                 "NA", parsed_data$hits[["entrezgene"]])
        gene_ensembl   <-
          ifelse(is.null(parsed_data$hits[["ensembl"]]),
                 "NA", parsed_data$hits[["ensembl"]])
        gene_summary <-
          ifelse(is.null(parsed_data$hits[["summary"]]),
                 "NA", parsed_data$hits[["summary"]])
        result <- paste0(
          "<strong>Gene Symbol:</strong> ",
          gene_symbol,
          "</br>",
          "<strong>Name:</strong> ",
          gene_name,
          "</br>",
          "<strong>Entrez Id:</strong> ",
          gene_entrezgene,
          "</br>",
          "<strong>Ensembl Id:</strong> ",
          gene_ensembl,
          "</br>",
          "<strong>Summary:</strong> ",
          gene_summary
        )
        return(HTML(result))
      }
    } else {
      return(HTML(paste0("<strong>API Error:</strong> Status code ", 
                         httr::status_code(response), ". Please try again later.")))
    }
  }, error = function(e) {
    return(HTML(paste0("<strong>Error:</strong> Unable to fetch gene information for '", 
                       gene_clean, "'. ", e$message)))
  })
}

