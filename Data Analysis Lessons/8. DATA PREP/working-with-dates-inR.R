###DEMO for web scraping and reading data into R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for working with dates)

# Rule to work with dates according to ISO 8601 standard
# format is YYYY-MM-DD 

# The date R 3.0.0 was released
x <- "2013-04-03"

# Examine structure of x
str(x)

# Use as.Date() to interpret x as a date
x_date <- as.Date(x)

# Examine structure of x_date
str(x_date)

# Store April 10 2014 as a Date
april_10_2014 <- as.Date("2014-04-10")


# Load the readr package which also has build-in functions for dealing with dates
library(readr)

# example data for this lesson can be downloaded from devtools/github source
install.packages("devtools")
library("devtools")
install_github("Ram-N/weatherData")

# load weather library
library(weatherData)
# Data - Ambient Temperature For The City Of Mumbai, India For All Of 2013
data(Mumbai2013)
print(Mumbai2013)


# Examine the structure of the date column
str(Mumbai2013$Time)

# Load the anytime package
library(anytime)

# Various ways of writing Sep 10 2009
sep_10_2009 <- c("September 10 2009", "2009-09-10", "10 Sep 2009", "09-10-2009")

# Use anytime() to parse sep_10_2009
anytime(sep_10_2009)

