# If you don't MASS, you can install it, by running
# install.packages("MASS")
# witout the # in front of it.

library(MASS)
data(mcycle)
# Data from a Simulated Motorcycle Accident

# Description:
#   A data frame giving a series of measurements of head acceleration
#   in a simulated motorcycle accident, used to test crash helmets.
# 
# Format:
#   'times' in milliseconds after impact.
#   'accel' in g.
# 
# Source:
#   Silverman, B. W. (1985) Some aspects of the spline smoothing
# approach to non-parametric curve fitting.  _Journal of the Royal
# Statistical Society series B_ *47*, 1-52.

# Always inspect your data first
head(mcycle)

# Plotting in base
plot(mcycle$times, mcycle$accel)

# Plotting in ggplot
library(ggplot2)
ggplot(mcycle, aes(x = times, y = accel)) + # Create an aesthetic mapping 
  geom_point()

# Make a naive linear model
naive.linear.model <- glm(accel ~ times, data = mcycle)

# Predict over the range
predictions <- data.frame(times = 0:60)
predictions$linear <- predict(naive.linear.model, newdata = predictions)

# Plot the predictions over the real data.
plot(mcycle$times, mcycle$accel)
lines(predictions$times, predictions$linear)

# Plot the predictions over the real data in ggplot.
ggplot(mcycle, aes(x = times, y = accel)) + # Create an aesthetic mapping 
  geom_point() + 
  geom_line(data = predictions, 
            aes(x = times, y = linear)) 

# Let's try some polynomials
quadratic.mcycle <- 
  glm(formula = accel ~ times + I(times^2), # 2 params
                data = mcycle) 
cubic.mcycle <- glm(formula = accel ~ times + I(times^2) + I(times^3), # 3 params
                data = mcycle) 

predictions$quadratic <- predict(quadratic.mcycle, predictions)
predictions$cubic <- predict(cubic.mcycle, predictions)

# Can plot one at a time.
ggplot(mcycle, aes(x = times, y = accel)) +
  geom_point() + 
  geom_line(data = predictions, 
            aes(x = times, y = quadratic)) 

ggplot(mcycle, aes(x = times, y = accel)) +
  geom_point() + 
  geom_line(data = predictions, 
            aes(x = times, y = cubic)) 


# But it is nice to see things together. ggplot likes to put things in "long"
# form, much like a pivot table. This is wide:
head(predictions)

# Bring in the reshape library to convert to long form.
library(reshape2)
# The names are a bit strange, but there is an overall smelting theme to reshape.
# "Melting" is "softening" it in a form that ggplot prefers.
# "Casting" is "hardening" the data in a form that humans prefer.

# I can never remeber the argument names for melt, you can look them up:
?melt

# But it says that there are mutliple functions defined for this... 
# What class is my object?
class(predictions)
# A data.frame, great. Let's look that up
?melt.data.frame

# Okay it is id.vars
melted.predictions <- melt(predictions, id.vars = "times") 

# Did it work?
head(melted.predictions)
# We can only see the first few rows... make sure that cubic and quadratic are in there too:

# Filter the melted.predictions data.frame to make sure they are in there too.
# dplyr is the most modern way of doing filtering and selection
library(dplyr)
# %>% is really hard to type. Always use Ctrl+Shift+M
melted.predictions %>% filter(variable == "cubic") %>% head
melted.predictions %>% filter(variable == "quadratic") %>% head

# The pipe can make things a lot more clear.
melted.predictions %>% filter(variable == "cubic") %>% head
# is the same as
head(filter(melted.predictions, variable == "cubic"))
# Without all the nesting that humans find difficult.

# Ready to make our nice plot now:
ggplot(mcycle, aes(x = times, y = accel)) +
  geom_point() + 
  geom_line(data = melted.predictions,
            aes(x = times, y = value, colour = variable), # This took me a while to get.
            size = 1.5) 
# What is great is what is automated here. colours and labels.


# Cross-validation

# Split the data randomly into 10 separate folds.
# Need to create a variable that indicates the fold number for each row
num.folds <- 10 # always make configurable numbers variables.
fold.not.random <- rep_len(1:num.folds, length.out = nrow(mcycle))

# Check what is in fold.not.random
fold.not.random

# Randomly scramble it. (run a few times to see what it is doing)
sample(fold.not.random, size = length(fold.not.random))

# Setting the seed makes it so that the folds are generated the same way every
# time, across machines.
set.seed(1)
sample(fold.not.random, size = length(fold.not.random)) # Run a few times.

# Now actually store that variable.
set.seed(1)
fold <- sample(fold.not.random, size = length(fold.not.random))

# Split the data
mcycle.split <- split(mcycle, fold)

# Looks easy! Take a look.
mcycle.split

# But the data structure has changed.
class(mcycle) # data.frame
class(mcycle.split) # list

# Lists are divided into elements. They don't have to contain the same type of
# object, but in our case, every element of the list is a chunk of our original
# data.frame. Let us access the first element of the list.
mcycle.split[[1]] # First element 
class(mcycle.split[[1]]) # Actually a data.frame.
mcycle.split[[10]] # Tenth element.
mcycle.split[[11]] # error (subscript out of bounds)

