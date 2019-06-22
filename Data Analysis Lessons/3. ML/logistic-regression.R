###DEMO for Logistic Regression###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# load packages
library(broom)
library(sigr)
library(tidyverse)


# load data for logistic regression analysis
library(survival)
library(survminer)
data(lung)
dim(lung)

lung$survival <- rep(c("survived", "perished"), 114)

lung <- na.omit(lung)

# Logistic regression to predict probabilities
summary(lung)

# Create the survived column
lung$survived <- lung$survival == "survived"

# Create the formula
(fmla <- survived ~ pat.karno + ph.karno  + ph.ecog)

# Fit the logistic regression model
lung_model <- glm(fmla, data = lung, family = binomial)

# Call summary
summary(lung_model)

# Call glance
(perf <- glance(lung_model))

# Calculate pseudo-R-squared
(pseudoR2 <- 1 - perf$deviance/perf$null.deviance)

# to evaluate performance of a model for logistic regression, we use pseudoR2, glm, and family = binomial

# ------------------------------------------------------------------------------

# make predictions on the model that was developed previously 

# Make predictions
lung$pred <- predict(lung_model, type = "response")

# Look at gain curve
GainCurvePlot(lung, "pred", "survival", "lung survival model")

# ------------------------------------------------------------------------------

# Poisson and quasipoisson regression to predict counts
# When the variance is much larger than the mean, the Poisson assumption doesn't apply, and one solution is to use quasipoisson regression, which does not assume that variance=mean

data("diabetic")
str(diabetic)

# Create the formula string for status rented as a function of other inputs
(fmla <- (status ~ time + risk + trt + eye + age))

# Calculate the mean and variance of the outcome
(mean_status <- mean(diabetic$status))
(var_status <- var(diabetic$status))

# Fit the model
diabetic_model <- glm(fmla, data = diabetic, family = quasipoisson)

# Call glance
(perf <- glance(diabetic_model))

# Calculate pseudo-R-squared
(pseudoR2 <- 1 - perf$deviance/perf$null.deviance)

# Make predictions on diabetic data
diabetic$pred <- predict(diabetic_model, newdata = diabetic, type = "response")

# Calculate the RMSE
diabetic %>% 
  mutate(residual = pred - time) %>%
  summarize(rmse  = sqrt(mean(residual^2)))

# Plot predictions vs time (pred on x-axis)
ggplot(diabetic, aes(x = pred, y = time)) +
  geom_point() + 
  geom_abline(color = "darkblue")


# visualize predictions
# Plot predictions and cnt by date/time
diabetic %>% 
  # set start time to 0, convert unit to days
  mutate(instant = (time - min(time))/24) %>%  
  # gather cnt and pred into a value column
  gather(key = valuetype, value = value, time, pred) %>%
  #filter(time > 0) %>% # restrict to first 14 days
  # plot value by instant
  ggplot(aes(x = instant, y = value, color = valuetype, linetype = valuetype)) + 
  geom_point() + 
  geom_line() + 
  scale_x_continuous("Day", breaks = 0:14, labels = 0:14) + 
  scale_color_brewer(palette = "Dark2") + 
  ggtitle("Predicted diabetes survival time, Quasipoisson model")

# ------------------------------------------------------------------------------

# generalized additive models (GAM) to learn non-linear transforms (i.e. continuous variables not categorical)
# can use the s() function inside formulas to designate that you want to use a spline to model the non-linear relationship of a continuous variable to the outcome

# Load the package mgcv
library(mgcv)

# Create the formula 
(fmla.gam <- weight ~ s(Time))

# Fit the GAM Model
model.gam <- gam(fmla.gam, data = soybean_train, family = gaussian)

# From previous step
library(mgcv)
fmla.gam <- weight ~ s(Time)
model.gam <- gam(fmla.gam, data = soybean_train, family = gaussian)

# Call summary() on model.lin and look for R-squared
summary(model.lin)

# Call summary() on model.gam and look for R-squared
summary(model.gam)

# Call plot() on model.gam
plot(model.gam)

