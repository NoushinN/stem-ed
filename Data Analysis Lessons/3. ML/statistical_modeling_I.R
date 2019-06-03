###DEMO for mathematical models I in R###
# lessons curated by Noushin Nabavi, PhD
# Kudos to https://www.rdocumentation.org/packages/statisticalModeling/versions/0.3.0

# Load dependent packages
library(tidyverse)
library(ggplot2)
library(mosaicData)
library(statisticalModeling)
library(rpart)

#-------------------------------------------------------------------------------

# load data for this exercise
demog <- mosaicData::CPS85
Riders <- mosaicData::Riders
Trucks <- statisticalModeling::Trucking_jobs
AARP <- statisticalModeling::AARP

#-------------------------------------------------------------------------------

# Find the mean cost broken down by sex
mean(AARP$Cost)

# Create a boxplot using base, lattice, or ggplot2
boxplot(Cost ~ Sex, data = AARP)

# Make a scatterplot using base, lattice, or ggplot2
plot(Cost ~ Age, data = AARP)

#-------------------------------------------------------------------------------

# modeling:
## exploring linear vs recursive modeling architectures

# Find the variable names in the dataset demog
names(demog)

# Build models: demog_model_1, demog_model_2, demog_model_3
# all linear models
demog_model_1 <- lm(wage ~ age, data = demog)
demog_model_2 <- lm(wage ~ educ, data = demog)
demog_model_3 <- lm(wage ~ exper + age, data = demog)

# For now, here's a way to visualize the models
fmodel(demog_model_1)
fmodel(demog_model_2)
fmodel(demog_model_3)

#-------------------------------------------------------------------------------

# Load rpart if not loaded
# library(rpart)

# Build rpart model: model_2
# recursive models
model_2 <- rpart(wage ~ exper + age, data = demog, cp = 0.002)

# Examine graph of model_2 (don't change)
fmodel(model_2, ~ exper + age)

#-------------------------------------------------------------------------------

# Build a model for wage using statisticalModeling
wage_model <- lm(wage ~ sex + age, data = demog)

# Construct a data frame:
new_dataframe <- data.frame(age = 60, sex = "F", wage = 4.00)

# Predict how wage model holds for new dataframe using predict()
predict(wage_model, newdata = new_dataframe)

# Calculate model output using evaluate_model()
evaluate_model(wage_model, data = new_dataframe)

#-------------------------------------------------------------------------------

# Build a model: wage_model
wage_model <- lm(wage ~ sex + age, data = demog)

# Create a data frame: new_inputs_1
new_inputs_1 <- data.frame(age = c(30, 50), sex = c("F", "M"),
                           wage = c(4.00, 6.00))

# Use expand.grid(): new_inputs_2
new_inputs_2 <- expand.grid(age = c(30, 50), sex = c("F", "M"),
                            wage = c(4.00, 6.00))

# Use predict() for new_inputs_1 and new_inputs_2
predict(wage_model, newdata = new_inputs_1)
predict(wage_model, newdata = new_inputs_2)

# Use evaluate_model() for new_inputs_1 and new_inputs_2
evaluate_model(wage_model)
evaluate_model(wage_model, data = new_inputs_1)
evaluate_model(wage_model, data = new_inputs_2)

#-------------------------------------------------------------------------------

# Evaluate insurance_cost_model
evaluate_model(wage_model)

# Use fmodel() to reproduce the graphic
fmodel(wage_model, ~ wage + age + sex)

# A new formula to highlight difference in sexes
new_formula <- ~ wage + age + sex

# Make the new plot (don't change)
fmodel(wage_model, new_formula)

#-------------------------------------------------------------------------------

# exploraing explanatory (independent, x) and response (dependent, y) variables
## categorical response variables: use rpart()
## numerical response variables: use lm() or rpart()
### rpart() is used for disconnected variables

# Build a model of net running time
wage_model <- lm(wage ~ sex + age, data = demog)

# Evaluate base_model on the training data
wage_model_output <- predict(wage_model, data = demog)

# Build the augmented model
aug_model <- lm(wage ~ sex + age + exper, data = demog)

# Evaluate aug_model on the training data
aug_model_output <- predict(aug_model, data = demog)

# How much do the model outputs differ?
mean((aug_model_output - wage_model_output) ^ 2, na.rm = TRUE)

#-------------------------------------------------------------------------------

# numerical variables
# Build and evaluate the wage model on demog
wage_model <- lm(wage ~ sex + age, data = demog)
wage_model_output <- predict(wage_model, data = demog)

# Build and evaluate the augmented model on Runners_100
aug_model <- lm(wage ~ sex + age + exper, data = demog)
aug_model_output <- predict(aug_model, data = demog)

# Find the case-by-case differences
wage_model_differences <- with(demog, wage - wage_model_output)
aug_model_differences <- with(demog, wage - aug_model_output)

# Calculate mean square errors
mean(wage_model_differences ^ 2)
mean(aug_model_differences ^ 2) # the augmented model gives slightly better predictions

#-------------------------------------------------------------------------------

# Another exercise for numerical variables
# Cross validation:
## Cross validation can be done by training and testing datasets
## Of importance is mean square error (MSE)

