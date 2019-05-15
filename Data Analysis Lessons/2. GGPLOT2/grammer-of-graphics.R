###DEMO for grammer of graphics in R###
# lessons curated by Noushin Nabavi, PhD

# load dependencies
library(tidyverse)
library(ggplot2)
library(httr)

# print dataframe to inspect
url = "https://paldhous.github.io/ucb/2016/dataviz/data/week3.zip"

data <- read.csv(url, stringsAsFactors = FALSE, header = TRUE, sep = ",")

# set x aesthetic to region column
ggplot(who_disease, aes(x = region)) +
  geom_bar()