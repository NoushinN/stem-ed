###DEMO for mathematical models II in R###
# lessons curated by Noushin Nabavi, PhD
# thanks to https://www.rdocumentation.org/packages/statisticalModeling/versions/0.3.0
# general fmodel backbone
fmodel(model_object, ~ x_var + color_var + facet_var)


# Load dependent packages
library(tidyverse)
library(ggplot2)
library(mosaicData)
library(statisticalModeling)
library(rpart)


#-------------------------------------------------------------------------------

# load data, diseases released from WHO
url = "https://assets.datacamp.com/production/repositories/1864/datasets/71386124a72f58a50fbc07b8254f47ef9a867ebe/who_disease.csv"
diseases <- read.csv(url)

# Build your model
my_model <- rpart(region ~ year + cases,
                  data = diseases)

# Graph the model
fmodel(my_model, ~ region + year + cases)

#-------------------------------------------------------------------------------


# Build the model from data in library(NHANES)
mod <- lm(Pulse ~ Height + BMI + Gender, data = NHANES)

# Confirm by reconstructing the graphic provided
fmodel(mod, ~ Height + BMI + Gender) + ggplot2::ylab("Pulse")

# Find effect size (rate when quantitative and difference when categorical)
effect_size(mod, ~ BMI) # how the output changes when input changes

# Replot x model
fmodel(mod, ~ BMI + Height + Gender) + ggplot2::ylab("Pulse")

#-------------------------------------------------------------------------------

# Train this model of start_position
## to answer Who are the mellow runners?
model_1 <- rpart(start_position ~ age + sex + nruns,
                 data = Runners, cp = 0.001)

# Calculate effect size with respect to sex
effect_size(model_1, ~ sex)

# Calculate effect size with respect to age
effect_size(model_1, ~ age)

# Calculate effect size with respect to nruns
effect_size(model_1, ~ nruns)


#-------------------------------------------------------------------------------

# An rpart model
mod1 <- rpart(outcome ~ age + smoker, data = Whickham)

# Logistic regression
mod2 <- glm(outcome == "Alive" ~ age + smoker,
            data = Whickham, family = "binomial")

# Visualize the models with fmodel()
fmodel(mod1)
fmodel(mod2)

# Find the effect size of smoker
effect_size(mod1, ~ smoker)
effect_size(mod2, ~ smoker) # Recursive partitioning works best for sharp, discontinuous changes. Logistic regression can capture smooth changes, and works better here.

#-------------------------------------------------------------------------------

# Build the model without interaction
model_1 <- lm(baby_wt ~ gestation + smoke, data = Birth_weight)

# Build the model with interaction
model_2 <- lm(baby_wt ~ gestation * smoke, data = Birth_weight)

# Plot each model
fmodel(model_1) + ggplot2::ylab("baby_wt")
fmodel(model_2) + ggplot2::ylab("baby_wt")

#-------------------------------------------------------------------------------

# Train model_1
model_1 <- lm(Price ~ Age + Mileage, data = Used_Fords)

# Train model_2
model_2 <- lm(Price ~ Age * Mileage, data = Used_Fords)

# Plot both models
fmodel(model_1)
fmodel(model_2)

# Cross validate and compare prediction errors
res <- cv_pred_error(model_1, model_2)
res
t.test(mse ~ model, data = res)

#-------------------------------------------------------------------------------

# partial vs total change
# Train a model of house prices
price_model_1 <- lm(price ~ land_value + living_area + fireplaces + bathrooms + bedrooms,
                    data = Houses_for_sale)

# Effect size of living area
effect_size(price_model_1, ~ living_area)

# Effect size of bathrooms
effect_size(price_model_1, ~ bathrooms, step = 1)

# Effect size of bedrooms
effect_size(price_model_1, ~ bedrooms, step = 1)

# Let living_area change as it will
price_model_2 <- lm(price ~ land_value + fireplaces + bathrooms + bedrooms,
                    data = Houses_for_sale)

# Effect size of bedroom in price_model_2
effect_size(price_model_2, ~ bedrooms, step = 1)

#-------------------------------------------------------------------------------

