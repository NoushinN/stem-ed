"""
Module 2 - Regression and Regularization

Everything tested with Python 3.6.0, but any
Python 3 should be okay.
"""
import numpy as np
import pandas as pd

from sklearn.linear_model import Ridge, Lasso, LassoCV, RidgeCV

import matplotlib.pyplot as plt

# You may have to specify the path.
input_file = "prostate.csv"

# comma delimited is the default
df = pd.read_csv(input_file, header = 0)

X = df.loc[:, df.columns != 'lpsa']
y = df[['lpsa']]

# In scikit-learn, lambda is called alpha.

# Good values aren't picked automatically for you
# These values come from what glmnet picks.
n_alphas = 100
alphas = np.logspace(6.73747387, -2.47286649, n_alphas, base = np.exp(1))

coefs = []
for a in alphas:
    ridge = Ridge(alpha=a, normalize=True).fit(X, y)
    coefs.append(ridge.coef_[0])

ax = plt.gca()
ax.plot(alphas, coefs)

ax.set_xscale('log')
ax.set_xlim(ax.get_xlim()[::-1])  # reverse axis
plt.xlabel('alpha (lambda in glmnet)')
plt.ylabel('Beta')
plt.title('Ridge coefficients as a function of the penalty')
plt.axis('tight')
plt.show()


# Cross-validation
# Ridge automatically performs leave-one-out cross-validation
model = RidgeCV(alphas = alphas, normalize = True, store_cv_values = True).fit(X, np.ravel(y))

# Best alpha
print("The best alpha/lambda for Ridge is %.6f" % model.alpha_)

# Lasso
# Good values aren't picked automatically for you
# These values come from what glmnet picks.
n_alphas = 70
alphas = np.logspace(-0.1702814, -6.5896095, n_alphas, base = np.exp(1))

coefs = []
for a in alphas:
    lasso = Lasso(alpha=a, normalize=True).fit(X, y)
    coefs.append(lasso.coef_)

ax = plt.gca()
ax.plot(alphas, coefs)

ax.set_xscale('log')
ax.set_xlim(ax.get_xlim()[::-1])  # reverse axis
plt.xlabel('alpha (lambda in glmnet)')
plt.ylabel('Beta')
plt.title('Lasso coefficients as a function of the penalty')
plt.axis('tight')
plt.show()

# Cross-validation
n_folds = 10
model = LassoCV(cv=n_folds, alphas = alphas, normalize = True).fit(X, np.ravel(y))

# Best alpha
print("The best alpha/lambda for lasso is %.6f" % model.alpha_)

# Display results
m_log_alphas = -np.log10(model.alphas_)

plt.figure()
# ymin, ymax = 2300, 3800
plt.plot(m_log_alphas, model.mse_path_, ':')
plt.plot(m_log_alphas, model.mse_path_.mean(axis=-1), 'k',
         label='Average across the folds', linewidth=2)
plt.axvline(-np.log10(model.alpha_), linestyle='--', color='k',
            label='alpha: CV estimate')
plt.legend()
plt.xlabel('-log(alpha)')
plt.ylabel('Mean square error')
plt.title('Mean square error on each fold: coordinate descent')
plt.axis('tight')
plt.show()
