###DEMO for converting fst to csf files in R ###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons)

# load dependencies
library(fst)
library(fs)
library(here)
library(purrr)

# use here
set_here("xyz")

# read fst and write csv
x_fst <- read_fst("xx.fst")
fwrite(x_fst, here("xx.csv"))

#---------------------------------------------------------
# Using a function to read in fst files and convert to csv

path <- ("xyz")
paths <- list.files("xyz", pattern = "*.fst")
print(paths)

fst_to_csv <- function(path) {
  
  # set file names
  path %>%
    basename() %>%
    tools::file_path_sans_ext() %>%
    map(function(p) list("name" = p, "content" = read_fst(past0(file_path, p, ".fst")))) %>%
    map (function(q) write.csv(q$content, file = paste(q$name, ".csv")))
    
}

x <- fst_to_csv(paths)