# Calculating total change
# Train a model of house prices
price_model <- lm(price ~ land_value + living_area + fireplaces +
                    bathrooms + bedrooms, data = Houses_for_sale)

# Evaluate the model in scenario 1
evaluate_model(price_model, living_area = 2000, bedrooms = 2, bathrooms = 1)

# Evaluate the model in scenario 2
evaluate_model(price_model, living_area = 2140, bedrooms = 3, bathrooms = 1)

# Find the difference in output
price_diff <- 184050.4 - 181624.0

# Evaluate the second scenario again, but add a half bath
evaluate_model(price_model, living_area = 2165, bedrooms = 3, bathrooms = 1.5)

# Calculate the price difference
new_price_diff <- 199030.3 - 181624.0

#-------------------------------------------------------------------------------

## car prices
# Fit model (total effect)
car_price_model <- lm(Price ~ Age + Mileage, data = Used_Fords)

# Partial effect size
effect_size(car_price_model, ~ Age)

# To find total effect size
evaluate_model(car_price_model, Age = 6, Mileage = 42000)
evaluate_model(car_price_model, Age = 7, Mileage = 50000)

# Price difference between scenarios (round to nearest dollar)
price_difference <- 8400 - 9524

# Effect for age without mileage in the model (partial effect)
car_price_model_2 <- lm(Price ~ Age, data = Used_Fords)

# Calculate partial effect size
effect_size(car_price_model_2, ~ Age)
#-------------------------------------------------------------------------------

## R-squared = coefficient of determination and modeling multiple explanatory variables

# Train some models
model_1 <- lm(gradepoint ~ sid, data = College_grades)
model_2 <- lm(Cost ~ Age + Sex + Coverage, data = AARP)
model_3 <- lm(vmax ~ group + (rtemp + I(rtemp^2)), data = Tadpoles)

# Calculate model output on training data
output_1 <- evaluate_model(model_1, data = College_grades)
output_2 <- evaluate_model(model_2, data = AARP)
output_3 <- evaluate_model(model_3, data = Tadpoles)

# R-squared for the models
with(output_1, var(model_output) / var(gradepoint))
with(output_2, var(model_output) / var(Cost))
with(output_3, var(model_output) / var(vmax))


#-------------------------------------------------------------------------------

# The two models to assess if it's warming in Minneapolis
model_1 <- lm(hdd ~ year, data = HDD_Minneapolis)
model_2 <- lm(hdd ~ month, data = HDD_Minneapolis)

# Find the model output on the training data for each model
output_1 <- evaluate_model(model_1, data = HDD_Minneapolis)
output_2 <- evaluate_model(model_2, data = HDD_Minneapolis)

# Find R-squared for each of the 2 models
with(output_1, var(model_output) / var(hdd))
with(output_2, var(model_output) / var(hdd))

# R-squared for model_2 is much higher than for model_1, i.e. more variability

#-----

# Train this model with 24 degrees of freedom
model_1 <- lm(hdd ~ year * month, data = HDD_Minneapolis)

# Calculate R-squared
output_1 <- evaluate_model(model_1, data = HDD_Minneapolis)
with(output_1, var(model_output) / var(hdd))

# Oops! Numerical year changed to categorical
HDD_Minneapolis$categorical_year <- as.character(HDD_Minneapolis$year)

# This model has many more degrees of freedom
model_2 <- lm(hdd ~ categorical_year * month, data = HDD_Minneapolis)

# Calculate R-squared
output_2 <- evaluate_model(model_2, data = HDD_Minneapolis)
with(output_2, var(model_output) / var(hdd))
## 1 as output means it's a perfect model!!

#-------------------------------------------------------------------------------

# Train model_1 without bogus
model_1 <- lm(wage ~ sector, data = Training)

# Train model_2 with bogus
model_2 <- lm(wage ~ sector + bogus, data = Training)

# Calculate R-squared using the training data
output_1 <- evaluate_model(model_1, data = Training)
output_2 <- evaluate_model(model_2, data = Training)
with(output_1, var(model_output) / var(wage))
with(output_2, var(model_output) / var(wage))

# Compare cross-validated MSE
boxplot(mse ~ model, data = cv_pred_error(model_1, model_2))

#-------------------------------------------------------------------------------

