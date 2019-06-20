###DEMO for Linear Regression###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# load packages
library(broom)
library(sigr)
library(tidyverse)

# ------------------------------------------------------------------------------

# use the cars data as an example for running linear regression tests
cars

# fit a linear regression model
model <- lm(speed ~ dist, data = cars)
summary(model)

## examining a model
# to see the performance metrics
broom::glance(model)

# to see the R-squared
sigr::wrapFTest(model)

# ------------------------------------------------------------------------------

# making predictions on a fit model
cars$prediction <- predict(model)

# Predict female unemployment rate when male unemployment is 5%
pred <- predict(model, data = cars)
# Print it
pred

# evaluating a model graphically
## load the ggplot2 package
library(ggplot2)

# to explore whether line has perfect prediction or systemic errors (i.e. clusters or negative residuals)
# Make a plot to compare predictions to actual (prediction on x axis)
ggplot(cars, aes(x = prediction, y = speed)) +
  geom_point() +
  geom_abline(color = "blue")


# to calculate residuals: residuals <- actual outcome - predicted outcome
# Calculate residuals
cars$residuals <- cars$speed - cars$prediction

# Fill in the blanks to plot predictions (on x-axis) versus the residuals
## i.e. evaluating model predictions by comparing them to ground truth
## and examining prediction error

ggplot(cars, aes(x = prediction, y = residuals)) +
  geom_pointrange(aes(ymin = 0, ymax = residuals)) +
  geom_hline(yintercept = 0, linetype = 3) +
  ggtitle("residuals vs. linear model prediction")

# The gain curve to evaluate the car model
# Load the package WVPlots
library(WVPlots)

# Plot the Gain Curve
# # A relative gini coefficient close to one shows that the model correctly sorts high speed situations from lower ones

GainCurvePlot(cars, "prediction", "speed", "model")

# ------------------------------------------------------------------------------

# multivariate linear regression
# use the mtcars data as an example for running linear regression tests
mtcars

m_model <- lm(mpg ~ cyl + disp, data = mtcars)
summary(m_model)

# predict mpg using multivariate model :prediction
mtcars$prediction <- predict(m_model)

# plot the results
ggplot(mtcars, aes(x = prediction, y = mpg)) +
  geom_point() +
  geom_abline(color = "blue")

# ------------------------------------------------------------------------------

# Training and Evaluating Regression Models: Calculate RMSE
# unemployment is in the workspace
summary(cars)
summary(model)

# For convenience put the residuals in the variable res
res <- cars$residuals

# Calculate RMSE, assign it to the variable rmse and print it
(rmse <- sqrt(mean(res^2)))

# Calculate the standard deviation of speed of cars and print it
(sd_cars <- sd(cars$speed))


# Calculate mean: speed_mean. Print it
(speed_mean <- mean(cars$speed))

# Calculate total sum of squares: tss. Print it
(tss <- sum( (cars$speed - speed_mean)^2 ))

# Calculate residual sum of squares: rss. Print it
(rss <- sum(cars$residuals^2))

# Calculate R-squared (variance explained): rsq. Print it. Is it a good fit?
(rsq <- 1 - (rss/tss))

# Get R-squared from glance. Print it
(rsq_glance <- glance(model)$r.squared)

# Get the correlation between the prediction and true outcome: rho and print it
(rho <- cor(cars$prediction, cars$speed))

# Square rho: rho2 and print it
(rho2 <- rho ^ 2)

# Get R-squared from glance and print it
(rsq_glance <- glance(model)$r.squared)

# ------------------------------------------------------------------------------

# Properly Training a Model
## Generating a random test/train split
summary(mtcars)
dim(mtcars)
N <- nrow(mtcars)

# Calculate how many rows 75% of N should be and print it
# Hint: use round() to get an integer
(target <- round(N * 0.75))

# Create the vector of N uniform random variables: gp
gp <- runif(N)

# Use gp to create the training set: mtcars_train (75% of data) and mtcars_test (25% of data)
mtcars_train <- mtcars[gp < 0.75, ]
mtcars_test <- mtcars[gp >= 0.75, ]

# Use nrow() to examine mtcars_train and mtcars_test
nrow(mtcars_train)
nrow(mtcars_test)

# Train a model using test/train split
summary(mtcars_train)
summary(mtcars_test)

# create a formula to express drat as a function of wt:
# Now use lm() to build a model mpg_model from mpg_train that predicts drat from wt
mpg_model <- lm(drat ~ wt, data = mtcars_train)

# Use summary() to examine the model
summary(mpg_model)

# Evaluate a model using test/train split
# Examine the objects in the workspace
ls.str()

# predict cty from hwy for the training set
mtcars_train$pred <- predict(mpg_model)

# predict cty from hwy for the test set
mtcars_test$pred <- predict(mpg_model, newdata = mtcars_test)

# Evaluate the rmse on both training and test data and print them
(rmse_train <- rmse(mtcars_train$pred, mtcars_train$drat))
(rmse_test <- rmse(mtcars_test$pred, mtcars_test$drat))


# Evaluate the r-squared on both training and test data.and print them
(rsq_train <- r_squared(mtcars_train$pred, mtcars_train$drat))
(rsq_test <- r_squared(mtcars_test$pred, mtcars_test$drat))

# Plot the predictions (on the x-axis) against the outcome (cty) on the test data
ggplot(mtcars_test, aes(x = pred, y = drat)) +
  geom_point() +
  geom_abline()

# ------------------------------------------------------------------------------

# Create a cross validation plan
# Load the package vtreat for using kWayCrossValidation
library(vtreat)
library(caret)

# mtcars is in the workspace
summary(mtcars)

