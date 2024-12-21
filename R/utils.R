## Utility functions for cleaning and formatting
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
  if (rename_cols) {
    colnames(sig_df) <- c("ENTREZ ID",
                          "SYMBOL",
                          "ENSEMBL",
                          "Log2FC",
                          "P-Value",
                          "Adj. P-Value")
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
  base_url <- "https://mygene.info/v3/gene/"
  gene <- gene
  species <- paste0("species=", species)
  fields <- paste("fields=name",
                  "symbol",
                  "entrezgene",
                  "ensembl.gene",
                  "summary",
                  sep = ",")
  api_url <- paste0(base_url, gene, "?", species, "&", fields)
  tryCatch({
    response <- httr::GET(api_url)
    # Check if the request was successful (status code 200)
    if (status_code(response) == 200) {
      # Parse the JSON response
      response_content <-
        httr::content(response, as = "text", encoding = "UTF-8")
      parsed_data <- fromJSON(response_content)
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
      return("No information found. Please use google.")
    }
  })
}

############### Gene query by symbol
gene_query <- function(gene,
                       species = "human",
                       hit = 1,
                       ...) {
  base_url <- "https://mygene.info/v3/query?"
  size <- paste0("size=", hit)
  q_symbol <- paste0("symbol:", gene)
  q_species <- paste0("species=", species)
  q_fields <- paste("fields=name",
                    "symbol",
                    "entrezgene",
                    "ensembl.gene",
                    "summary",
                    sep = ",")
  q <- paste(q_symbol, size, q_species, q_fields, sep = "&")
  api_url <- paste0(base_url, "q=", q)
  tryCatch({
    response <- httr::GET(api_url)
    # Check if the request was successful (status code 200)
    if (status_code(response) == 200) {
      # Parse the JSON response
      response_content <-
        httr::content(response, as = "text", encoding = "UTF-8")
      parsed_data <- fromJSON(response_content)
      if (length(parsed_data$hits) == 0) {
        gene_annotated(gene)
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
      return("No information found. Please use google.")
    }
  })
}
