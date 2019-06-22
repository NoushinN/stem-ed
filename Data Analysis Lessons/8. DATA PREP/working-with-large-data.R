###DEMO for working with large data in R ###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons)

# What is Scalable Data Processing?
# Load the microbenchmark package
library(microbenchmark)
# 1e5=1∗105=100,000

# Compare the timings for sorting different sizes of vector 
mb <- microbenchmark(
  # Sort a random normal vector length 1e5
  "1e5" = sort(rnorm(1e5)),
  # Sort a random normal vector length 2.5e5
  "2.5e5" = sort(rnorm(2.5e5)),
  # Sort a random normal vector length 5e5
  "5e5" = sort(rnorm(5e5)),
  "7.5e5" = sort(rnorm(7.5e5)),
  "1e6" = sort(rnorm(1e6)),
  times = 10
)

# Plot the resulting benchmark object
plot(mb)

#-------------------------------------------------------------------

# Working with "Out-of-Core" Objects using the Bigmemory Project
# bigmemory is used for matrix data and not data frames
# Reading a big.matrix object
# Load the bigmemory package
library(bigmemory)

# Create the big.matrix object: x 
# data from FHFA mortgage Data Set: Fannie Mae and Federal Home Loan mortgage corporation - Freddie Mac 2009-2015

x <- read.big.matrix("mortgage-sample.csv", header = TRUE, 
                     type = "integer", 
                     backingfile = "mortgage-sample.bin", 
                     descriptorfile = "mortgage-sample.desc")

# Find the dimensions of x
dim(x)

# Now that the big.matrix object is on the disk, we can use the information stored in the descriptor file to instantly make it available during an R session
# Attach mortgage-sample.desc
mort <- attach.big.matrix("mortgage-sample.desc")

# Find the dimensions of mort
dim(mort)

# Look at the first 6 rows of mort
head(mort)

# Creating tables with big.matrix objects
# Look at the first 3 rows
mort[1:3, ]

# Create a table of the number of mortgages for each year in the data set
table(mort[, "year"])

# Load the biganalytics package
library(biganalytics)

# Get the column means of mort
colmean(mort)

# Use biganalytics' summary function to get a summary of the data
summary(mort)

#-------------------------------------------------------------------

# References vs. Copies
# If you want to copy a big.matrix object, then you need to use the deepcopy() function
# This can be useful, especially if you want to create smaller big.matrix objects

# Use deepcopy() to create first_three
first_three <- deepcopy(mort, cols = 1:3, 
                        backingfile = "first_three.bin", 
                        descriptorfile = "first_three.desc")

# Set first_three_2 equal to first_three
first_three_2 <- first_three

# Set the value in the first row and first column of first_three to NA
first_three[1, 1] <- NA

# Verify the change shows up in first_three_2
first_three_2[1, 1]

# but not in mort
mort[1, 1]

#-------------------------------------------------------------------

# Tabulating using bigtable
# Load the bigtabulate package
library(bigtabulate)

# Call bigtable to create a variable called race_table
race_table <- bigtable(mort, "borrower_race")

# Rename the elements of race_table
names(race_table) <- race_cat
race_table


# Create a table of the borrower race by year
race_year_table <- bigtable(mort, c("borrower_race", "year"))

# Convert rydf to a data frame
rydf <- as.data.frame(race_year_table)

# Create the new column Race
rydf$Race <- race_cat

# Let's see what it looks like
rydf

#-------------------------------------------------------------------

# there are lots of other ways you can partition the data
# Split-Apply-Combine (split-map-reduce)

female_residence_prop <- function(x, rows) {
  x_subset <- x[rows, ]
  # Find the proporation of female borrowers in urban areas
  prop_female_urban <- sum(x_subset[, "borrower_gender"] == 2 & 
                             x_subset[, "msa"] == 1) / 
    sum(x_subset[, "msa"] == 1)
  # Find the proporation of female borrowers in rural areas
  prop_female_rural <- sum(x_subset[, "borrower_gender"] == 2 & 
                             x_subset[, "msa"] == 0) / 
    sum(x_subset[, "msa"] == 0)
  
  c(prop_female_urban, prop_female_rural)
}

# Find the proportion of female borrowers in 2015
female_residence_prop(mort, mort[, "year"] == 2015)


# split(): To "split" the mort data by year
# Map(): To "apply" the function female_residence_prop() to each of the subsets returned from split()
# Reduce(): To combine the results obtained from Map()
# Split the row numbers of the mortage data by year

