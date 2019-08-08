###DEMO for dealing with missing values in R###
# lessons curated by Noushin Nabavi, PhD 

# load library
library(tidyverse)
library(naniar)

# Create x, a vector, with values NA, NaN, Inf, ".", and "missing"
x <- c(NA, NaN, Inf, ".", "missing")

# Use any_na() and are_na() on to explore the missings
any_na(x)
are_na(x)

# Use n_miss() to count the total number of missing values in x
n_miss(x)

# Use n_complete() on dat_hw to count the total number of complete values
n_complete(x)


# Use prop_miss() and prop_complete on dat_hw to count the total number of missing values in each of the variables
prop_miss(x)
prop_complete(x)

# starwars data to use to find missing values

# summarizing missingness
starwars %>%
  miss_var_summary()

starwars %>%
  group_by(birth_year) %>%
  miss_var_summary()

# # Return the summary of missingness in each case, by group
starwars %>%
  miss_case_summary()

starwars %>%
  group_by(birth_year) %>%
  miss_case_summary()

# Tabulate missingness in each variable and case of the dataset
starwars %>%
  miss_var_table()

# Tabulate the missingness in each variable and in grouped_by
starwars %>%
  miss_case_table()

starwars %>%
  group_by(birth_year) %>%
  miss_var_table()

# Tabulate the missingness in each variable and in grouped_by
starwars %>%
  miss_case_table()

starwars %>%
  group_by(birth_year) %>%
  miss_case_table()

# Other summaries of missingness
# Calculate the summaries for each span of missingness

# For each `birth_year` variable, calculate the run of missingness
starwars %>%
  miss_var_run(var = birth_year)

# For each `birth_year` variable, calculate the run of missingness every 2 years
starwars %>%
  miss_var_span(var = birth_year, span_every = 2)

#------------------------------------------------------------------------------

# Visualize missing values
vis_miss(starwars)

# Visualize and cluster all of the missingness 
vis_miss(starwars, cluster = TRUE)

# Visualize and sort the columns by missingness
vis_miss(starwars, sort_miss = TRUE)

# Visualizing missing cases and variables
# Visualize the number of missings in variables using `gg_miss_var()`
gg_miss_var(starwars)
gg_miss_var(starwars, facet = birth_year)

# Explore the number of missings in cases using `gg_miss_case()` and facet by the variable `birth_year`
gg_miss_var(starwars)
gg_miss_case(starwars, facet = birth_year)

# Explore the missingness pattern using gg_miss_upset()
gg_miss_upset(starwars)

# Explore how the missingness changes across the birth_year variable using gg_miss_fct()
gg_miss_fct(starwars, fct = birth_year)

# and explore how missingness changes for a span of 2 years 
gg_miss_span(starwars, var =birth_year, span_every = 100, facet = mass) # also possible to facet


#------------------------------------------------------------------------------

# Searching for and replacing missing values














