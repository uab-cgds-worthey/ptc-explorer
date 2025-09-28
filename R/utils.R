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
    
    # Check if the data object has version information
    version_info <- NULL
    if (is.list(data) && "version" %in% names(data)) {
      version_info <- data$version
      cat(paste("Data version:", version_info, "\n"))
    } else if (exists("version", where = data, inherits = FALSE)) {
      # In case version is an attribute or environment variable
      version_info <- get("version", envir = as.environment(data))
      cat(paste("Data version:", version_info, "\n"))
    }
    
    return(list(
      data = data,
      file_path = latest_file,
      date = latest_date,
      filename = basename(latest_file),
      version = version_info
    ))
  }, error = function(e) {
    stop(paste("Failed to load RDS file:", latest_file, "Error:", e$message))
  })
}

# Convenience functions for specific data types
load_latest_app_data <- function(data_dir = "data") {
  result <- load_latest_data_file(data_dir, "app_data_pack")
  return(list(
    data = result$data,
    version = result$version,
    file_info = list(
      filename = result$filename,
      date = result$date,
      file_path = result$file_path
    )
  ))
}

load_latest_onco_data <- function(data_dir = "data") {
  result <- load_latest_data_file(data_dir, "ptc_onco_obj_list")
  return(list(
    data = result$data,
    version = result$version,
    file_info = list(
      filename = result$filename,
      date = result$date,
      file_path = result$file_path
    )
  ))
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
    return(HTML(
      "<div style='padding: 10px; border: 1px solid #ffc107; border-radius: 4px; background-color: #fff3cd; color: #856404;'>",
      "<strong>⚠️ Invalid Gene Identifier</strong><br/>",
      "The gene identifier appears to be empty or contains invalid characters.<br/>",
      "Please select a valid gene from the table above.",
      "</div>"
    ))
  }
  
  # URL encode the gene symbol
  gene_encoded <- utils::URLencode(gene_clean, reserved = TRUE)
  
  base_url <- "https://mygene.info/v3/query"
  
  # Determine query type based on gene identifier format
  query_term <- if (grepl("^ENSG\\d+", gene_clean)) {
    # Ensembl gene ID
    paste0("ensembl.gene:", gene_encoded)
  } else if (grepl("^\\d+$", gene_clean)) {
    # Entrez gene ID (numeric)
    paste0("entrezgene:", gene_encoded)
  } else {
    # Gene symbol (including non-standard ones like ABHD11-AS1)
    # Try exact symbol match first, then broader search
    gene_encoded
  }
  
  # Build query parameters properly
  params <- list(
    q = query_term,
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
        # If no hits with the first query, try a broader search for gene symbols
        if (!grepl("^ENSG\\d+", gene_clean) && !grepl("^\\d+$", gene_clean)) {
          # Try symbol-prefixed search for gene symbols
          params$q <- paste0("symbol:", gene_encoded)
          query_string <- paste(names(params), params, sep = "=", collapse = "&")
          api_url_retry <- paste0(base_url, "?", query_string)
          
          response_retry <- httr::GET(api_url_retry)
          if (httr::status_code(response_retry) == 200) {
            response_content_retry <- httr::content(response_retry, as = "text", encoding = "UTF-8")
            parsed_data_retry <- jsonlite::fromJSON(response_content_retry)
            
            if (length(parsed_data_retry$hits) > 0) {
              parsed_data <- parsed_data_retry
              api_url <- api_url_retry  # Update for error reporting
            }
          }
        }
        
        # If still no hits, provide user-friendly error message
        if (length(parsed_data$hits) == 0) {
          error_type <- if (grepl("^ENSG\\d+", gene_clean)) {
            "Ensembl ID"
          } else if (grepl("^\\d+$", gene_clean)) {
            "Entrez ID"
          } else {
            "gene symbol"
          }
          
          search_suggestions <- paste0(
            "<div style='margin-top: 10px; padding: 8px; background-color: #f8f9fa; border-left: 3px solid #007bff;'>",
            "<strong>💡 Search Suggestions:</strong><br/>",
            "• Try searching on <a href='https://www.genecards.org/cgi-bin/carddisp.pl?gene=", gene_encoded, "' target='_blank'>GeneCards</a><br/>",
            "• Search on <a href='https://www.ncbi.nlm.nih.gov/gene/?term=", gene_encoded, "' target='_blank'>NCBI Gene</a><br/>",
            "• Look up on <a href='https://www.ensembl.org/Multi/Search/Results?q=", gene_encoded, "' target='_blank'>Ensembl</a>",
            "</div>"
          )
          
          error_msg <- paste0(
            "<div style='padding: 10px; border: 1px solid #dc3545; border-radius: 4px; background-color: #f8d7da; color: #721c24;'>",
            "<strong>❌ Gene Not Found</strong><br/>",
            "The ", error_type, " '<strong>", gene_clean, "</strong>' was not found in our database.<br/><br/>",
            "<strong>Possible reasons:</strong><br/>",
            "• Gene may be deprecated or renamed<br/>",
            "• Identifier format might be non-standard<br/>",
            "• Gene might be specific to certain species/builds<br/>",
            "</div>",
            search_suggestions
          )
          return(HTML(error_msg))
        }
      }
      
      # Extract relevant fields from the response
      hit_data <- parsed_data$hits[1, ]  # Get first hit
      
      gene_symbol <- ifelse(is.null(hit_data[["symbol"]]) || is.na(hit_data[["symbol"]]),
                            "NA", hit_data[["symbol"]])
      gene_name   <- ifelse(is.null(hit_data[["name"]]) || is.na(hit_data[["name"]]),
                            "NA", hit_data[["name"]])
      gene_entrezgene <- ifelse(is.null(hit_data[["entrezgene"]]) || is.na(hit_data[["entrezgene"]]),
                               "NA", hit_data[["entrezgene"]])
      
      # Handle ensembl field (can be nested)
      ensembl_id <- "NA"
      if (!is.null(hit_data[["ensembl"]]) && !is.na(hit_data[["ensembl"]])) {
        ensembl_data <- hit_data[["ensembl"]]
        if (is.list(ensembl_data) && !is.null(ensembl_data[["gene"]])) {
          ensembl_id <- ensembl_data[["gene"]]
        } else if (is.character(ensembl_data)) {
          ensembl_id <- ensembl_data
        }
      }
      
      gene_summary <- ifelse(is.null(hit_data[["summary"]]) || is.na(hit_data[["summary"]]),
                            "NA", hit_data[["summary"]])
      
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
        ensembl_id,
        "</br>",
        "<strong>Summary:</strong> ",
        gene_summary
      )
      return(HTML(result))
      
    } else {
      # Enhanced user-friendly error message for API failures
      status_code <- httr::status_code(response)
      
      error_icon <- if (status_code == 404) "🔍" else if (status_code >= 500) "🔧" else "⚠️"
      error_title <- if (status_code == 404) {
        "Gene Information Not Available"
      } else if (status_code >= 500) {
        "Service Temporarily Unavailable"
      } else {
        "Connection Issue"
      }
      
      error_explanation <- if (status_code == 404) {
        paste0("The gene '<strong>", gene_clean, "</strong>' could not be found in the mygene.info database.")
      } else if (status_code >= 500) {
        "The gene information service is temporarily experiencing issues."
      } else {
        "There was a problem connecting to the gene information service."
      }
      
      user_actions <- if (status_code == 404) {
        paste0(
          "<div style='margin-top: 10px; padding: 8px; background-color: #e7f3ff; border-left: 3px solid #007bff;'>",
          "<strong>💡 Try These Resources:</strong><br/>",
          "• Search <a href='https://www.genecards.org/cgi-bin/carddisp.pl?gene=", gene_encoded, "' target='_blank'>GeneCards</a><br/>",
          "• Check <a href='https://www.ncbi.nlm.nih.gov/gene/?term=", gene_encoded, "' target='_blank'>NCBI Gene Database</a><br/>",
          "• Browse <a href='https://www.ensembl.org/Multi/Search/Results?q=", gene_encoded, "' target='_blank'>Ensembl Genome Browser</a>",
          "</div>"
        )
      } else {
        paste0(
          "<div style='margin-top: 10px; padding: 8px; background-color: #fff3cd; border-left: 3px solid #ffc107;'>",
          "<strong>🔄 What You Can Do:</strong><br/>",
          "• Please try again in a few moments<br/>",
          "• Check your internet connection<br/>",
          "• If the problem persists, search for '<strong>", gene_clean, "</strong>' on <a href='https://www.google.com/search?q=", gene_encoded, "+gene' target='_blank'>Google</a>",
          "</div>"
        )
      }
      
      error_msg <- paste0(
        "<div style='padding: 12px; border: 1px solid #dc3545; border-radius: 6px; background-color: #f8d7da; color: #721c24; margin: 5px 0;'>",
        "<strong>", error_icon, " ", error_title, "</strong><br/>",
        error_explanation, "<br/>",
        "<small style='color: #6c757d;'>Error Code: ", status_code, "</small>",
        "</div>",
        user_actions
      )
      return(HTML(error_msg))
    }
  }, error = function(e) {
    # User-friendly error message for connection/technical issues
    error_msg <- paste0(
      "<div style='padding: 12px; border: 1px solid #dc3545; border-radius: 6px; background-color: #f8d7da; color: #721c24; margin: 5px 0;'>",
      "<strong>🔌 Connection Problem</strong><br/>",
      "Unable to fetch gene information for '<strong>", gene_clean, "</strong>'.<br/>",
      "<small style='color: #6c757d;'>Technical details: ", e$message, "</small>",
      "</div>",
      "<div style='margin-top: 10px; padding: 8px; background-color: #d1ecf1; border-left: 3px solid #bee5eb;'>",
      "<strong>🔧 Troubleshooting:</strong><br/>",
      "• Check your internet connection<br/>",
      "• Try refreshing the page<br/>",
      "• Search for '<strong>", gene_clean, "</strong>' on <a href='https://www.google.com/search?q=", utils::URLencode(gene_clean, reserved = TRUE), "+gene' target='_blank'>Google</a> or <a href='https://www.genecards.org/cgi-bin/carddisp.pl?gene=", utils::URLencode(gene_clean, reserved = TRUE), "' target='_blank'>GeneCards</a>",
      "</div>"
    )
    return(HTML(error_msg))
  })
}

