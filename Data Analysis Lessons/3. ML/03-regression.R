library(ElemStatLearn)
data(prostate)

# Check the data.frame
head(prostate)

# The raw data has a "train" column, but we won't use that.
data.cols <- setdiff(colnames(prostate), "train")
full.data <- prostate[, data.cols]

# One "gotcha" in R is factors. It is hard to know whether a variable is going
# to be automatically converted to a factor. It mostly happens with variables
# that are coded as characters. You check the default in your system:
options()$stringsAsFactor
# But it is usually set to true.
# Some people like to set this default to FALSE.

# Is gleason a factor or an integer? Not a character, but since it comes from
# some other package it would be totally reasonable because it only has a few
# levels (possibilities). 
table(full.data$gleason)

# Check the data type of the columns
sapply(full.data, class)

# Why does that work?
# prostate is a data.frame, which is a type of list
# sapply passes each element (column) of the list (data.frame) to the function class

# Why sapply instead of lapply?
lapply(full.data, class)
# Because the result is simplified to a vector

# One quick way of taking a look at the data is to run summary on the data.frame
summary(full.data)

# But summaries can hide things too:
table(full.data$age)
# A lot of 68 year olds!

# A quick look at the first six rows tells you more than you might think:
head(full.data)

# Okay, so now let us take a look at some of those continuous variables (lbph and lcp)
table(full.data$lbph) # Most of the data is at one point
table(full.data$lcp) # Here too

# Why should we care? Shouldn't the model take care of this? What if the actual
# value didn't matter, but it was whether it was that one common value?

# Check a few more variables.
table(full.data$gleason)
table(full.data$pgg45)
table(full.data$svi)

# Feature engineering matters. Machine learning people don't talk about it
# because the dream is to get the models to work without feature engineering.
# While we wait for some breakthrough in the field, we still have to think and
# check. And, in science, we will probably always be testing new theories.

# Most importantly, let's check the distribution of the target:
table(full.data$lpsa)
# There is no way the 93 points can provide that precision.

# Correlation
cor(full.data)
pairs(full.data, col = "violet")

# lcp looks correlated, but, only when the common value is removed.
pairs(full.data[c("lcp", "lpsa")])

# Let's check out that theory:
common.char <- names(sort(table(full.data$lcp), decreasing = TRUE))[1]
common.lcp <- as.character(full.data$lcp) == common.char

library(dplyr)
full.data %>% filter(!common.lcp) %>% select(lcp, lpsa) %>% cor
full.data %>% select(lcp, lpsa) %>% cor

# Wrong, but still helpful to check.


# Now let's try a lasso and ridge model on the data.
# glmnet is written by Tibshirani and Hastie, so it is a good source.
# But the package certainly has some ugly points.
library(glmnet)
x.cols <- setdiff(colnames(full.data), "lpsa")

lasso.model <- 
  glmnet(x = as.matrix(full.data[x.cols]),
         y = full.data[["lpsa"]],
         alpha = 1) # Lasso penalty (sparse)

lasso.model
# What does %Dev Mean?

# dev.ratio	
# The fraction of (null) deviance explained (for "elnet", this is the R-square).
# The deviance calculations incorporate weights if present in the model. The
# deviance is defined to be 2*(loglike_sat - loglike), where loglike_sat is the
# log-likelihood for the saturated model (a model with a free parameter per
# observation). Hence dev.ratio=1-dev/nulldev.
plot(lasso.model$lambda, lasso.model$dev.ratio)

# Let's plot how lasso selected the model.
betas <- lasso.model$beta
class(betas)

# betas is a sparse matrix
# Convert to a normal matrix for use with melt.
betas <- as.matrix(betas)

# tidyr gather specificially does not work with matrices.
# https://github.com/tidyverse/tidyr/issues/437 
# (Hadley Wickham: "I think this is out of scope for tidyr since it only 
# works with data frames.")

# So I use reshape2 here
library(reshape2)
betas.melted <- melt(betas, 
                     varnames = c("variable", "lambda"), 
                     value.name = "beta")


# Strip out 's' from the lambda and get the real value.
lambda.select <- as.integer(gsub('s', '', betas.melted$lambda))
head(lambda.select) # zero-based indexing.
betas.melted$lambda.val <- lasso.model$lambda[lambda.select + 1]

# And a nice plot
library(ggplot2)
ggplot(betas.melted, 
       aes(colour = variable, group = variable, x = lambda.val, y = beta)) + 
  geom_line() + 
  scale_x_reverse(name = "lambda")

