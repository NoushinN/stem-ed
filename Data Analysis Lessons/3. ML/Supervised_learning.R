###DEMO for Supervised Learning: Regression###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# Predicting a numerical outcome (dependent variable) from other inputs (independent variables)
# e.g. how many birds will fly is regression question
# if the birds will fly or not is a classification question


# Load data and dependencies: 
library(ElemStatLearn)
library(ggplot2)
data("Puromycin")

head(Puromycin)

# predictions once you fit a model
ggplot(Puromycin, aes(x=conc, y = rate)) +
  geom_point() +
  geom_abline(color = "blue") +
  ggtitle ("Concentration vs. rate model prediction")

# predicting on new data
pred <- predict(cmodel, newdata = Puromycin)

# Root Mean Squared Error (RMSE) model to calculate prediction error
err <- price$prediction - price$price # calculate error
err2 <- err^2
rmse <- sqrt(mean(err2))
sd(price$price) > rmse

# R-squared model to see how model fits data
# R near 1 = model fits well, R near 0 means no better than guessing

rss <- sum(err2)
toterr <- price$price - mean(price$price)
toterr <- toterr^2
sstot <- sum(toterr2)
r_squared <- 1 - (rss/sstot)




