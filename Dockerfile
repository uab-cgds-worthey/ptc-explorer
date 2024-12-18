# Base R Shiny image
FROM rocker/shiny
RUN apt-get update && apt-get install -y libglpk40 libglpk-dev
 
# Install R dependencies
RUN R -e 'install.packages(c("shinybusy","shinycssloaders","shinyWidgets","BiocManager","dplyr","reshape2","scales","stringr","RColorBrewer","plotly","DT","reactable","httr","jsonlite", "devtools"))'
RUN R -e 'devtools::install_github("wjawaid/enrichR")'
Run R -e 'BiocManager::install(c("EnhancedVolcano","gprofiler2","ComplexHeatmap","InteractiveComplexHeatmap"))'

RUN mkdir /home/PTC

# Copy the Shiny app code
COPY . /home/PTC

# Expose the application port
EXPOSE 3838

# Run the R Shiny app
CMD R -e 'shiny::runApp("/home/PTC",port = 3838, host = "0.0.0.0")'