spl <- split(1:nrow(mort), mort[, "year"])

# Call str on spl
str(spl)


# Apply
# Call Map() on each of the row splits of spl
# For each of the row splits, find the female residence proportion
all_years <- Map(function(rows) female_residence_prop(mort, rows), spl)

# Call str on all_years
str(all_years)

# Combine
# Call Reduce() on all_years to combine the results from the previous exercise. 
# The function to apply here is rbind (short for row bind).
# Collect the results as rows in a matrix
prop_female <- Reduce(rbind, all_years)

# Rename the row and column names
dimnames(prop_female) <- list(names(all_years), c("prop_female_urban", "prop_femal_rural"))

# View the matrix
prop_female

#-------------------------------------------------------------------

# Visualize your results using the tidyverse
# The return type of functions in the bigtabulate and biganalytics packages are base R types that can be used just like you would with any analysis. This means that we can visualize results using ggplot2.

# Load the tidyr and ggplot2 packages
library(tidyr)
library(ggplot2)

# Convert prop_female to a data frame
prop_female_df <- as.data.frame(prop_female)

# Add a new column Year
prop_female_df$Year <- row.names(prop_female_df)

# Call gather on prop_female_df
prop_female_long <- gather(prop_female_df, Region, Prop, -Year)

# Create a line plot
ggplot(prop_female_long, aes(x = Year, y = Prop, group = Region, color = Region)) + 
  geom_line()


# Load biganalytics and dplyr packages
library(biganalytics)
library(dplyr)

# Call summary on mort
summary(mort)

bir_df_wide <- bigtable(mort, c("borrower_income_ratio", "year")) %>% 
  # Turn it into a data.frame
  as.data.frame() %>% 
  # Create a new column called BIR with the corresponding table categories
  mutate(BIR = c(">=0,<=50%", ">50, <=80%", ">80%"))

bir_df_wide

# Load the tidyr and ggplot2 packages
library(tidyr)
library(ggplot2)

bir_df_wide %>% 
  # Transform the wide-formatted data.frame into the long format
  gather(Year, Count, -BIR) %>%
  # Use ggplot to create a line plot
  ggplot(aes(x = Year, y = Count, group = BIR, color = BIR)) + 
  geom_line()

#-------------------------------------------------------------------
#-------------------------------------------------------------------

# Introduction to chunk-wise processing when working with data frames

# An operation that gives the same answer whether you apply it to an entire data set or to chunks of a data set and then on the results on the chunks is sometimes called foldable. 
# The max() and min() operations are an example of this. Here, we have defined a foldable version of the range() function that takes either a vector or list of vectors

foldable_range <- function(x) {
  if (is.list(x)) {
    # If x is a list then reduce it by the min and max of each element in the list
    c(Reduce(min, x), Reduce(max, x))
  } else {
    # Otherwise, assume it's a vector and find it's range
    range(x)
  }
}

# Verify that foldable_range() works on the record_number column
foldable_range(mort[, "record_number"])

# Split the mortgage data by year
spl <- split(1:nrow(mort), mort[,"year"])

# Use foldable_range() to get the range of the record numbers
foldable_range(Map(function(s) foldable_range(mort[s, "record_number"]), spl))

#-------------------------------------------------------------------

# A first look at iotools: Importing data
# Compare read.delim() and read.delim.raw()

# Load the iotools and microbenchmark packages
library(iotools)
library(microbenchmark)

# Time the reading of files
microbenchmark(
  # Time the reading of a file using read.delim five times
  read.delim("mortgage-sample.csv", header = FALSE, sep = ","),
  # Time the reading of a file using read.delim.raw five times
  read.delim.raw("mortgage-sample.csv", header = FALSE, sep = ","),
  times = 5
)


# Reading raw data and turning it into a data structure
# Read mortgage-sample.csv as a raw vector
raw_file_content <- readAsRaw("mortgage-sample.csv")

# Convert the raw vector contents to a matrix
mort_mat <- mstrsplit(raw_file_content, sep = ",", type = "integer", skip = 1)

# Look at the first 6 rows
head(mort_mat)

# Convert the raw file contents to a data.frame with 16 integer columns.
mort_df <- dstrsplit(raw_file_content, sep = ",", col_types = rep("integer", 16), skip = 1)

# Look at the first 6 rows
head(mort_df)

