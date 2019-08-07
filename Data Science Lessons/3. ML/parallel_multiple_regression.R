###DEMO for Parallel and Multiple Regression in R###
# Lessons are adapted and organized by Noushin Nabavi, PhD. (adapted from DataCamp Lessons for regression)

# parallel slopes models = numeric and categorical variables for modeling

# load packages
library(broom)
library(tidyverse)
library(plotly)


# load the data 
education_data <- read.csv(url("https://assets.datacamp.com/production/repositories/845/datasets/1a12a19d2cec83ca0b58645689987e2025d91383/SAT.csv"))

# fit parallel slopes
mod <- lm(expenditure ~ salary + state, data = education_data)

# Augment the model (returns a data frame)
## augment is unlike predict which only returns a vector
augmented_mod <- augment(mod)
glimpse(augmented_mod)

# scatterplot, with color
edu_plot <- ggplot(augmented_mod, aes(x = expenditure, y = salary, color = state)) + 
  geom_point()

# single call to geom_line()
edu_plot + 
  geom_line(aes(y = .fitted))

# ------------------------------------------------------------------------------

# Describing and evaluating models
# Model fit, residuals, and prediction
## R-squared vs. adjusted R-squared

# R^2 and adjusted R^2
summary(mod)

# add random noise
education_data_noisy <- education_data %>%
  mutate(noise = rnorm(nrow(education_data)))

# compute new model
mod2 <- lm(expenditure ~ salary + state + noise, data = education_data_noisy)

# new R^2 and adjusted R^2
summary(mod2)

# return a vector
predict(mod)

# return a data frame
augment(mod)


## Understanding interaction and interaction model
# include interaction
int_mod <- lm(expenditure ~ salary + state + state:expenditure, data = education_data)

# interaction plot
ggplot(education_data, aes(y = expenditure, x = salary, color = state)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)


# Simpson's Paradox
slr <- ggplot(education_data, aes(y = expenditure, x = salary)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = 0)

# model with one slope
lm(expenditure ~ salary, data = education_data)

# plot with two slopes
slr + aes(color = state)

# ------------------------------------------------------------------------------

# Multiple Regression (with at least two numeric explanatory variable)

# Fitting a multiple regression model (MLR)
mod_MLR <- lm(expenditure ~ salary + pupil_teacher_ratio, data = education_data)

# add predictions to grid
mod_aug <- augment(mod_MLR, newdata = education_data)

# tile the slr plot or any other built above
slr + 
  geom_tile(data = mod_aug, aes(fill = .fitted), alpha = 0.5) # pass the augment() data to geom_tile for visualization

# Models in 3D
# draw the 3D scatterplot
library(plotly)
p <- plot_ly(data = education_data, z = ~expenditure, x = ~salary, y = ~pupil_teacher_ratio, opacity = 0.6) %>%
  add_markers() 

# draw the plane
# draw the plane
p %>%
  add_surface(x = ~x, y = ~y, z = ~plane, showscale = FALSE)


# Conditional interpretation of coefficients

# Visualizing parallel planes
# draw the 3D scatterplot
p <- plot_ly(data = education_data, z = ~expenditure, x = ~salary, y = ~pupil_teacher_ratio, opacity = 0.6) %>%
  add_markers(color = ~state) 

# draw two planes
p %>%
  add_surface(x = ~x, y = ~y, z = ~plane0, showscale = FALSE) %>%
  add_surface(x = ~x, y = ~y, z = ~plane1, showscale = FALSE)

# ------------------------------------------------------------------------------

# logistic regression

# load data for logistic regression
german_credit <- read.csv(url("https://assets.datacamp.com/production/repositories/710/datasets/b649085c43111c83ba7ab6ec172d83cdc14a2942/credit.csv"))

creditsub <- german_credit %>%
  na.omit()

str(creditsub)

# Convert "yes" to 1, "no" to 0
creditsub$default <- ifelse(creditsub$default == "yes", 1, 0)

# Fitting a line to a binary response  
# scatterplot with jitter
creditsub_graph <- ggplot(data = creditsub, aes(y = default, x = years_at_residence)) + 
  geom_jitter(width = 0, height = 0.05, alpha = 0.5)

