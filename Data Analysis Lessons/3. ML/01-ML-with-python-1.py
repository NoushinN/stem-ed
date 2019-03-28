"""
Introduction to Machine Learning
The mcycle.csv comes from the mcycle dataset in the MASS
package in R. Everything tested with Python 3.6.0, but any
Python 3 should be okay.
"""

import numpy as np
import pandas as pd
from sklearn import linear_model
import matplotlib.pyplot as plt
from sklearn.preprocessing import PolynomialFeatures
from sklearn.model_selection import KFold

# You may have to specify the path.
input_file = "mcycle.csv"

# comma delimited is the default
df = pd.read_csv(input_file, header = 0)

# Plot data
plt.scatter(df['times'], df['accel'],  color='black')
plt.show()

# Make a naive linear model
naive_linear_model = linear_model.LinearRegression()
naive_linear_model.fit(df[['times']], df['accel'])

# Predict over a range
predictions = pd.DataFrame({'times': np.arange(61)}) 
# Note that np.arange(61) goes from 0..60
# (It is a long story.)
predictions['linear'] = \
  naive_linear_model.predict(predictions[['times']])

# Plot data and predictions
plt.scatter(df['times'], df['accel'],  color='black')
plt.plot(predictions['times'], predictions['linear'], color='blue', linewidth=3)
plt.show()

# Generate polynomial terms.
quad_features = PolynomialFeatures(degree = 2)
quadratic = linear_model.LinearRegression(fit_intercept = False)
quadratic.fit(quad_features.fit_transform(df[['times']]), df['accel'])
predict_points = quad_features.fit_transform(predictions[['times']])
predictions['quadratic'] = quadratic.predict(predict_points)

cubic_features = PolynomialFeatures(degree = 3)
cubic = linear_model.LinearRegression(fit_intercept = False)
cubic.fit(cubic_features.fit_transform(df[['times']]), df['accel'])
predict_points = cubic_features.fit_transform(predictions[['times']])
predictions['cubic'] = cubic.predict(predict_points)

# Plot them all together.
plt.scatter(df['times'], df['accel'],  color='black')
plt.plot(predictions['times'], predictions['linear'], color='blue', linewidth=3)
plt.plot(predictions['times'], predictions['quadratic'], color='red', linewidth=3)
plt.plot(predictions['times'], predictions['cubic'], color='green', linewidth=3)
plt.show()

# Cross-validation in Python
num_folds = 10
X = df[['times']]
y = df[['accel']]

folds = KFold(num_folds, shuffle=True, random_state = 1).split(X, y)
error_squared = np.array([])
for k, (train, test) in enumerate(folds):
    model = linear_model.LinearRegression().fit(X.loc[train], y.loc[train])
    predictions = np.squeeze(model.predict(X.loc[test]))
    true_values = np.squeeze(y.loc[test])
    fold_error_squared = (predictions - true_values)**2
    error_squared = np.concatenate((error_squared, fold_error_squared), axis = 0)

# RMSE
np.mean(error_squared)**0.5

# Make a function by degree.
def rmse_by_degree(degree, raw_X, y, num_folds = 10, random_state = 1):
  features = PolynomialFeatures(degree = degree)
  X = features.fit_transform(raw_X)
  folds = KFold(num_folds, shuffle = True, random_state = random_state).split(X, y)
  error_squared = np.array([])
  for k, (train, test) in enumerate(folds):
      model = linear_model.LinearRegression().fit(X[train], y.loc[train])
      predictions = np.squeeze(model.predict(X[test]))
      true_values = np.squeeze(y.loc[test])
      fold_error_squared = (predictions - true_values)**2
      error_squared = np.concatenate((error_squared, fold_error_squared), axis = 0)
  
  # RMSE
  return(np.mean(error_squared)**0.5)

degrees = range(19)
test_errors_by_degree = \
  [rmse_by_degree(degree, df[['times']], df[['accel']]) for degree in degrees]

# Make a function by degree.
def train_rmse_by_degree(degree, raw_X, y, num_folds = 10, random_state = 1):
  features = PolynomialFeatures(degree = degree)
  X = features.fit_transform(raw_X)
  folds = KFold(num_folds, shuffle = True, random_state = random_state).split(X, y)
  model = linear_model.LinearRegression().fit(X, y)
  predictions = np.squeeze(model.predict(X))
  true_values = np.squeeze(y)
  error_squared = (predictions - true_values)**2
  # RMSE
  return(np.mean(error_squared)**0.5)


train_errors_by_degree = \
  [train_rmse_by_degree(degree, df[['times']], df[['accel']]) for degree in degrees]

# Plot them all together.
plt.plot(degrees, test_errors_by_degree, color='red', linewidth=3)
plt.plot(degrees, train_errors_by_degree, color='blue', linewidth=3)
plt.show()