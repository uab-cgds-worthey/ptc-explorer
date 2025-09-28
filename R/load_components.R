# Load utils
source("R/utils.R")
# Load modules
sapply(list.files("modules", full.names = TRUE), function(x) source(x))
# Load user interface
sapply(list.files("user_interface", full.names = TRUE), function(x) source(x))