#-------------------------------------------------------------------

# chunk.apply
# Reading chunks in as a matrix
# Define the function to apply to each chunk
make_table <- function(chunk) {
  # Read each chunk as a matrix
  x <- mstrsplit(chunk, type = "integer", sep = ",")
  # Create a table of the number of borrowers (column 3) for each chunk
  table(x[, 3])
}

# Define the function to apply to each chunk
make_table <- function(chunk) {
  # Read each chunk as a matrix
  x <- mstrsplit(chunk, type = "integer", sep = ",")
  # Create a table of the number of borrowers (column 3) for each chunk
  table(x[, 3])
}

# Create a file connection to mortgage-sample.csv
fc <- file("mortgage-sample.csv", "rb")

# Read the first line to get rid of the header
readLines(fc, n = 1)

# Read the data in chunks
counts <- chunk.apply(fc, make_table, CH.MAX.SIZE = 1e5)

# Close the file connection
close(fc)


# Reading chunks in as a matrix
# Define the function to apply to each chunk
make_table <- function(chunk) {
  # Read each chunk as a matrix
  x <- mstrsplit(chunk, type = "integer", sep = ",")
  # Create a table of the number of borrowers (column 3) for each chunk
  table(x[, 3])
}

# Create a file connection to mortgage-sample.csv
fc <- file("mortgage-sample.csv", "rb")

# Read the first line to get rid of the header
readLines(fc, n = 1)

# Read the data in chunks
counts <- chunk.apply(fc, make_table, CH.MAX.SIZE = 1e5)

# Close the file connection
close(fc)

# Print counts
counts


# Reading chunks in as a data.frame
# Define the function to apply to each chunk
make_msa_table <- function(chunk) {
  # Read each chunk as a data frame
  x <- dstrsplit(chunk, col_types = rep("integer", length(col_names)), sep = ",")
  # Set the column names of the data frame that's been read
  colnames(x) <- col_names
  # Create new column, msa_pretty, with a string description of where the borrower lives
  x$msa_pretty <- msa_map[x$msa + 1]
  # Create a table from the msa_pretty column
  table(x$msa_pretty)
}

# Create a file connection to mortgage-sample.csv
fc <- file("mortgage-sample.csv", "rb")

# Read the first line to get rid of the header
readLines(fc, n = 1)

# Read the data in chunks
counts <- chunk.apply(fc, make_msa_table, CH.MAX.SIZE = 1e5)

# Close the file connection
close(fc)

# Aggregate the counts as before
colSums(counts)


# Sum up the chunks
colSums(counts)


# Parallelizing calls to chunk.apply
# The chunk.apply() function can also make use of parallel processes to process data more quickly. 
# When the parallel parameter is set to a value greater than one on Linux and Unix machine (including the Mac) multiple processes read and process data at the same time thereby reducing the execution time. 
# On Windows the parallel parameter is ignored.


iotools_read_fun <- function(parallel) {
  fc <- file("mortgage-sample.csv", "rb")
  readLines(fc, n = 1)
  chunk.apply(fc, make_msa_table,
              CH.MAX.SIZE = 1e5, parallel = parallel)
  close(fc)
}

# Benchmark the new function
microbenchmark(
  # Use one process
  iotools_read_fun(parallel = 1), 
  # Use three processes
  iotools_read_fun(parallel = 3), 
  times = 20
)

#-------------------------------------------------------------------

# Exercise
# Race and Ethnic Representation in the Mortgage Data
# Create a table of borrower_race column
race_table <- bigtable(mort, "borrower_race")

# Rename the elements
names(race_table) <- race_cat[as.numeric(names(race_table))]

# Find the proportion
race_table[1:7] / sum(race_table[1:7])

# Create table of the borrower_race 
race_table_chunks <- chunk.apply(
  "mortgage-sample.csv", function(chunk) { 
    x <- mstrsplit(chunk, sep = ",", type = "integer") 
    colnames(x) <- mort_names 
    table(x[, "borrower_race"])
  }, CH.MAX.SIZE = 1e5)

# Add up the columns
race_table <- colSums(race_table_chunks)

# Find the proportion
borrower_proportion <- race_table[1:7] / sum(race_table[1:7])

# Create the matrix
matrix(c(pop_proportion, borrower_proportion), byrow = TRUE, nrow = 2,
       dimnames = list(c("Population Proportion", "Borrower Proportion"), race_cat[1:7]))

