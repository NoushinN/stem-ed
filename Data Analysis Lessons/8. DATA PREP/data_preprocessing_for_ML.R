###DEMO for data preparation in R###
# lessons curated by Noushin Nabavi, PhD 


# Data Preprocessing

# Importing the dataset
dataset = read.csv('Data.csv')

# Taking care of missing data
dataset$Age = ifelse(is.na(dataset$Age),
                     ave(dataset$Age, FUN = function(x) mean(x, na.rm = TRUE)),
                     dataset$Age)
dataset$Salary = ifelse(is.na(dataset$Salary),
                        ave(dataset$Salary, FUN = function(x) mean(x, na.rm = TRUE)),
                        dataset$Salary)

# Encoding categorical data
dataset$Country = factor(dataset$Country,
                         levels = c('Iran', 'Israel', 'USA'),
                         labels = c(1, 2, 3))
dataset$Purchased = factor(dataset$Purchased,
                           levels = c('No', 'Yes'),
                           labels = c(0, 1))


# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(234) # could be any number
split = sample.split(dataset$Purchased, SplitRatio = 0.8) #purchased is the dependent variable
training_set = subset(dataset, split == TRUE) # independent variables
test_set = subset(dataset, split == FALSE) # dependent variables

# Feature Scaling, to scale age and salary based on euclidean distance
# standardization (using mean, std) or normalization (using min, max)
training_set[,2:3] = scale(training_set[,2:3])
test_set[,2:3] = scale(test_set[,2:3])