# running plot on the model object also gives a similar result
plot(lasso.model)
# But this is not always available.

# Let's do the same for ridge now.
ridge.model <- 
  glmnet(x = as.matrix(full.data[x.cols]),
         y = full.data[["lpsa"]],
         alpha = 0) # Ridge penalty (shrunk)


ridge.model

# cv.lasso does some automatic cross-validation which is typical of machine
# learning packages.

# How does it behave under different number of folds of cross-validation?
set.seed(1)
cv.lasso.10 <- 
  cv.glmnet(x = as.matrix(full.data[x.cols]),
            y = full.data[["lpsa"]],
            alpha = 1,
            nfolds = 10)

set.seed(1)
cv.lasso.30 <- 
  cv.glmnet(x = as.matrix(full.data[x.cols]),
            y = full.data[["lpsa"]],
            alpha = 1,
            nfolds = 30)

set.seed(1)
cv.lasso.70 <- 
  cv.glmnet(x = as.matrix(full.data[x.cols]),
            y = full.data[["lpsa"]],
            alpha = 1,
            nfolds = 70)

cv.lasso.10$lambda.min
cv.lasso.30$lambda.min
cv.lasso.70$lambda.min

# How does ridge behave under different number of fold of cross-validation?
set.seed(1)
cv.ridge.10 <- 
  cv.glmnet(x = as.matrix(full.data[x.cols]),
            y = full.data[["lpsa"]],
            alpha = 0,
            nfolds = 10)

set.seed(1)
cv.ridge.30 <- 
  cv.glmnet(x = as.matrix(full.data[x.cols]),
            y = full.data[["lpsa"]],
            alpha = 0,
            nfolds = 30)

set.seed(1)
cv.ridge.70 <- 
  cv.glmnet(x = as.matrix(full.data[x.cols]),
            y = full.data[["lpsa"]],
            alpha = 0,
            nfolds = 70)

cv.lasso.10$lambda.min
cv.lasso.30$lambda.min
cv.lasso.70$lambda.min


# Why does ridge shrink, but lasso select?
# I like to simulate something to really understand how it works.

# Make a simple data.frame 
df <- data.frame(x=1:4,y=c(2,1,4,3))

# We are drawing a line through four points.
plot(df$x, df$y)

# Manually define sum of square error.
sum.square.error <- function(slope) sum((df$y - (slope * df$x))^2)

# Calculate the sum of square error for just these points.
slopes <- seq(-1, 2, by = 0.01)
error <- sapply(slopes, sum.square.error)
plot(slopes, error)

# Best slope is close to 1
slopes[which.min(error)] # 0.93 specifically.

# Now let's make functions that give the best slope for a specific lambda and penalty.
l1.min <- function(lambda, slopes) {
  error = sapply(slopes, sum.square.error)
  penalty = abs(lambda * slopes) # Lasso penalty
  slopes[which.min(error + penalty)]
}


l2.min <- function(lambda, slopes) {
  error = sapply(slopes, sum.square.error)
  penalty = (lambda * slopes)^2 # Ridge penalty
  slopes[which.min(error + penalty)]
}

# Setup some lambdas and find the minimum slope
lambdas = seq(0,60, by = 0.1)
l1.mins <- sapply(lambdas, function(lambda) l1.min(lambda, slopes))
plot(lambdas, l1.mins)
# As predicted, it selects.

l2.mins <- sapply(lambdas, function(lambda) l2.min(lambda, slopes))
plot(lambdas, l2.mins)
tail(l2.mins)
# As predicted, it shrinks.

# But why?
# Look at the lasso penalty for one specific lambda.
lambda <- 40
error <- sapply(slopes, sum.square.error)
penalty <- abs(lambda * slopes)

plot(slopes, error + penalty, ylim = c(0, 120), type = 'l')
lines(slopes, penalty, col = 'red')
lines(slopes, error, col = 'blue')


# Look at the ridge penalty for one specific lambda.
lambda <- 40
error <- sapply(slopes, sum.square.error)
penalty <- (lambda * slopes)^2

plot(slopes, error + penalty, ylim = c(0, 120), type = 'l')
lines(slopes, penalty, col = 'red')
lines(slopes, error, col = 'blue')


# Something just for fun.
# I always wondered why there were these weird nicknames in R.
R.version
# Eggshell Igloo?
# It turns out they are all references to Peanuts cartoons.
library(cowplot)
ggdraw() + 
  draw_image("https://www.weeklystorybook.com/.a/6a0105369e6edf970b01bb083fe905970d-800wi")

