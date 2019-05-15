###DEMO for synthesizing fake data in R###
# lessons curated by Noushin Nabavi, PhD 

# load dependencies
library(synthpop)
library(tidyverse)
library(data.table)
library(here)


# here we sunthesiste a data set using default methods of syn()
vars <- c("sex", "age", "placesize", "edu", "socprof", "marital", "income", "smoke")
syn <- SD2011[, vars]

# generate synthetic data with studyids and rearrange
syn$studyid <- paste0("s", sample(100000000:200000000, 5000, replace=TRUE))
syn <- syn[,c(9, 2:8)]

# generate unlinked studyids
syn_rep <- sample_n(syn, 2000, replace = TRUE) %>%
  mutate(studyid = str_replace_all(studyid, "s","u")) 

# bind tables with linked and unlinked studyids
data <- rbind(syn, syn_rep)


# add geo column to the data 
geo <- c("3", "6", "7", "8", "9", "10", "11", "12", "21", 
         "31", "41", "51", "61", "42")

# repeat to the length of columns in data
data$geo <- rep(geo, 500)


# add postal code column to the data 
pc <- c("V8V", "95678", "59899", "V99", "V8V1T5")

# repeat to the length of columns in data
data$pc <- rep(pc, 1400)


# write out the data table
write_csv(data, here("data", "synthetic-data.csv"))

# test the data by reading into R again
syn_data <- fread(here("data", "synthetic-data.csv"))
