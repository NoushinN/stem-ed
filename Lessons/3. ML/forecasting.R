###DEMO for forecasting in R###
# Lessons are adapted and organized by Noushin Nabavi, PhD. (Adapted from DataCamp)

# load dependant libraries
library(tidyverse)
library(data.table)
library(lubridate)
library(ggfortify)


# get data
url <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1168&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=USG15NIM&scale=left&cosd=1984-01-01&coed=2019-04-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Quarterly%2C%20End%20of%20Period&fam=avg&fgst=lin&fgsnd=2009-06-01&line_index=1&transformation=lin&vintage_date=2019-08-25&revision_date=2019-08-25&nd=1984-01-01"
mydata <- read.csv(url)

# Look at the first few lines of mydata
head(mydata)

# Create a ts object called myts
myts <- ts(mydata[, 1:2], start = c(1984, 1), frequency = 4)

# Plot the data with facetting
autoplot(myts, facets = TRUE)

# Plot the data without facetting
autoplot(myts, facets = FALSE)

# Plot the three series
autoplot(gold)
autoplot(woolyrnq)
autoplot(gas)

# Find the outlier in the gold series
mytsoutlier <- which.max(myts)

# Look at the seasonal frequencies of the series
frequency(myts)

#------------------------------------------------------------------------------

# Checking time series residuals
# Check the residuals from the naive forecasts applied to the goog series
goog %>% naive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
googwn <- TRUE

# Check the residuals from the seasonal naive forecasts applied to the ausbeer series
ausbeer %>% snaive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
beerwn <- FALSE

#------------------------------------------------------------------------------

# seasonal plots
# Load the fpp2 package
library(fpp2)

# Create plots of the a10 data
autoplot(a10)
ggseasonplot(a10)

# Produce a polar coordinate season plot for the a10 data
ggseasonplot(a10, polar = TRUE)

# Restrict the ausbeer data to start in 1992
beer <- window(ausbeer, start = 1992)

# Make plots of the beer data
autoplot(beer)
ggsubseriesplot(beer)


# Do they look like white noise (TRUE or FALSE)
beerwn <- FALSE

# Create a lag plot of the data
gglagplot(a10)

# Create an autocorrelation function (ACF) plot of the data
ggAcf(a10) + 
  ggtitle("ACF plot")

#------------------------------------------------------------------------------

# White noise (a type of time series where there is no real trends in the data and is simpply random)
# Plot the original series
autoplot(a10)

# Plot the differenced series
autoplot(diff(a10))

# ACF of the differenced series
ggAcf(diff(a10))

# Ljung-Box test of the differenced series
Box.test(diff(a10), lag = 10, type = "Ljung")

#------------------------------------------------------------------------------

# Forecasts and potential futures
# Naive forecasting methods

# Use naive() to forecast the a10 series
fca10 <- naive(a10, h = 20)

# Plot and summarize the forecasts
autoplot(fca10)
summary(fca10)

# Use snaive() to forecast the a10 series
fc_a10 <- snaive(a10, h = 16)

# Plot and summarize the forecasts
autoplot(fc_a10)
summary(fc_a10)

# Assign one of the two forecasts as bestforecasts
bestforecasts <- naive_fc

#------------------------------------------------------------------------------

# Fitted values and residuals 
# Checking time series residuals
# Check the residuals from the naive forecasts applied to the a10 series
a10 %>% naive() %>% checkresiduals()

# Check the residuals from the seasonal naive forecasts applied to the a10 series
a10 %>% snaive() %>% checkresiduals()

#------------------------------------------------------------------------------

# Training and test sets
# Evaluating forecast accuracy of non-seasonal methods

# Create the training data as train
train <- subset(a10, end = 100)

# Compute naive forecasts and save to naive_fc
# h (specifies the number of values you want to forecast) 
naive_fc <- naive(train, h = 108)

# Compute mean forecasts and save to mean_fc
mean_fc <- meanf(train, h = 108)

length(train)
length(a10)

# Use accuracy() to compute RMSE statistics
# Root Mean Square Error (RMSE) is the standard deviation of the residuals (prediction errors). 
# Residuals are a measure of how far from the regression line data points are; RMSE is a measure of how spread out these residuals are. In other words, it tells you how concentrated the data is around the line of best fit.
accuracy(naive_fc, a10)
accuracy(mean_fc, a10)


