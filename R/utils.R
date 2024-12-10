##### 
## Utility functions for cleaning and formatting


clean_deg_df <- function(deg_df){

  
 
  
  
}


gene_info <- function(gene, species = NULL){
  
  
  tryCatch({
    response <- httr::GET(paste0(
      'https://rest.rgd.mcw.edu/rgdws/genes/',gene,'/1'
    ))
    
    # Check if the request was successful (status code 200)
    if (status_code(response) == 200) {
      
      # Parse the JSON response
      response_content <- httr::content(response, as = "text", encoding = "UTF-8")
      parsed_data <- fromJSON(response_content)
      
      # Extract relevant fields from the response
      gene_symbol <- parsed_data$symbol
      description <- parsed_data$description
      merged_description <- parsed_data$mergedDescription
      
      
      # HTML(paste("hello", "world", sep="<br/>"))
      
      result <- paste0(
        "<strong>Gene:</strong> ",
        gene_symbol, "</br>",
        "<strong>Description:</strong> ",
        description, "</br>",
        "<strong>Merged Description:</strong> ",
        merged_description
      )
      
      return(HTML(result))
      
    } else {
      # If the request failed, return the status code and message
      return(
        "No information found. Please use google."
        #paste("Error:", status_code(response))
      )
    }
    
  })
  
  
}