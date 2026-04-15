# Base R Shiny image (R 4.5+)
FROM rocker/shiny:4.5.2

ARG CRAN_MIRROR=https://cloud.r-project.org
ENV CRAN_MIRROR=${CRAN_MIRROR}
ENV RENV_CONFIG_PAK_ENABLED=TRUE
ENV RENV_CONFIG_AUTOLOADER_ENABLED=false

WORKDIR /home/PTC

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl \
	perl \
	pkg-config \
	libglpk40 \
	libglpk-dev \
	libssl-dev \
	libxml2-dev \
	libcurl4-openssl-dev \
	libharfbuzz-dev \
	libfribidi-dev \
	libfreetype6-dev \
	libfontconfig1-dev \
	libpng-dev \
	&& rm -rf /var/lib/apt/lists/*

# Restore the project library from the lockfile before copying the app source.
COPY renv.lock /home/PTC/renv.lock
COPY renv/activate.R /home/PTC/renv/activate.R
COPY renv/settings.json /home/PTC/renv/settings.json

RUN Rscript -e "if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv', repos = Sys.getenv('CRAN_MIRROR', 'https://cloud.r-project.org')); options(renv.config.pak.enabled = TRUE); restore_res <- try(renv::restore(prompt = FALSE, lockfile = '/home/PTC/renv.lock'), silent = TRUE); if (inherits(restore_res, 'try-error')) { message('pak-enabled restore failed, retrying with standard renv restore.'); options(renv.config.pak.enabled = FALSE); renv::restore(prompt = FALSE, lockfile = '/home/PTC/renv.lock') }"

# Copy the Shiny app code
COPY . /home/PTC

# Expose the application port
EXPOSE 3838

# Run the R Shiny app (skip site/user profiles to avoid renv autoloader re-bootstrap)
CMD ["R", "--no-save", "--no-site-file", "--no-init-file", "-e", "shiny::runApp('/home/PTC', port = 3838, host = '0.0.0.0')"]
