###DEMO for supervised learning in R: Logistic Regression###
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
library(ClusterR)


# Load data
# install.packages('mlbench')
data(BreastCancer, package="mlbench")
bc <- BreastCancer[complete.cases(BreastCancer), ]  # keep complete rows

bc$Cell.shape <- as.numeric(bc$Cell.shape)
bc$Cell.size <-as.numeric(bc$Cell.size)

# Create the formula 
# note spline (s) is used for continuous variables
# or you can designate which variable you want to model non-linearly in a formula with the s() function

fmla.gam <- (Cell.size ~ s(Cell.shape))

# Fit the GAM Model
model.gam <- gam(fmla.gam, data = bc, family = gaussian)s

model.lin <- glm(Cell.size ~ Cell.shape, data = bc)

# Call summary() on model.gam and look for R-squared
summary(model.gam)

# Call summary() on model.lin and look for R-squared
summary(model.lin)

# Call plot() on model.gam
plot(model.gam)

# Get predictions from gam model
bc$pred.gam <- as.numeric(predict(model.gam, newdata = bc))

bc$pred.lin <- as.numeric(predict(model.lin, newdata = bc))

# Gather the predictions into a "long" dataset
bc_long <- bc %>%
  gather(key = modeltype, value = pred, pred.lin, pred.gam)

# Calculate the rmse
bc_long %>%
  mutate(residual = Cell.size - pred) %>%     # residuals
  group_by(modeltype) %>%                  # group by modeltype
  summarize(rmse = sqrt(mean(residual^2))) # calculate the RMSE

# Compare the predictions against actual weights on the test data
bc_long %>%
  ggplot(aes(x = Cell.size)) +                          # the column for the x axis
  geom_point(aes(y = Cell.shape)) +                    # the y-column for the scatterplot
  geom_point(aes(y = pred, color = modeltype)) +   # the y-column for the point-and-line plot
  geom_line(aes(y = pred, color = modeltype, linetype = modeltype)) + # the y-column for the point-and-line plot
  scale_color_brewer(palette = "Dark2")

#------------------------------------------------------------------------------

# Tree-based methods: random forest and gradient boosted trees

# get the data
tmp <- tempfile()
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00275/Bike-Sharing-Dataset.zip", 
              tmp)

bikes <- unz(tmp, "hour.csv")
bikedat <- read.table(bikes, header = T, sep = ",")

# bikedat is in the workspace
str(bikedat)

# Random seed to reproduce results
seed <- set.seed(423563)

# the outcome column
(outcome <- "cnt")

# The input variables
(vars <- c("hr", "holiday", "workingday", "weathersit", "temp", "atemp", "hum", "windspeed"))

# Create the formula string for bikes rented as a function of the inputs
(fmla <- paste(outcome, "~", paste(vars, collapse = " + ")))

# Load the package ranger
library(ranger)

# Fit and print the random forest model.
(bike_model_rf <- ranger(fmla, 
                         bikedat, 
                         num.trees = 500, 
                         respect.unordered.factors = "order", 
                         seed = seed))


# Make predictions on the August data
bikesAugust$pred <- predict(bike_model_rf, bikesAugust)$predictions

# Calculate the RMSE of the predictions
bikesAugust %>% 
  mutate(residual = cnt - pred)  %>%        # calculate the residual
  summarize(rmse  = sqrt(mean(residual^2))) # calculate rmse

# Plot actual outcome vs predictions (predictions on x-axis)
ggplot(bikesAugust, aes(x = pred, y = cnt)) + 
  geom_point() + 
  geom_abline()

#------------------------------------------------------------------------------