# Get the number of rows in mpg
nRows <- nrow(mtcars)

# Implement the 3-fold cross-fold plan with vtreat
splitPlan <- kWayCrossValidation(nRows, 3, NULL, NULL)

# Examine the split plan
str(splitPlan)


# Run the 3-fold cross validation plan from splitPlan
k <- 3 # Number of folds
mtcars$pred.cv <- 0
for(i in 1:k) {
  split <- splitPlan[[i]]
  model <- lm(drat ~ wt, data = mtcars[split$train, ])
  mpg$pred.cv[split$app] <- predict(model, newdata = mtcars[split$app, ])
}

# Predict from a full model
mtcars$pred <- predict(lm(drat ~ wt, data = mtcars))

# Get the rmse of the full model's predictions
rmse = function(m, o){
  sqrt(mean((m - o)^2))
}
rmse(mtcars$wt, mtcars$drat)

# Get the rmse of the cross-validation predictions
rmse(mtcars$pred.cv, mtcars$drat)

# ------------------------------------------------------------------------------

# Categorical inputs: Examining the structure of categorical inputs
## Load vcd package
library(vcd)

## Load Arthritis dataset (data frame)
data(Arthritis)

str(Arthritis)

# Use unique() to see how many possible values Time takes
unique(Arthritis$Treatment)

# Build a formula to express Flowers as a function of Intensity and Time: fmla. Print it
(fmla <- as.formula("Treatment ~ Age + Sex"))

# Fit a model to predict Flowers from Intensity and Time : flower_model
arthritis_model <-  lm(fmla, data = Arthritis)

# Use fmla and model.matrix to see how the data is represented for modeling
mmat <- model.matrix(fmla, Arthritis)

# Examine the first 20 lines of mtcars
head(Arthritis, n = 20)

# Examine the first 20 lines of mmat
head(mmat, n = 20)
summary(mmat)

# predict the number of flowers on each plant

Arthritis$prediction <- predict(arthritis_model)

# Plot predictions vs actual flowers (predictions on x-axis)
ggplot(Arthritis, aes(x = prediction, y = Age)) +
  geom_point() +
  geom_abline(color = "blue")


# ------------------------------------------------------------------------------

# Interactions between various variables and modeling them
## Load vcd package
library(vcd)

## Load Arthritis dataset (data frame)
data(Arthritis)
summary(Arthritis)

# Create the formula with main effects only
(fmla_add <- Age ~ Treatment + Sex)

# Create the formula with interactions
(fmla_interaction <- Age ~ Treatment + Sex:Improved)

# Fit the main effects only model
model_add <- lm(fmla_add, data = Arthritis)

# Fit the interaction model
model_interaction <- lm(fmla_interaction, data = Arthritis)

# Call summary on both models and compare
summary(model_add)
summary(model_interaction)


# Modeling an interaction 
# Both the formulae are in the workspace
fmla_add
fmla_interaction

# Create the splitting plan for 3-fold cross validation
set.seed(34245)  # set the seed for reproducibility
splitPlan <- kWayCrossValidation(nrow(Arthritis), 3, NULL, NULL)

# Sample code: Get cross-val predictions for main-effects only model
Arthritis$pred_add <- 0  # initialize the prediction vector
for(i in 1:3) {
  split <- splitPlan[[i]]
  model_add <- lm(fmla_add, data = Arthritis[split$train, ])
  Arthritis$pred_add[split$app] <- predict(model_add, newdata = Arthritis[split$app, ])
}

# Get the cross-val predictions for the model with interactions
Arthritis$pred_interaction <- 0 # initialize the prediction vector
for(i in 1:3) {
  split <- splitPlan[[i]]
  model_interaction <- lm(fmla_interaction, data = Arthritis[split$train, ])
  Arthritis$pred_interaction[split$app] <- predict(model_interaction, newdata = Arthritis[split$app, ])
}

# Get RMSE
Arthritis %>% 
  gather(key = modeltype, value = pred, pred_add, pred_interaction) %>%
  mutate(residuals = Age - pred) %>%
  group_by(modeltype) %>%
  summarize(rmse = sqrt(mean(residuals^2)))

# Cross-validation confirms that a model without interaction will likely give better predictions.
# lower RMSE the better prediction
# ------------------------------------------------------------------------------

# Relative error
# Arthritis is in the workspace
summary(Arthritis)

# Examine the data: generate the summaries for the groups large and small:
Arthritis %>% 
  group_by(Treatment) %>%        # group by small/large purchases
  summarize(min  = min(Age),   # min of Age
            mean = mean(Age),  # mean of Age
            max  = max(Age))   # max of Age

# Fill in the blanks to add error columns
Arthritis2 <- Arthritis %>% 
  group_by(Treatment) %>%               # group by label
  mutate(residual = pred_add - Age,     # Residual
         relerr   = residual/Age)   # Relative error

# Compare the rmse and rmse.rel of the large and small groups:
Arthritis2 %>% 
  group_by(Treatment) %>% 
  summarize(rmse     = sqrt(mean(residual^2)),  # RMSE
            rmse.rel = sqrt(mean(relerr^2)))    # Root mean squared relative error

# Plot the predictions for both groups of purchases
ggplot(Arthritis2, aes(x = pred_add, y = Age, color = Treatment)) + 
  geom_point() + 
  geom_abline() + 
  facet_wrap(~ Treatment, ncol = 1, scales = "free") + 
  ggtitle("Outcome vs prediction")


## other options: 
## modeling log-transformed outputs or inputs
## e.g. (fmla_sqr <- x ~ I(y^2)) - make a square model
## e.g. (fmla.log <- log(x) ~ y + z + w) - make a linear model