# What if you need more than one element of a list?
# In cross-validation, we need to pick one fold, and pool the rest.
# You must use single brackets when selecting more than one element.
test <- mcycle.split[[1]]
train.list <- mcycle.split[c(2,3,4,5,6,7,8,9,10)]

# We can make that a little simpler by using sequences:
2:10 # generates the numbers 2 to 5
train.list <- mcycle.split[2:10]
# But even better would be to use everything "except" the test fold.
train.list <- mcycle.split[-1]

# Now we need to "pool" all of the train folds together; the train object is
# still a list, not one big data.frame.

# Here is an ugly way to do it:
class(train.list)
train <- rbind(train.list[[1]], train.list[[2]], train.list[[3]], train.list[[4]])
class(train) # data.frame
head(train)

# rbind takes multiple arguments. But you don't want to type that out in every
# single fold.
# do.call helps us here. It has two arguments, the first of which is a function,
# and the second is a list. 
# What do.call does is run the function with each element of the list as arguments.
# So:
train <- do.call(rbind, train.list)
# Exactly the same as
train <- rbind(train.list[[1]], train.list[[2]], train.list[[3]], train.list[[4]])
# Using functions as arguments can be a little unsettling, but get used to it,
# it is the core of many R programming techniques.

# Now let's try running cross-validation using a for loop.

# First fit all the models.
model <- list()
for (fold in seq_along(mcycle.split)) { # Cycle through each fold (1 to 10)
  # Extract the training sample for this fold.
  train <- do.call(rbind, mcycle.split[-fold])
  # Fit the model.
  cubic.mcycle <- glm(formula = accel ~ times + I(times^2) + I(times^3), 
                      data = train)  # Notice train data only
  # Store the model.
  model[[fold]] <- cubic.mcycle
}

# For loops are okay for simple things, but the apply family can be really
# elegant. Here is an example.

# Create all training folds.
train.folds <- lapply(seq_along(mcycle.split), 
                      function(x) do.call(rbind, mcycle.split[-x]))

# Fit models
model <- lapply(train.folds, 
                function(x) glm(formula = accel ~ times + I(times^2) + I(times^3), 
                                      data = x))

# To unpack that a little... instead of iteratively fitting your models in a for
# loop, you create a function that returns what you want based on the fold as an
# argument.
# So you could make a function like:
get.train.fold <- function(fold) {
  do.call(rbind, mcycle.split[-fold])
}

# now you can use your little function to test if it works:
get.train.fold(1)
head(get.train.fold(5))
nrow(get.train.fold(5))

# So now instead of writing
train.folds <- list()
for (fold in seq_along(mcycle.split)) {
  train.folds[[fold]] <- get.train.fold(fold)
}

# You can just "apply" the function to each fold.
train.folds <- lapply(seq_along(mcycle.split), get.train.fold)

# And instead of writing the function separately, you can just write the
# definition in directly.
train.folds <- lapply(seq_along(mcycle.split), function(fold) {
  do.call(rbind, mcycle.split[-x])
})

# And since the function only has one line, we don't need curly braces.
train.folds <- lapply(seq_along(mcycle.split), 
                      function(fold) do.call(rbind, mcycle.split[-fold]))

# Once you get used to it, you'll miss it in every other programming language.

# So now we have a bunch of models, let's try and measure accuracy.

# Here is an example of how to predict using the new models.
predicted <- predict(model[[1]], newdata = mcycle.split[[1]])
actual <- mcycle.split[[1]]$accel

# Notice that subtraction is vector-wise. You don't have to write a for loop 
predicted - actual
# This can be very annoying in other languages.

# Now let's make a prediction across all faolds
predictions <- 
  lapply(seq_along(mcycle.split), 
         function(x) predict(model[[x]], newdata = mcycle.split[[x]]))

actual <- 
  lapply(seq_along(mcycle.split), 
         function(x) mcycle.split[[x]]$accel)

# Unfortunately both our predictions and actual are a list.
# But unlist will pool it into one big vector
unlist(predictions) - unlist(actual)

# Now we can take the root mean squared error of our predictions.
mean(sqrt((unlist(predictions) - unlist(actual))^2))

# Now, let's make this into a bigger function that takes one argument:
# the "formula" being used to determine the number of terms)
error <- function(degree) {
  model <- lapply(train.folds, 
                  function(train) 
                    glm(accel ~ poly(times, degree, raw = TRUE), data = train)) 
  predictions <- 
    lapply(seq_along(mcycle.split), 
           function(x) predict(model[[x]], newdata = mcycle.split[[x]]))
  
  actual <- 
    lapply(seq_along(mcycle.split), 
           function(x) mcycle.split[[x]]$accel)
  
  mean(sqrt((unlist(predictions) - unlist(actual))^2))
}

cv.error.by.degree <- sapply(1:18, error)
plot(1:18, cv.error.by.degree, type = 'l') # not ggplot but fast

train.error <- function(degree) {
  model <- glm(accel ~ poly(times, degree, raw = TRUE), data = mcycle)
  predictions <- predict(model, mcycle)
  actual <- mcycle$accel
  mean(sqrt((predictions - actual)^2))
}

test.error.by.degree <- sapply(1:18, error)
train.error.by.degree <- sapply(1:18, train.error)

plot(test.error.by.degree, type = 'l', ylim = c(0,50))
lines(train.error.by.degree, col = 'red')

