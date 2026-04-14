# Base R Shiny image (R 4.5+)
FROM rocker/shiny:4.5.2

ARG CRAN_MIRROR=https://cloud.r-project.org
ENV CRAN_MIRROR=${CRAN_MIRROR}
ENV RENV_CONFIG_AUTOLOADER_ENABLED=FALSE

WORKDIR /home/PTC

RUN apt-get update && apt-get install -y --no-install-recommends \
	libglpk40 \
	libglpk-dev \
	&& rm -rf /var/lib/apt/lists/*

# Bootstrap pak once, then use it for all package installations
RUN Rscript -e "install.packages('pak', repos = Sys.getenv('CRAN_MIRROR', 'https://cloud.r-project.org'))"

# Install dependencies in modular layers for faster rebuilds and easier debugging
COPY docker/install_cran.R /tmp/install_cran.R
RUN Rscript /tmp/install_cran.R

COPY docker/install_github.R /tmp/install_github.R
RUN Rscript /tmp/install_github.R

COPY docker/install_bioc.R /tmp/install_bioc.R
RUN Rscript /tmp/install_bioc.R

# Copy the Shiny app code
COPY . /home/PTC

# Expose the application port
EXPOSE 3838

# Run the R Shiny app
CMD ["R", "-e", "shiny::runApp('/home/PTC', port = 3838, host = '0.0.0.0')"]