# Create the training data as train
train <- subset(gold, end = 1000)

# Compute naive forecasts and save to naive_fc
naive_fc <- naive(train, h = 108)

# Compute mean forecasts and save to mean_fc
mean_fc <- meanf(train, h = 108)

# Use accuracy() to compute RMSE statistics
accuracy(naive_fc, gold)
accuracy(mean_fc, gold)

# Assign one of the two forecasts as bestforecasts
bestforecasts <- naive_fc

#------------------------------------------------------------------------------

# Evaluating forecast accuracy of seasonal methods
# Create three training series omitting the last 1, 2, and 3 years
class(myts)
train1 <- window(myts[, "DATE"], end = c(2005,4))
train2 <- window(myts[, "DATE"], end = c(2006,4))
train3 <- window(myts[, "DATE"], end = c(2007,4))

# Produce forecasts using snaive()
fc1 <- snaive(train1, h = 4)
fc2 <- snaive(train2, h = 4)
fc3 <- snaive(train3, h = 4)

# Use accuracy() to compare the MAPE of each series
# mean absolute percentage error (MAPE)
accuracy(fc1, myts[, "DATE"])["Test set", "MAPE"]
accuracy(fc2, myts[, "DATE"])["Test set", "MAPE"]
accuracy(fc3, myts[, "DATE"])["Test set", "MAPE"]
## Where possible, try to find a model that has low RMSE on a test set and has white noise residuals.

#------------------------------------------------------------------------------

# Time series cross-validation for selecting a good forecasting model
# chose model with smallest MSE (mean square error)

# Compute cross-validated errors for up to 8 steps ahead
e <- tsCV(a10, forecastfunction = naive, h = 8)

# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = TRUE)

# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()

#------------------------------------------------------------------------------

# Exponentially weighted forecasts
# Simple exponential smoothing
# Use ses() to forecast the next 10 years of winning times
fc <- ses(a10, h = 10)

# Use summary() to see the model parameters
summary(fc)

# Use autoplot() to plot the forecasts
autoplot(fc)

# Add the one-step forecasts for the training data to the plot
autoplot(fc) + autolayer(fitted(fc))

# SES vs naive
# Create a training set using subset()
train <- subset(a10, end = length(marathon) - 20)

# Compute SES and naive forecasts, save to fcses and fcnaive
fcses <- ses(train, h = 20)
fcnaive <- naive(train, h = 20)

# Calculate forecast accuracy measures
accuracy(fcses, marathon)
accuracy(fcnaive, marathon)

# Save the best forecasts as fcbest
fcbest <- fcnaive

#------------------------------------------------------------------------------

# Holt's trend methods
# Produce 10 year forecasts of austa using holt()
fcholt <- holt(a10, h = 10)

# Look at fitted model using summary()
summary(fcholt)

# Plot the forecasts
autoplot(fcholt)

# Check that the residuals look like white noise
checkresiduals(fcholt)

#------------------------------------------------------------------------------

# Exponential smoothing methods with trend and seasonality
# Holt-Winters with monthly data
# Plot the data
autoplot(a10)

# Produce 3 year forecasts
fc <- hw(a10, seasonal = "multiplicative", h = 36)

# Check if residuals look like white noise
checkresiduals(fc)
whitenoise <- FALSE

# Plot forecasts
autoplot(fc)

# Holt-Winters method with daily data
# Create training data with subset()
train <- subset(hyndsight, end = length(hyndsight) - 28)

# Holt-Winters additive forecasts as fchw
fchw <- hw(train, seasonal = "additive", h = 28)

# Seasonal naive forecasts as fcsn
fcsn <- snaive(train, h = 28)

# Find better forecasts with accuracy()
accuracy(fchw, hyndsight)
accuracy(fcsn, hyndsight)

# Plot the better forecasts
autoplot(fchw)

#------------------------------------------------------------------------------

# State space models for exponential smoothing
# Automatic forecasting with exponential smoothing
# Fit ETS model to austa in fitaus: The namesake function for finding errors, trend, and seasonality (ETS) provides a completely automatic way of producing forecasts for a wide range of time series.
fitaus <- ets(austa)

# Check residuals
checkresiduals(fitaus)

# Plot forecasts
autoplot(forecast(fitaus))