## Degrees of Freedom

# Train the four models
model_0 <- lm(wage ~ NULL, data = CPS85)
model_1 <- lm(wage ~ mosaic::rand(100), data = CPS85)
model_2 <- lm(wage ~ mosaic::rand(200), data = CPS85)
model_3 <- lm(wage ~ mosaic::rand(300), data = CPS85)

anova(model_0)
anova(model_1)
anova(model_2)
anova(model_3)

# Evaluate the models on the training data
output_0 <- evaluate_model(model_0, on_training = TRUE)
output_1 <- evaluate_model(model_1, on_training = TRUE)
output_2 <- evaluate_model(model_2, on_training = TRUE)
output_3 <- evaluate_model(model_3, on_training = TRUE)

# Compute R-squared for each model
with(output_0, var(model_output) / var(wage))
with(output_1, var(model_output) / var(wage))
with(output_2, var(model_output) / var(wage))
with(output_3, var(model_output) / var(wage))

# Compare the null model to model_3 using cross validation
cv_results <- cv_pred_error(model_0, model_3, ntrials = 3)
boxplot(mse ~ model, data = cv_results)

# The influence is bigger as the number of degrees of freedom gets bigger
# ntrials = 3 is setting the degrees of freedom to 3

#-------------------------------------------------------------------------------
# Precision in modeling
## confidence intervals
## bootstrap trial
# Two starting elements
model <- lm(wage ~ age + sector, data = CPS85)
effect_size(model, ~ age)

# For practice
my_test_resample <- sample(1:10, replace = TRUE)
my_test_resample

# Construct a resampling of CPS85
trial_1_indices <- sample(1:nrow(CPS85), replace = TRUE)
trial_1_data <- CPS85[trial_1_indices, ]

# Train the model to that resampling
trial_1_model <- lm(wage ~ age + sector, data = trial_1_data)

# Calculate the quantity
effect_size(trial_1_model, ~ age, data = trial_1_data)

#-------------------------------------------------------------------------------

# Model and effect size from the "real" data
model <- lm(wage ~ age + sector, data = CPS85)
effect_size(model, ~ age)

# Generate 10 resampling trials
my_trials <- ensemble(model, nreps = 10)

# Find the effect size for each trial
effect_size(my_trials, ~ age)

# Re-do with 100 trials
my_trials <- ensemble(model, nreps = 100)
trial_effect_sizes <- effect_size(my_trials, ~ age)

# Calculate the standard deviation of the 100 effect sizes
sd(trial_effect_sizes$slope)

#-------------------------------------------------------------------------------
# An estimate of the value of a fireplace
model <- lm(price ~ land_value + fireplaces + living_area,
            data = Houses_for_sale)
effect_size(model, ~ fireplaces)

# Generate 100 resampling trials
trials <- ensemble(model, nreps = 100)

# Calculate the effect size in each of the trials
effect_sizes_in_trials <- effect_size(trials, ~ fireplaces)

# Show a histogram of the effect sizes
hist(effect_sizes_in_trials$slope)

# Calculate the standard error
sd(effect_sizes_in_trials$slope)

#-------------------------------------------------------------------------------

## Scales and transformations

# Make model with log(Cost)
mod_1 <- lm(log(Cost) ~ Age + Sex + Coverage, data = AARP)
mod_2 <- lm(log(Cost) ~ Age * Sex + Coverage, data = AARP)
mod_3 <- lm(log(Cost) ~ Age * Sex + log(Coverage), data = AARP)
mod_4 <- lm(log(Cost) ~ Age * Sex * log(Coverage), data = AARP)

# To display each model in turn
fmodel(mod_1, ~ Age + Sex + Coverage,
       Coverage = c(10, 20, 50)) +
  ggplot2::geom_point(data = AARP, alpha = 0.5,
                      aes(y = log(Cost), color = Sex))

# Use cross validation to compare mod_4 and mod_1
results <- cv_pred_error(mod_1, mod_4)
boxplot(mse ~ model, data = results)


100 * (exp(round(0.0409614, 3)) - 1)

#-------------------------------------------------------------------------------

# A model of price
model_1 <- lm(Price ~ Mileage + Age, data = Used_Fords)

