###DEMO for data.tables ###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# working with data.tables and some quick tips

# If you don't have ElemStatLearn, you can install it, by running
# install.packages("ElemStatLearn")

# Load data and dependencies: 
library(ElemStatLearn)
data("SAheart")


____________________________________________________________________________
# Examine data
head(SAheart)
class(SAheart) # this is a data.frame

# let's convert to data.table
SAheart <- data.table(SAheart)

class(SAheart) # now, it is also data.table 
str(SAheart)

# selecting columns with .()
SAheart[, .(adiposity, age)]

# can also subset using .SD = subset of data for columns selection
cols <- c("adiposity", "age", "famhist")
SAheart[, .SD, .SDcols = cols] # this is identical as SAheart[, .SD, .SDcols = c("adiposity", "age", "famhist")]

# grep in base R allows for returns of strings matching a pattern
grep(pattern = 'ty', c('obesity', 'adiposity'))
grep(pattern = 'ty', c('obesity', 'adiposity'), value = TRUE)

# flexible data selection (more fine grained control)
SAheart[, age]
SAheart[which.max(age)]

# can use get() function
fam_hist <-"famhist"
SAheart[, get(fam_hist)]

#re-usable functions without hard-coding column names
square_col <- function(x, col_names) {
  return(x[,get(col_names) ^2])
}

square_col(SAheart, "ldl") # ldl^2

# can create a new name with the new column: using()
severity <- function(x, new_name) {
  x[,(new_name) :=tobacco * chd]
}

severity(SAheart, "severe")
print(SAheart)

# changing names with setnames()
setnames(SAheart, old ="severe", new = "severity_index")
names(SAheart)

# can also use the setnames() in a function
tag_columns <- function(x, cols) {
  setnames(x, old = cols, new = paste0(cols, "tagged"))
}

tag_columns(SAheart, "ldl")
SAheart

# executing functions inside data.tables
SAheart[which.max(sbp)]
SAheart[sbp > max(sbp) - 60 * 8]

cor(SAheart[, .SD, .SDcols = c('adiposity', 'tobacco')])

# use by() to dynamically group data
SAheart[, mean(agetagged), by = chd][order(chd)]

# lapply() to get a data.table back and sapply() to get a vector back
SAheart[, lapply(.SD, function(x) {mean(is.na(x), na.rm = TRUE)})] #count NA values

# can use round() to get to the nearest 10
SAheart[, adiposity := round(as.numeric)]