# Add bogus column to CPS85 (don't change)
CPS85$bogus <- rnorm(nrow(CPS85)) > 0

# Make the base model
base_model <- lm(wage ~ educ + sector + sex, data = CPS85)

# Make the bogus augmented model
aug_model <- lm(wage ~ educ + sector + sex + bogus, data = CPS85)

# Find the MSE of the base model
mean((CPS85$wage - predict(base_model, newdata = CPS85)) ^ 2)

# Find the MSE of the augmented model
mean((CPS85$wage - predict(aug_model, newdata = CPS85)) ^ 2)

#-------------------------------------------------------------------------------

# Cross validation:
## Cross validation can be done by training and testing datasets
## Of importance is mean square error (MSE)

# Generate a random TRUE or FALSE for each case in Runners_100
demog$training_cases <- rnorm(nrow(demog)) > 0

# Build base model net ~ age + sex with training cases
base_model <- lm(wage ~ age + sex, data = subset(demog, training_cases))

# Evaluate the model for the testing cases
Preds <- evaluate_model(base_model, data = subset(demog, !training_cases))

# Calculate the MSE on the testing data
with(data = Preds, mean((wage - model_output)^2)) #testing

##often, estimates of prediction error based on the training data will be smaller than those based on the testing data

#-------------------------------------------------------------------------------

# To add or not to add (an explanatory variable)?

# The base model
base_model <- lm(wage ~ age + sex, data = demog)

# An augmented model adding previous as an explanatory variable
aug_model <- lm(wage ~ age + sex + exper, data = demog)
aug_model

# Run cross validation trials on the two models
trials <- cv_pred_error(base_model, aug_model)
trials

# Compare the two sets of cross-validated errors
t.test(mse ~ model, data = trials)

# worse predictions = larger prediction error
# base model makes worse better (lower prediction error) than the aug model.

#-------------------------------------------------------------------------------

# prediction errors for categorical response variables
# Build the null model with rpart()
demog$all_the_same <- 1 # null "explanatory" variable
null_model <- rpart(sector ~ all_the_same, data = demog)

# Evaluate the null model on training data
null_model_output <- evaluate_model(null_model, data = demog, type = "class")

# Calculate the error rate
with(data = null_model_output, mean(sector != model_output, na.rm = TRUE))

# Generate a random guess...
null_model_output$random_guess <- mosaic::shuffle(demog$sector)

# ...and find the error rate
with(data = null_model_output, mean(sector != random_guess, na.rm = TRUE))

#-------------------------------------------------------------------------------

# non-null models
# Train the model
model <- rpart(sector ~ age + sex, data = demog, cp = 0.001)

# Get model output with the training data as input
model_output <- evaluate_model(model, data = demog, type = "class")

# Find the error rate
with(data = model_output, mean(sector != model_output, na.rm = TRUE))

#-------------------------------------------------------------------------------

# Another exploration of building better models?
# Train the models
null_model <- rpart(sector ~ age + sex,
                    data = demog, cp = 0.001)
model_1 <- rpart(sector ~ age,
                 data = demog, cp = 0.001)
model_2 <- rpart(sector ~ sex,
                 data = demog, cp = 0.001)

# Find the out-of-sample error rate
null_output <- evaluate_model(null_model, data = demog, type = "class")
model_1_output <- evaluate_model(model_1, data = demog, type = "class")
model_2_output <- evaluate_model(model_2, data = demog, type = "class")

# Calculate the error rates
null_rate <- with(data = null_output,
                  mean(sector != model_output, na.rm = TRUE))
model_1_rate <- with(data = model_1_output,
                     mean(sector != model_output, na.rm = TRUE))
model_2_rate <- with(data = model_2_output,
                     mean(sector != model_output, na.rm = TRUE))

# Display the error rates
null_rate
model_1_rate
model_2_rate

#-------------------------------------------------------------------------------

# exploring Covariates
# Train the model using NHANES data
# library(NHANES) National Health and Nutrition Examination Survey
simple_model <- lm(Age ~ AgeMonths, data = NHANES)

# Evaluate simple_model
evaluate_model(simple_model)

# Calculate the difference in Age months
naive_worth <- 82.8628098 - 41.2085657

# Train another model including Gender
sophisticated_model <-lm(Age ~ AgeMonths + Gender, data = NHANES)

# Evaluate that model
evaluate_model(sophisticated_model)

# Find price difference for fixed Genders
sophisticated_worth <- 82.8622835 - 41.2079910

#-------------------------------------------------------------------------------

# Explore cause and effect
# explore effect size: how would changing an input into a model change the output
## how would a model output change for a given input

# Calculating the GPA
simple_model_1 <- lm(age ~ wage, data = demog)

# The GPA for two students
evaluate_model(simple_model_1, age = c("20", "50"))

# Use effect_size()
# The effect_size() calculation compares two levels of the inputs
effect_size(simple_model_1, ~ wage)

# Specify from and to levels to compare
effect_size(simple_model_1, ~ age, age = "20", to = "50")

# A better model?
simple_model_2 <- lm(age ~ wage + exper + educ, data = demog)

# Find difference between the same two students as before
effect_size(simple_model_2, ~ age, age = "20", to = "50")



