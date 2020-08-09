# list of libraries
libraries <- c("tidyverse", "data.table", "here", "table1", "knitr",
               "fpp2", "lubridate", "httr", "shiny", "sf", "viridis",
               "ggthemes", "rgdal", "zoo", "naniar", "wesanderson")

# load libraries
lapply(libraries, library, character.only = TRUE)

# source the script
.setup_sourced <- TRUE
