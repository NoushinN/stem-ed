###DEMO for cleaning data in R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for cleaning data into R)

# example data for this lesson can be downloaded from devtools/github source
install.packages("devtools")
library("devtools")
install_github("Ram-N/weatherData")

# load weather library
library(weatherData)
# Data - Ambient Temperature For The City Of Mumbai, India For All Of 2013
data(Mumbai2013)
print(Mumbai2013)

# Verify that weather is a data.frame
class(Mumbai2013)

# Check the dimensions
dim(Mumbai2013)

# View the column names
names(Mumbai2013)

# View the structure of the data
str(Mumbai2013)

# Load dplyr package
library(dplyr)

# Look at the structure using dplyr's glimpse()
glimpse(Mumbai2013)

# View a summary of the data
summary(Mumbai2013)

# View first 6 rows
head(Mumbai2013)

# View first 15 rows
head(Mumbai2013, 15)

# View the last 6 rows
tail(Mumbai2013)

# View the last 10 rows
tail(Mumbai2013, 10)

#-------------------------------------------------------------------

# Column names are values of year and time so can be separated
# Load the tidyr package
library(tidyr)

#Call gather() with four arguments:
## The name of the data object
## The name of the new column whose values will be what are now the column headers (i.e. the key argument)
## The name of the new column whose values will be the actual BMI measurements (i.e. the value argument)
## The columns to gather (or, in this case, the column to exclude from gathering)
### e.g. bmi_long <- gather(bmi, year, bmi_val, -Country)


# Gather the columns
Mumbai_clean <- gather(Mumbai2013, Time, Temperature, na.rm = TRUE)

# View the head
head(Mumbai_clean)

