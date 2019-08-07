###DEMO for data import into R in batch using functions###
# lessons curated by Noushin Nabavi, PhD

# load library dependencies

library(here)
library(tidyverse)
library(readxl)
library(data.table)
library(readr)
library(purrr)
library(dplyr)

#-------------------------------------------------------------------------------
# assign file paths
here()

IND_path <- list.files(here("ind", "xls", "merged ind csvs"), pattern = ".*csv")
print(IND_path)

x <- read_csv_files(IND_path)

FAM_path <- list.files(here("fam", "merged fam"), pattern = ".*csv")
print(FAM_path)

#-------------------------------------------------------------------------------
# finding columns and rows for one file at a time
nrow(fread(here("ind", "xls", "merged ind csvs", "1_IND.csv")))
ncol(fread(here("ind", "xls", "merged ind csvs", "1_IND.csv")))
#-------------------------------------------------------------------------------

# function to read files in batches for individuals

read_csv_files <- IND_path %>%
    map(function(x) nrow(fread(file.path(here("ind", "xls", "merged ind csvs"), x)))) %>%
    reduce(rbind)

x <- read_csv_files
class(x)

read_csv_files <- IND_path %>%
  map(function(y) ncol(fread(file.path(here("ind", "xls", "merged ind csvs"), y)))) %>%
  reduce(rbind)

y <- read_csv_files
class(y)
#-------------------------------------------------------------------------------

IND <- cbind(x,y)
colnames(IND) <- c("rows", "columns")
rownames(IND) <- IND_path

write.csv(IND, "individual_tables.csv")
#-------------------------------------------------------------------------------

# function to read files in batches for families

read_csv_files <- FAM_path %>%
  map(function(x) nrow(fread(file.path(here("fam", "merged fam"), x)))) %>%
  reduce(rbind)

h <- read_csv_files
class(h)

read_csv_files <- FAM_path %>%
  map(function(y) ncol(fread(file.path(here("fam", "merged fam"), y)))) %>%
  reduce(rbind)

z <- read_csv_files
class(z)
#-------------------------------------------------------------------------------

FAM <- cbind(h,z)
colnames(FAM) <- c("rows", "columns")
rownames(FAM) <- FAM_path

write.csv(FAM, "families_tables.csv")
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# finding year range of each csv
unique(fread(here("ind", "xls", "merged ind csvs", "1_IND.csv"))$year)

# or
fread(here("ind", "xls", "merged ind csvs", "1_IND.csv")) %>%
  select(year) %>%
  unique() %>%
  reduce(rbind)

#-------------------------------------------------------------------------------
# function to get the years of individual data frames
csv_year_range_ind <- function(path) {
  path %>%
  file_years <- map(function(p) list("name" = p, "content"= unique(fread(here("ind", "xls", "merged ind csvs", p))$year))) %>%
  map(function(q) write.csv(q$content, file = paste(q$name)))
}

k <- csv_year_range_ind(IND_path)
#-------------------------------------------------------------------------------
# function to get the years of family data frames

csv_year_range_fam <- function(path) {
  path %>%
  map(function(p) list("name" = p, "content"= unique(fread(here("fam", "merged fam", p))$year))) %>%
  map(function(q) write.csv(q$content, file = paste(q$name)))
}

k <- csv_year_range_fam(FAM_path)
#-------------------------------------------------------------------------------

IND_years <- list.files(here(), pattern = ".*IND.csv")

ind_file_names <- function(path) {
  get_file_name <- path %>%
    basename() %>%
    tools::file_path_sans_ext()
}

read_files <- function(path) {
  file <- path %>%
  map(function(x) setnames(fread(x), c("table", "year"))) %>%
    select(table <- s)

  merged_table <- do.call(plyr::rbind.fill, file)
  write_csv(merged_table, "merged_IND.csv")
}

s <- ind_file_names(IND_years)
i <- read_files(IND_years)
#-------------------------------------------------------------------------------

FAM_years <- list.files(here(), pattern = ".*FAM.csv")

ind_file_names <- function(path) {
  get_file_name <- path %>%
    basename() %>%
    tools::file_path_sans_ext()
}

read_files <- function(path) {
  file <- path %>%
    map(function(x) setnames(fread(x), c("table", "year"))) %>%
    select(table <- r)

  merged_table <- do.call(plyr::rbind.fill, file)
  write_csv(merged_table, "merged_FAM.csv")
}

r <- ind_file_names(FAM_years)
w <- read_files(FAM_years)

#-------------------------------------------------------------------------------

# selecting one of only unique observations
library(janitor)
library(broom)

# example

mtcars %>%
  group_by(mpg) %>%
  slice(1) %>%
  rename_all(function(x)
    paste0(x, "_datafile1")) %>%
  clean_names() %>%
  rename("mpg" = "mpg_datafile1")

#-------------------------------------------------------------------------------

# function to write a path specific to today
todays_file <- paste0("file_", format(Sys.Date(), "%d%B%Y"), ".csv")
write_csv(mtcars, file.path(tmp, todays_file), na = "")

#-------------------------------------------------------------------------------

# other filterings
mtcars %>%
  distinct(mpg, .keep_all = TRUE)