# Repeat for hyndsight data in fiths
fiths <- ets(hyndsight)
checkresiduals(fiths)
autoplot(forecast(fiths))

# Which model(s) fails test? (TRUE or FALSE)
fitausfail <- FALSE
fithsfail <- TRUE

# ETS vs seasonal naive
# Function to return ETS forecasts
fets <- function(y, h) {
  forecast(ets(y), h = h)
}

# Apply tsCV() for both methods
e1 <- tsCV(a10, fets, h = 4)
e2 <- tsCV(a10, snaive, h = 4)

# Compute MSE of resulting errors (watch out for missing values)
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Copy the best forecast MSE
bestmse <- mean(e2^2, na.rm = TRUE)

#------------------------------------------------------------------------------

# When does ETS fail?
# Plot the lynx series
autoplot(lynx)

# Use ets() to model the lynx series
fit <- ets(lynx)

# Use summary() to look at model and parameters
summary(fit)

# Plot 20-year forecasts of the lynx series
fit %>% forecast(h = 20) %>% autoplot() # Computing the ETS does not work well for all series.

#------------------------------------------------------------------------------

# Transformations for variance stabilization
# Box-Cox transformations for time series

# Plot the series
autoplot(a10)

# Try four values of lambda in Box-Cox transformations
a10 %>% BoxCox(lambda = 0.0) %>% autoplot()
a10 %>% BoxCox(lambda = 0.1) %>% autoplot()
a10 %>% BoxCox(lambda = 0.2) %>% autoplot()
a10 %>% BoxCox(lambda = 0.3) %>% autoplot()

# Compare with BoxCox.lambda()
BoxCox.lambda(a10)

# Non-seasonal differencing for stationarity
# Plot the US female murder rate
autoplot(wmurders)

# Plot the differenced murder rate
autoplot(diff(wmurders))

# Plot the ACF of the differenced murder rate
ggAcf(diff(wmurders))

# Seasonal differencing for stationarity
# Plot the data
autoplot(h02)

# Take logs and seasonal differences of h02
difflogh02 <- diff(log(h02), lag = 12)

# Plot difflogh02
autoplot(difflogh02)

# Take another difference and plot
ddifflogh02 <- diff(difflogh02)
autoplot(ddifflogh02)

# Plot ACF of ddifflogh02
ggAcf(ddifflogh02)

#------------------------------------------------------------------------------

# Automatic ARIMA models for non-seasonal time series
# autoregressive integrated moving average (ARIMA) model given a time series, just like the ets() function does for ETS models. 
# Fit an automatic ARIMA model to the austa series
fit <- auto.arima(austa)

# Check that the residuals look like white noise
checkresiduals(fit)
residualsok <- TRUE

# Summarize the model
summary(fit)

# Find the AICc value and the number of differences used
AICc <- -14.46
d <- 1

# Plot forecasts of fit
fit %>% forecast(h = 10) %>% autoplot()

# Plot forecasts from an ARIMA(0,1,1) model with no drift
austa %>% Arima(order = c(0,1,1), include.constant = FALSE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(2,1,3) model with drift
austa %>% Arima(order = c(2,1,3), include.constant = TRUE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,0,1) model with a constant
austa %>% Arima(order = c(0,0,1), include.constant = TRUE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,2,1) model with no constant
austa %>% Arima(order = c(0,2,1), include.constant = FALSE) %>% forecast() %>% autoplot()


# Comparing auto.arima() and ets() on non-seasonal data
# Set up forecast functions for ETS and ARIMA models
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(auto.arima(x), h = h)
}

# Compute CV errors for ETS on austa as e1
e1 <- tsCV(austa, fets, h = 1)

# Compute CV errors for ARIMA on austa as e2
e2 <- tsCV(austa, farima, h = 1)

# Find MSE of each model class
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Plot 10-year forecasts using the best model class
austa %>% farima(h = 10) %>% autoplot()

#------------------------------------------------------------------------------

# Seasonal ARIMA models
# Automatic ARIMA models for seasonal time series

# Check that the logged h02 data have stable variance
h02 %>% log() %>% autoplot()

# Fit a seasonal ARIMA model to h02 with lambda = 0
fit <- auto.arima(h02, lambda = 0)

# Summarize the fitted model
summary(fit)

# Record the amount of lag-1 differencing and seasonal differencing used
d <- 1
D <- 1

