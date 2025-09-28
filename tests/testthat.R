library(testthat)
library(shiny)
library(httr)
library(jsonlite)

# Load the application code
source("../../R/utils.R", chdir = TRUE)
source("../../global.R", chdir = TRUE)

test_check("ptc-explorer")