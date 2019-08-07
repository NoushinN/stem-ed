###DEMO for Normality###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# goodness of fit (gof)
# Method and example are from: May S, Hosmer DW 1998. 
# Visual inspection, described in the previous sections, is usually unreliable. 
# It’s possible to use a significance test comparing the sample distribution to a normal one in order to ascertain whether data show or not a serious deviation from normality.
# There are several methods for normality test such as Kolmogorov-Smirnov (K-S) normality test and Shapiro-Wilk’s test.


# install.packages("nortest")
# install.packages("survminer")
# ls("package:survival") #other things in this package
# Mayo Clinic Primary Biliary Cirrhosis Data, to know more type: ?pbc

# Load data and dependencies: 
library(nortest)
library(survminer)
library(survival)
library(survMisc)
library("ggpubr")


data(pbc)

# First visually Explore the pbc data

head(pbc)
pairs(pbc)
str(pbc)
summary(pbc)

____________________________________________________________________________
#to test if occurrences in a set of data follows a Normal distribution:
# you can just use a shapiro-Wilk test and some qqplot


plot(density(pbc$albumin)) #or below
hist(pbc$albumin, 100, col="black")

plot(density(pbc$chol)) 
hist(pbc$chol, 100, col="black")


# there are NA values in chol stopping plot to run
which(is.na(pbc$chol))
plot(density(pbc$chol, na.rm = TRUE)) 



#Density plot and Q-Q plot can be used to check normality visually.
#Density plot: the density plot provides a visual judgment about whether the distribution is bell shaped.
ggdensity(pbc$chol, 
          main = "Density plot of chol",
          xlab = "chol levels")

# Q-Q plot (or quantile-quantile plot) draws the correlation between a given sample and the normal distribution
ggqqplot(pbc$chol)

____________________________________________________________________________

# using the nortest package of R, we can Perform these tests:
# Anderson-Darling normality test
ad.test(pbc$albumin)

#  Cramér-von Mises test for normality
cvm.test(pbc$albumin)

#  Pearson chi-square test for normality
pearson.test(pbc$albumin)

# Shapiro-Francia test for normality
sf.test(pbc$albumin)

# normal Q-Q plot using qqnorm
qqnorm(pbc$albumin)
qqnorm(pbc$albumin);qqline(pbc$albumin, col = 2)

# Shapiro-Wilk test for normality
shapiro.test(pbc$albumin)

____________________________________________________________________________

# other goodness of fit (gof) models in base R
# These are two well-known and widely use goodness of fit tests that also have nice packages in R.
# 1.Chi Square test
# 2.Kolmogorov–Smirnov test

# let's use simulated data to do these tests

num_of_samples = 100000 # distribution numbers in a vector
x <- rgamma(num_of_samples, shape = 10, scale = 3) #function to add Gaussian noise to simulate measurement noise
x <- x + rnorm(length(x), mean=0, sd = .1)

#histogram of the vector data
p1 <- hist(x,breaks=50, include.lowest=FALSE, right=FALSE)


# 1.Chi Square test
library('zoo') # calculates the cumulative distribution function of each break point in x histogram.
breaks_cdf <- pgamma(p1$breaks, shape=10, scale=3)
null.probs <- rollapply(breaks_cdf, 2, function(x) x[2]-x[1])
a <- chisq.test(p1$counts, p=null.probs, rescale.p=TRUE, simulate.p.value=TRUE) #If you don’t have the distribution normalized set rescale.p to TRUE

# The above test results in p-value of .2 which is above the significant level. That means we can not reject the null hypothesis. In other words hypothesis that p$counts are samples from null.probs is correct assumption.

____________________________________________________________________________

# goodness of fit (gof)
# 2.Kolmogorov–Smirnov test
# simple nonparametric test for one dimensional probability distribution

num_of_samples = 100000
y <- rgamma(num_of_samples, shape = 10, scale = 3)
result = ks.test(x, y)

# This generate the value of .2 which means we will accept the null hypothesis.

____________________________________________________________________________