#-------------------------------------------------------------------

# Looking for Predictable Missingness
# If data are missing completely at random, then you shouldn't be able to predict when a variable is missing based on the rest of the data. 
# Therefore, if you can predict missingness then the data are not missing completely at random. 
# So, let's use the glm() function to fit a logistic regression, looking for missingness based on affordability in the mort variable you created earlier. 
# If you don't find any structure in the missing data - i.e., the slope variables are not significant - it does not mean that you have proven the data are missing at random, but it is plausible.


# Create a variable indicating if borrower_race is missing in the mortgage data
borrower_race_ind <- mort[, "borrower_race"] == 9

# Create a factor variable indicating the affordability
affordability_factor <- factor(mort[, "affordability"])

# Perform a logistic regression
summary(glm(borrower_race_ind ~ affordability_factor, family = binomial))


# use both iotools and bigtabulate to tabulate borrower race and ethnicity by year.
# Open a connection to the file and skip the header
fc <- file("mortgage-sample.csv", "rb")
readLines(fc, n = 1)

# Create a function to read chunks
make_table <- function(chunk) {
  # Create a matrix
  m <- mstrsplit(chunk, sep = ",", type = "integer")
  colnames(m) <- mort_names
  # Create the output table
  bigtable(m, c("borrower_race", "year"))
}

# Import data using chunk.apply
race_year_table <- chunk.apply(fc, make_table)

# Close connection
close(fc)

# Cast it to a data frame
rydf <- as.data.frame(race_year_table)

# Create a new column Race with race/ethnicity
rydf$Race <-  race_cat

#-------------------------------------------------------------------

# Visualizing the Adjusted Demographic Trends
# View rydf
rydf 

# View pop_proportion
pop_proportion

# Gather on all variables except Race
rydfl <- gather(rydf, Year, Count, -Race)

# Create a new adjusted count variable
rydfl$Adjusted_Count <- rydfl$Count / pop_proportion[rydfl$Race]

# Plot
ggplot(rydfl, aes(x = Year, y = Adjusted_Count, group = Race, color = Race)) + 
  geom_line()

# View rydf
rydf

# Normalize the columns
for (i in seq_len(nrow(rydf))) {
  rydf[i, 1:8] <- rydf[i, 1:8] / rydf[i, 1]
}

# Convert the data to long format
rydf_long <- gather(rydf, Year, Proportion, -Race)

# Plot
ggplot(rydf_long, aes(x = Year, y = Proportion, group = Race, color = Race)) + 
  geom_line()

#-------------------------------------------------------------------

# Borrower Lending Trends: City vs. Rural
# In this exercise you'll tabulate the data by year and the msa (city vs rural) variable.

## Create a function make_table() that reads in chunk as a matrix and then tabulates it by borrower region (msa) and year.
## Use chunk.apply() to import the data from the file connection we created for you.

# Open a connection to the file and skip the header
fc <- file("mortgage-sample.csv", "rb")
readLines(fc, n = 1)

# Create a function to read chunks
make_table <- function(chunk) {
  # Create a matrix
  m <- mstrsplit(chunk, sep = ",", type = "integer")
  colnames(m) <- mort_names
  # Create the output table
  bigtable(m, c("msa", "year"))
}

# Import data using chunk.apply
msa_year_table <- chunk.apply(fc, make_table)

# Close connection
close(fc)

# Convert to a data frame
df_msa <- as.data.frame(msa_year_table)

# Rename columns
df_msa$MSA <- c("rural", "city")

# Gather on all columns except Year
df_msa_long <- gather(df_msa, Year, Count, -MSA)

# Plot 
ggplot(df_msa_long, aes(x = Year, y = Count, group = MSA, color = MSA)) + 
  geom_line()

## Use the bigtable() function to make a table of the borrower_income_ratio by federal_guarantee.
## For each row in ir_by_fg, divide by the sum of the row.
# Tabulate borrower_income_ratio and federal_guarantee
ir_by_fg <- bigtable(mort, c("borrower_income_ratio", "federal_guarantee"))

# Label the columns and rows of the table
dimnames(ir_by_fg) <- list(income_cat, guarantee_cat)

# For each row in ir_by_fg, divide by the sum of the row
for (i in seq_len(nrow(ir_by_fg))) {
  ir_by_fg[i, ] <- ir_by_fg[i, ] / sum(ir_by_fg[i, ])
}

# Print
ir_by_fg