# Plot 2-year forecasts
fit %>% forecast(h = 24) %>% autoplot() # auto.arima() is flexible enough to even work with seasonal time series!

# Exploring auto.arima() options
# Find an ARIMA model for euretail
fit1 <- auto.arima(euretail)

# Don't use a stepwise search
fit2 <- auto.arima(euretail, stepwise = FALSE)

# AICc of better model
AICc <- 68.39

# Compute 2-year forecasts from better model
fit2 %>% forecast(h = 8) %>% autoplot()


# Comparing auto.arima() and ets() on seasonal data
# Use 20 years of the qcement data beginning in 1988
train <- window(qcement, start = 1988, end = c(2007, 4))

# Fit an ARIMA and an ETS model to the training data
fit1 <- auto.arima(train)
fit2 <- ets(train)

# Check that both models have white noise residuals
checkresiduals(fit1)
checkresiduals(fit2)

# Produce forecasts for each model
fc1 <- forecast(fit1, h = 25)
fc2 <- forecast(fit2, h = 25)

# Use accuracy() to find best model based on RMSE
accuracy(fc1, qcement)
accuracy(fc2, qcement)
bettermodel <- fit2

#------------------------------------------------------------------------------

# Dynamic regression
# Forecasting sales allowing for advertising expenditure
# Time plot of both variables
autoplot(advert, facets = TRUE)

# Fit ARIMA model
fit <- auto.arima(advert[, "sales"], xreg = advert[, "advert"], stationary = TRUE)

# Check model. Increase in sales for each unit increase in advertising
salesincrease <- coefficients(fit)[3]

# Forecast fit as fc
fc <- forecast(fit, xreg = rep(10, 6))

# Plot fc with x and y labels
autoplot(fc) + xlab("Month") + ylab("Sales")

# Forecasting electricity demand
# Time plots of demand and temperatures
autoplot(elec[, c("Demand", "Temperature")], facets = TRUE)

# Matrix of regressors
xreg <- cbind(MaxTemp = elec[, "Temperature"], 
              MaxTempSq = elec[, "Temperature"]^2, 
              Workday = elec[, "Workday"])

# Fit model
fit <- auto.arima(elec[, "Demand"], xreg = xreg)

# Forecast fit one day ahead
forecast(fit, xreg = cbind(20, 20^2, 1))

#------------------------------------------------------------------------------

# Dynamic harmonic regression
# Forecasting weekly data
# Set up harmonic regressors of order 13
harmonics <- fourier(gasoline, K = 13)

# Fit regression model with ARIMA errors
fit <- auto.arima(gasoline, xreg = harmonics, seasonal = FALSE)

# Forecasts next 3 years
newharmonics <- fourier(gasoline, K = 13, h = 156)
fc <- forecast(fit, xreg = newharmonics)

# Plot forecasts fc
autoplot(fc)

# Harmonic regression for multiple seasonality
# Fit a harmonic regression using order 10 for each type of seasonality
fit <- tslm(taylor ~ fourier(taylor, K = c(10, 10)))

# Forecast 20 working days ahead
fc <- forecast(fit, newdata = data.frame(fourier(taylor, K = c(10, 10), h = 20 * 48)))

# Plot the forecasts
autoplot(fc)

# Check the residuals of fit
checkresiduals(fit) # The residuals from the fitted model fail the tests badly, yet the forecasts are quite good

# Forecasting call bookings
# Plot the calls data
autoplot(calls)

# Set up the xreg matrix
xreg <- fourier(calls, K = c(10, 0))

# Fit a dynamic regression model
fit <- auto.arima(calls, xreg = xreg, seasonal = FALSE, stationary = TRUE)

# Check the residuals
checkresiduals(fit)

# Plot forecast for 10 working days ahead
fc <- forecast(fit, xreg = fourier(calls, c(10, 0), h = 1690))
autoplot(fc)

# TBATS models for electricity demand
# Plot the gas data
autoplot(gas)

# Fit a TBATS model to the gas data
fit <- tbats(gas)

# Forecast the series for the next 5 years
fc <- forecast(fit, h = 12 * 5)

# Plot the forecasts
autoplot(fc)

# Record the Box-Cox parameter and the order of the Fourier terms
lambda <- 0.082
K <- 5 # Just remember that completely automated solutions don't work every time
