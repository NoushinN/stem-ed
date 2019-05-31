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


#-------------------------------------------------------------------------------




#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------