# linear regression line
creditsub_graph + 
  geom_smooth(method = "lm", se = FALSE)

# filter
creditsub2 <- creditsub %>%
  filter(years_at_residence >= 2, years_at_residence <= 4)

# scatterplot with jitter
creditsub_graph <- ggplot(data = creditsub2, aes(y = default, x = years_at_residence)) + 
  geom_jitter(width = 0, height = 0.05, alpha = 0.5)

# linear regression line
creditsub_graph + 
  geom_smooth(method = "lm", se = FALSE)


# fit model
mod <- glm(default ~ years_at_residence, data = creditsub, family = binomial)

# Visualizing logistic regression
# scatterplot with jitter and add logistic curve
creditsub_graph +
  geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"))

# binned points and line
creditsub_graph + 
  geom_point() + geom_line()

# augmented model
mod_creditsub <- mod %>%
  augment(type.predict = "response")

# logistic model on probability scale
creditsub_graph +
  geom_line(data = mod_creditsub, aes(x = years_at_residence, y = .fitted), color = "red")


# compute odds for bins
creditsub_binned <- creditsub %>%
  mutate(odds = percent_of_income / (1 - percent_of_income))

# plot binned odds
creditsub_binned_plot <- ggplot(data = creditsub_binned, aes(x = years_at_residence, y = odds)) + 
  geom_point() + geom_line()

# compute odds for observations
mod_creditsub_plus <- mod_creditsub %>%
  mutate(odds_hat = .fitted / (1 - .fitted))

# logistic model on odds scale
creditsub_binned_plot +
  geom_line(data = mod_creditsub_plus, aes(x = years_at_residence, y = odds_hat), color = "red")



# Log-odds scale
# compute log odds for bins
creditsub_binned <- creditsub %>%
  mutate(log_odds = log(percent_of_income / (1 - percent_of_income)))

# plot binned log odds
creditsub_binned_plot <- ggplot(data = creditsub_binned, aes(x = years_at_residence, y = log_odds)) + 
  geom_point() + geom_line()


# compute log odds for observations
mod_creditsub_plus <- mod_creditsub %>%
  mutate(log_odds_hat = log(.fitted / (1 - .fitted)))

# logistic model on log odds scale
creditsub_binned_plot +
  geom_line(data = mod_creditsub_plus, aes(x = years_at_residence, y = log_odds_hat), color = "red")

# Making binary predictions using confusion matrix
mod <- glm(default ~ years_at_residence, data = creditsub, family = binomial)

# data frame with binary predictions
tidy_mod <- augment(mod, type.predict = "response") %>% 
  mutate(years_at_residence_hat = round(.fitted)) 

# confusion matrix
tidy_mod %>% 
  select(years_at_residence, years_at_residence_hat) %>%
  table()

# ------------------------------------------------------------------------------


# Case study

# load data
nyc <- read.csv(url("https://assets.datacamp.com/production/repositories/845/datasets/639a7a3f9020edb51bcbc4bfdb7b71cbd8b9a70e/nyc.csv"))

# take a look at data
glimpse(nyc)

# Price by Food plot
ggplot(data = nyc, aes(x = Food, y = Price)) +
  geom_point()

# Price by Food model
lm(Price ~ Food, data = nyc)

# fit model
lm(Price ~ Food + Service, data = nyc)

# draw 3D scatterplot
p <- plot_ly(data = nyc, z = ~Price, x = ~Food, y = ~Service, opacity = 0.6) %>%
  add_markers() 

# draw a plane
p %>%
  add_surface(x = ~x, y = ~y, z = ~plane, showscale = FALSE) 

# Price by Food and Service and East
lm(Price ~ Food + Service + East, data = nyc)

# draw 3D scatterplot
p <- plot_ly(data = nyc, z = ~Price, x = ~Food, y = ~Service, opacity = 0.6) %>%
  add_markers(color = ~factor(East)) 

# draw two planes
p %>%
  add_surface(x = ~x, y = ~y, z = ~plane0, showscale = FALSE) %>%
  add_surface(x = ~x, y = ~y, z = ~plane1, showscale = FALSE)