# A model of logarithmically transformed price
Used_Fords$log_price <- log(Used_Fords$Price)
model_2 <- lm(log_price ~ Mileage + Age, data = Used_Fords)

# The model values on the original cases
preds_1 <- evaluate_model(model_1, data = Used_Fords)

# The model output for model_2 - giving log price
preds_2 <- evaluate_model(model_2, data = Used_Fords)

# Transform predicted log price to price
preds_2$model_price <- exp(preds_2$model_output)

# Mean square errors in price
mean((preds_1$Price - preds_1$model_output)^2, na.rm = TRUE)
mean((preds_2$Price - preds_2$model_price)^2, na.rm = TRUE)

## log-transformed price produces considerably better price predictions than the model directly of price
#-------------------------------------------------------------------------------

# A model of logarithmically transformed price
model <- lm(log(Price) ~ Mileage + Age, data = Used_Fords)

# Create the bootstrap replications
bootstrap_reps <- ensemble(model, nreps = 100, data = Used_Fords)

# Find the effect size
age_effect <- effect_size(bootstrap_reps, ~ Age)

# Change the slope to a percent change
age_effect$percent_change <- 100 * (exp(age_effect$slope) - 1)

# Find confidence interval
with(age_effect, mean(percent_change) + c(-2, 2) * sd(percent_change))
## The 95% confidence interval corresponds to a decrease in price each year between about 9 and 7 percent

#-------------------------------------------------------------------------------

# Confidence and collinearity (+ inflation)

# A model of wage
model_1 <- lm(wage ~ educ + sector + exper + age, data = CPS85)

# Effect size of educ on wage
effect_size(model_1, ~ educ)

# Examine confidence interval on effect size
ensemble_1 <- ensemble(model_1, nreps = 100)
effect_from_1 <- suppressWarnings(effect_size(ensemble_1, ~ educ))
with(effect_from_1, mean(slope) + c(-2, 2) * sd(slope))

## The collinearity() function (from the statisticalModeling package) calculates how much the effect size might (at a maximum) be influenced by collinearity with the other explanatory variables.
# Collinearity inflation factor on standard error
collinearity( ~ educ + sector + exper + age, data = CPS85)

# Leave out covariates one at a time
collinearity( ~ educ + sector + exper, data = CPS85) # leave out age
collinearity( ~ educ + sector + age, data = CPS85) # leave out exper
collinearity( ~ educ + exper + age, data = CPS85) # leave out sector
## Leaving out either age or exper brings a huge reduction in the variance inflation factor.
## The reason:  5 + educ + exper == age — only two of the three variables are independent.

#-------------------------------------------------------------------------------

# Improved model leaving out worst offending covariate
model_2 <- lm(wage ~ educ + sector + age, data = CPS85)

# Confidence interval of effect size of educ on wage
ensemble_2 <- ensemble(model_2, nreps = 100)
effect_from_2 <- effect_size(ensemble_2, ~ educ)
with(effect_from_2, mean(slope) + c(-2, 2) * sd(slope))
## leaving out a covariate can improve the confidence interval

#-------------------------------------------------------------------------------

# Train a model Price ~ Age + Mileage
model_1 <- lm(Price ~ Age + Mileage, data = Used_Fords)

# Train a similar model including the interaction
model_2 <- lm(Price ~ Age * Mileage, data = Used_Fords)

# Compare cross-validated prediction error
cv_pred_error(model_1, model_2)

# Use bootstrapping to find conf. interval on effect size of Age
## calculate a 95% confidence interval on the effect of Age on Price.

ensemble_1 <- ensemble(model_1, nreps = 100)
ensemble_2 <- ensemble(model_2, nreps = 100)
effect_from_1 <- effect_size(ensemble_1, ~ Age)
effect_from_2 <- effect_size(ensemble_2, ~ Age)
with(effect_from_1, mean(slope) + c(-2, 2) * sd(slope))
with(effect_from_2, mean(slope) + c(-2, 2) * sd(slope))

# Compare inflation for the model with and without interaction
collinearity(~ Age + Mileage, data = Used_Fords)
collinearity(~ Age * Mileage, data = Used_Fords)



#-------------------------------------------------------------------------------
