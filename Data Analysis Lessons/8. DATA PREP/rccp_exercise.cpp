###DEMO for  R code woth C++: RCPP package###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons)

# optimizing R code with RCPP

# Load Rcpp
library(Rcpp)

# Simple C++ Expressions with evalCpp
# Evaluate 2 + 2 in C++
  x <- evalCpp("2 + 2")

# Evaluate 2 + 2 in R
    y <- 2 + 2

# Storage modes of x and y
    storage.mode(x)
      storage.mode(y)

# Change the C++ expression so that it returns a double
      z <- evalCpp("2.0 + 2.0")

# Evaluate 17 / 2 in C++
        evalCpp("17 / 2")

# Cast 17 to a double and divide by 2
          evalCpp("(double)17 / 2")

# Cast 56.3 to an int
            evalCpp("(int)56.3")

# Defininf functions using cppFunction
# Define the function the_answer()
              cppFunction('
                            int the_answer() {
                              return 42 ;
                            }
                            ')

# Check the_answer() returns the integer 42
                the_answer() == 42L


# Define the function euclidean_distance()
                cppFunction('
                              double euclidean_distance(double x, double y) {
                                return sqrt(x*x + y*y) ;
                              }
                              ')

# Calculate the euclidean distance
                  euclidean_distance(1.5, 2.5)


# Define the function add()
                    cppFunction('
                                  int add(int x, int y) {
                                    int res = x + y ;
                                    Rprintf("** %d + %d = %d\\n", x, y, res) ;
                                    return res ;
                                  }
                                  ')

# Call add() to print THE answer
                      add(40, 2)


# Error messages
                        cppFunction('
                                      // adds x and y, but only if they are positive
                                      int add_positive_numbers(int x, int y) {
                                        // if x is negative, stop
                                        if(x < 0) stop("x is negative") ;

                                        // if y is negative, stop
                                        if(y < 0) stop("y is negative") ;

                                        return x + y ;
                                      }
                                      ')

# Call the function with positive numbers
                          add_positive_numbers(2, 3)

# Call the function with a negative number
                            add_positive_numbers(-2, 3)

#-------------------------------------------------------------------

# C++ functions belong to C++ files
#include <Rcpp.h>
                              using namespace Rcpp ;

                              // Export the function to R
                              // [[Rcpp::export]]
                              double twice(double x) {
                                // Fix the syntax error
                                return x + x ;
                              }

                              // Include the Rcpp.h header
#include <Rcpp.h>

                              // Use the Rcpp namespace
                              using namespace Rcpp ;

                              // [[Rcpp::export]]
                              int the_answer() {
                                // Return 42
                                return 42;
                              }

                              /*** R
# Call the_answer() to check you get the right result
                              the_answer()
                                */

#-------------------------------------------------------------------

# Exported and unexported functions
#include <Rcpp.h>
                              using namespace Rcpp;

                              // Make square() accept and return a double
                              double square(double x) {
                                // Return x times x
                                return x * x;
                              }

                              // [[Rcpp::export]]
                              double dist(double x, double y) {
                                // Change this to use square()
                                return sqrt(square(x) + square(y));
                              }

# Code written as many small functions is usually easier to maintain and debug, compared to having one gigantic function

#-------------------------------------------------------------------

# R code in C++ files
#include <Rcpp.h>
                              using namespace Rcpp;

                              double square(double x) {
                                return x * x ;
                              }

                              // [[Rcpp::export]]
                              double dist(double x, double y) {
                                return sqrt(square(x) + square(y));
                              }

                              // Start the Rcpp R comment block
                              /*** R
# Call dist() to the point (3, 4)
                              dist(3, 4)
# Close the Rcpp R comment block
                                */

#-------------------------------------------------------------------

# if and if/else
#include <Rcpp.h>
                              using namespace Rcpp ;

                              // [[Rcpp::export]]
                              double absolute(double x) {
                                // Test for x greater than zero
                                if(x > 0) {
                                  // Return x
                                  return x;
                                  // Otherwise
                                } else {
                                  // Return negative x
                                  return -x;
                                }
                              }

                              /*** R
                              absolute(pi)
                                absolute(-3)
                                */

#-------------------------------------------------------------------
# Calculating square roots with a for loop
#include <Rcpp.h>
                              using namespace Rcpp;

                              // [[Rcpp::export]]
                              double sqrt_approx(double value, int n) {
                                // Initialize x to be one
                                double x = 1.0;
                                // Specify the for loop
                                for(int i = 0; i < n; i++) {
                                  x = (x + value / x) / 2.0;
                                }
                                return x;
                              }

                              /*** R
                              sqrt_approx(2, 10)
                                */

#-------------------------------------------------------------------
# Breaking out of a for loop

#include <Rcpp.h>
                              using namespace Rcpp;

                              // [[Rcpp::export]]
                              List sqrt_approx(double value, int n, double threshold) {
                                double x = 1.0;
                                double previous = x;
                                bool is_good_enough = false;
                                int i;
                                for(i = 0; i < n; i++) {
                                  previous = x;
                                  x = (x + value / x) / 2.0;
                                  is_good_enough = fabs(previous - x) < threshold;

                                  // If the solution is good enough, then "break"
                                  if(is_good_enough) break;
                                }
                                return List::create(_["i"] = i , _["x"] = x);
                              }

                              /*** R

#-------------------------------------------------------------------

# Calculating square roots with a while loop
#include <Rcpp.h>
                              using namespace Rcpp;

                              // [[Rcpp::export]]
                              double sqrt_approx(double value, double threshold) {
                                double x = 1.0;
                                double previous = x;
                                bool is_good_enough = false;

                                // Specify the while loop
                                while(!is_good_enough) {
                                  previous = x;
                                  x = (x + value / x) / 2.0;
                                  is_good_enough = fabs(x - previous) < threshold;
                                }

                                return x ;
                              }

                              /*** R
                                sqrt_approx(2, 0.00001)
                                */

#-------------------------------------------------------------------

# Do it again: do-while loop
#include <Rcpp.h>
                              using namespace Rcpp;

                              // [[Rcpp::export]]
                              double sqrt_approx(double value, double threshold) {
                                double x = 1.0;
                                double previous = x;
                                bool is_good_enough = false;

                                // Initiate do while loop
                                do {
                                  previous = x;
                                  x = (x + value / x) / 2.0;
                                  is_good_enough = fabs(x - previous) < threshold;
                                  // Specify while condition
                                } while(!is_good_enough);

                                return x;
                              }

                              /*** R
                              sqrt_approx(2, 0.00001)
                                */

#-------------------------------------------------------------------

# Rcpp classes and vectors
## In C++, indexes start at zero so the first element is x[0] and the last is x[n - 1]

## Indexing a vector
#include <Rcpp.h>
                              using namespace Rcpp;

                              // [[Rcpp::export]]
                              double first_plus_last(NumericVector x) {
                                // The size of x
                                int n = x.size();
                                // The first element of x
                                double first = x[0];
                                // The last element of x
                                double last = x[n - 1];
                                return first + last;
                                }

                              /*** R
                              x <- c(6, 28, 496, 8128)
                                first_plus_last(x)
# Does the function give the same answer as R?
                                all.equal(first_plus_last(x), x[1] + x[4])
                                */

#-------------------------------------------------------------------

# sum of double vectors
#include <Rcpp.h>
                              using namespace Rcpp;

                              // [[Rcpp::export]]
                              double sum_cpp(NumericVector x) {
                                // The size of x
                                int n = x.size();
                                // Initialize the result
                                double result = 0;
                                // Complete the loop specification
                                for(int i = 0; i < n; i++) {
                                  // Add the next value
                                  result = result + x[i];
                                }
                                return result;
                              }

/*** R
set.seed(42)
x <- rnorm(1e6)
sum_cpp(x)
*/

#-------------------------------------------------------------------

# creating vectors - Sequence of integers
#include <Rcpp.h>
using namespace Rcpp;

// Set the return type to IntegerVector
// [[Rcpp::export]]
IntegerVector seq_cpp(int lo, int hi) {
  int n = hi - lo + 1;

  // Create a new integer vector, sequence, of size n
  IntegerVector sequence(n);

  for(int i = 0; i < n; i++) {
    // Set the ith element of sequence to lo plus i
    sequence[i] = lo + i;
  }

  // Return
  return sequence;
}

/*** R
lo <- -2
hi <- 5
seq_cpp(lo, hi)
# Does it give the same answer as R's seq() function?
  all.equal(seq_cpp(lo, hi), seq(lo, hi))
  */

#-------------------------------------------------------------------
# Create vector with given values
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List create_vectors() {
  // Create an unnamed character vector
  CharacterVector polygons = CharacterVector::create("triangle", "square", "pentagon");
  // Create a named integer vector
  IntegerVector mersenne_primes = IntegerVector::create(_["first"] = 3, _["second"] = 7, _["third"] = 31);
  // Create a named list
  List both = List::create(_["polygons"] = polygons, _["mersenne_primes"] = mersenne_primes);
  return both;
}

/*** R
create_vectors()
  */

#-------------------------------------------------------------------

# vector cloning

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List change_negatives_to_zero(NumericVector the_original) {
  // Set the copy to the original
  NumericVector the_copy = the_original;
  int n = the_original.size();
  for(int i = 0; i < n; i++) {
    if(the_copy[i] < 0) the_copy[i] = 0;
  }
  return List::create(_["the_original"] = the_original, _["the_copy"] = the_copy);
}

// [[Rcpp::export]]
List change_negatives_to_zero_with_cloning(NumericVector the_original) {
  // Clone the original to make the copy
  NumericVector the_copy = clone(the_original);
  int n = the_original.size();
  for(int i = 0; i < n; i++) {
    if(the_copy[i] < 0) the_copy[i] = 0;
  }
  return List::create(_["the_original"] = the_original, _["the_copy"] = the_copy);
}

/*** R
x <- c(0, -4, 1, -2, 2, 4, -3, -1, 3)
  change_negatives_to_zero(x)
# Need to define x again because it's changed now
  x <- c(0, -4, 1, -2, 2, 4, -3, -1, 3)
  change_negatives_to_zero_with_cloning(x)
  */

#-------------------------------------------------------------------

# Weighted mean (C++ version)
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double weighted_mean_cpp(NumericVector x, NumericVector w) {
  // Initialize these to zero
  double total_w = 0;
  double total_xw = 0;

  // Set n to the size of x
  int n = x.size();

  // Specify the for loop arguments
  for(int i = 0; i < n; i++) {
    // Add ith weight
    total_w += w[i];
    // Add the ith data value times the ith weight
    total_xw += x[i] * w[i];
  }

  // Return the total product divided by the total weight
  return total_xw / total_w;
}

/*** R
x <- c(0, 1, 3, 6, 2, 7, 13, 20, 12, 21, 11)
w <- 1 / seq_along(x)
weighted_mean_cpp(x, w)
# Does the function give the same results as R's weighted.mean() function?
all.equal(weighted_mean_cpp(x, w), weighted.mean(x, w))
*/

#-------------------------------------------------------------------
# handling missing values
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double weighted_mean_cpp(NumericVector x, NumericVector w) {
  double total_w = 0;
  double total_xw = 0;

  int n = x.size();

  for(int i = 0; i < n; i++) {
    // If the ith element of x or w is NA then return NA
    if(NumericVector::is_na(x[i]) || NumericVector::is_na(w[i])) {
      return NumericVector::get_na();
    }
    total_w += w[i];
    total_xw += x[i] * w[i];
  }

  return total_xw / total_w;
}

/*** R
x <- c(0, 1, 3, 6, 2, 7, 13, NA, 12, 21, 11)
  w <- 1 / seq_along(x)
  weighted_mean_cpp(x, w)
  */

#-------------------------------------------------------------------

# Don't change the size of Rcpp vectors
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector good_select_positive_values_cpp(NumericVector x) {
  int n_elements = x.size();
  int n_positive_elements = 0;

  // Calculate the size of the output
  for(int i = 0; i < n_elements; i++) {
    // If the ith element of x is positive
    if(x[i] > 0) {
      // Add 1 to n_positive_elements
      n_positive_elements++;
    }
  }

  // Allocate a vector of size n_positive_elements
  NumericVector positive_x(n_positive_elements);

  // Fill the vector
  int j = 0;
  for(int i = 0; i < n_elements; i++) {
    // If the ith element of x is positive
    if(x[i] > 0) {
      // Set the jth element of positive_x to the ith element of x
      positive_x[j] = x[i];
      // Add 1 to j
      j++;
    }
  }
  return positive_x;
}

/*** R
set.seed(42)
  x <- rnorm(1e4)
# Does it give the same answer as R?
  all.equal(good_select_positive_values_cpp(x), x[x > 0])
# Which is faster?
  microbenchmark(
    bad_cpp = bad_select_positive_values_cpp(x),
    good_cpp = good_select_positive_values_cpp(x)
  )
  */
#-------------------------------------------------------------------

# STL vectors
## standard template library (stl) is a C++ library containing flexible algorithms and data structures
#include <Rcpp.h>
using namespace Rcpp;

// Set the return type to a standard double vector
// [[Rcpp::export]]
std::vector<double> select_positive_values_std(NumericVector x) {
  int n = x.size();

  // Create positive_x, a standard double vector
  std::vector<double> positive_x;

  for(int i = 0; i < n; i++) {
    if(x[i] > 0) {
      // Append the ith element of x to positive_x
      positive_x.push_back(x[i]);
    }
  }
  return positive_x;
}

/*** R
set.seed(42)
  x <- rnorm(1e6)
# Does it give the same answer as R?
  all.equal(select_positive_values_std(x), x[x > 0])
# Which is faster?
  microbenchmark(
    good_cpp = good_select_positive_values_cpp(x),
    std = select_positive_values_std(x)
  )
  */

#-------------------------------------------------------------------

# Random number generation
## Scalar random number generation
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector positive_rnorm(int n, double mean, double sd) {
  // Specify out as a numeric vector of size n
  NumericVector out(n);

  // This loops over the elements of out
  for(int i = 0; i < n; i++) {
    // This loop keeps trying to generate a value
    do {
      // Call R's rnorm()
      out[i] = R::rnorm(mean, sd);
      // While the number is negative, keep trying
    } while(out[i] <= 0);
  }
  return out;
}

/*** R
positive_rnorm(10, 2, 2)
  */

#-------------------------------------------------------------------

# Sampling from a mixture of distributions (I)
# create a uniform random number using runif
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int choose_component(NumericVector weights, double total_weight) {
  // Generate a uniform random number from 0 to total_weight
  double x = R::runif(0, total_weight);

  // Remove the jth weight from x until x is small enough
  int j = 0;
  while(x >= weights[j]) {
    // Subtract jth element of weights from x
    x -= weights[j];
    j++;
  }

  return j;
}

/*** R
weights <- c(0.3, 0.7)
# Randomly choose a component 5 times
  replicate(5, choose_component(weights, sum(weights)))
  */
#-------------------------------------------------------------------

# Sampling from a mixture of distributions (II)
#include <Rcpp.h>
using namespace Rcpp;

// From previous exercise; do not modify
// [[Rcpp::export]]
int choose_component(NumericVector weights, double total_weight) {
  double x = R::runif(0, total_weight);
  int j = 0;
  while(x >= weights[j]) {
    x -= weights[j];
    j++;
  }
  return j;
}

// [[Rcpp::export]]
NumericVector rmix(int n, NumericVector weights, NumericVector means, NumericVector sds) {
  // Check that weights and means have the same size
  int d = weights.size();
  if(means.size() != d) {
    stop("means size != weights size");
  }
  // Do the same for the weights and std devs
  if(sds.size() != d) {
    stop("sds size != weights size");
  }

  // Calculate the total weight
  double total_weight = sum(weights);

  // Create the output vector
  NumericVector res(n);

  // Fill the vector
  for(int i = 0; i < n; i++) {
    // Choose a component
    int j = choose_component(weights, total_weight);

    // Simulate from the chosen component
    res[i] = R::rnorm(means[j], sds[j]);
  }

  return res;
}

/*** R
weights <- c(0.3, 0.7)
  means <- c(2, 4)
  sds <- c(2, 4)
  rmix(10, weights, means, sds)
  */

#-------------------------------------------------------------------

# rolling means
## (sometimes called moving averages) are used in time series analysis to smooth out noise
## The value at each time point is replaced with the mean of the values at nearby time points (the window).

# Complete the definition of rollmean3()
rollmean3 <- function(x, window = 3) {
# Add the first window elements of x
  initial_total <- sum(head(x, window))

# The elements to add at each iteration
  lasts <- tail(x, - window)

# The elements to remove
    firsts <- head(x, - window)

# Take the initial total and add the
# cumulative sum of lasts minus firsts
      other_totals <- initial_total + cumsum(lasts - firsts)

# Build the output vector
        c(
          rep(NA, window - 1),    # leading NA
          initial_total / window, # initial mean
          other_totals / window   # other means
        )
}


# From previous step; do not modify
rollmean3 <- function(x, window = 3) {
  initial_total <- sum(head(x, window))
  lasts <- tail(x, - window)
  firsts <- head(x, - window)
  other_totals <- initial_total + cumsum(lasts - firsts)
  c(rep(NA, window - 1), initial_total / window, other_totals / window)
}

# This checks rollmean1() and rollmean2() give the same result
all.equal(rollmean1(x), rollmean2(x))

# This checks rollmean1() and rollmean3() give the same result
  all.equal(rollmean1(x), rollmean3(x))

# Benchmark the performance
    microbenchmark(
      rollmean1(x),
      rollmean2(x),
      rollmean3(x),
      times = 5
    )
#-------------------------------------------------------------------

# Rolling means (in C++)
#include <Rcpp.h>
      using namespace Rcpp;

      // [[Rcpp::export]]
      NumericVector rollmean4(NumericVector x, int window) {
        int n = x.size();

        // Set res as a NumericVector of NAs with length n
        NumericVector res(n, NumericVector::get_na());

        // Sum the first window worth of values of x
        double total = 0.0;
        for(int i = 0; i < window; i++) {
          total += x[i];
        }

        // Treat the first case seperately
        res[window - 1] = total / window;

        // Iteratively update the total and recalculate the mean
        for(int i = window; i < n; i++) {
          // Remove the (i - window)th case, and add the ith case
          total += - x[i - window] + x[i];
          // Calculate the mean at the ith position
          res[i] = total / window;
        }

        return res;
      }

      /*** R
# Compare rollmean2, rollmean3 and rollmean4
      set.seed(42)
        x <- rnorm(10000)
        microbenchmark(
          rollmean2(x, 4),
          rollmean3(x, 4),
          rollmean4(x, 4),
          times = 5
        )
        */

#-------------------------------------------------------------------

# Last observation carried forward
## useful for missing values

#include <Rcpp.h>
      using namespace Rcpp;

      // [[Rcpp::export]]
      NumericVector na_locf2(NumericVector x) {
        // Initialize to NA
        double current = NumericVector::get_na();

        int n = x.size();
        NumericVector res = clone(x);
        for(int i = 0; i < n; i++) {
          // If ith value of x is NA
          if(NumericVector::is_na(x[i])) {
            // Set ith result as current
            res[i] = current;
          } else {
            // Set current as ith value of x
            current = x[i];
          }
        }
        return res ;
      }

      /*** R
      library(microbenchmark)
        set.seed(42)
        x <- rnorm(1e5)
# Sprinkle some NA into x
        x[sample(1e5, 100)] <- NA
      microbenchmark(
        na_locf1(x),
        na_locf2(x),
        times = 5
      )
        */
#-------------------------------------------------------------------

# Mean carried forward
#include <Rcpp.h>
      using namespace Rcpp;

      // [[Rcpp::export]]
      NumericVector na_meancf2(NumericVector x) {
        double total_not_na = 0.0;
        double n_not_na = 0.0;
        NumericVector res = clone(x);

        int n = x.size();
        for(int i = 0; i < n; i++) {
          // If ith value of x is NA
          if(NumericVector::is_na(x[i])) {
            // Set the ith result to the total of non-missing values
            // divided by the number of non-missing values
            res[i] = total_not_na / n_not_na;
          } else {
            // Add the ith value of x to the total of non-missing values
            total_not_na += x[i];
            // Add 1 to the number of missing values
            n_not_na++;
          }
        }
        return res;
      }

      /*** R
      library(microbenchmark)
        set.seed(42)
        x <- rnorm(1e5)
        x[sample(1e5, 100)] <- NA
      microbenchmark(
        na_meancf1(x),
        na_meancf2(x),
        times = 5
      )
        */

#-------------------------------------------------------------------

# Auto regressive model
## Auto-regressive (AR) models are a type of linear regression for time series where the predicted values depend upon the values at previous time points
## Simulate AR(p) model
#include <Rcpp.h>
      using namespace Rcpp;

      // [[Rcpp::export]]
      NumericVector ar2(int n, double c, NumericVector phi, double eps) {
        int p = phi.size();
        NumericVector x(n);

        // Loop from p to n
        for(int i = p; i < n; i++) {
          // Generate a random number from the normal distribution
          double value = R::rnorm(c, eps);
          // Loop from zero to p
          for(int j = 0; j < p; j++) {
            // Increase by the jth element of phi times
            // the "i minus j minus 1"th element of x
            value += phi[j] * x[i - j - 1];
          }
          x[i] = value;
        }
        return x;
      }

      /*** R
      d <- data.frame(
        x = 1:50,
        y = ar2(50, 10, c(1, -0.5), 1)
      )
      ggplot(d, aes(x, y)) + geom_line()
      */


#-------------------------------------------------------------------

## Simulate MA(q) model
## Moving average (MA) models also depend upon the previous iteration. Unlike AR models, the dependency is on the noise part.


#include <Rcpp.h>
      using namespace Rcpp;

      // [[Rcpp::export]]
      NumericVector ma2(int n, double mu, NumericVector theta, double sd) {
        int q = theta.size();
        NumericVector x(n);

        // Generate the noise vector
        NumericVector eps = rnorm(n, 0.0, sd);

        // Loop from q to n
        for(int i = q; i < n; i++) {
          // Value is mean plus noise
          double value = mu + eps[i];
          // Loop from zero to q
          for(int j = 0; j < q; j++) {
            // Increase by the jth element of theta times
            // the "i minus j minus 1"th element of eps
            value += theta[j] * eps[i - j - 1];
          }
          // Set ith element of x to value
          x[i] = value;
        }
        return x;
      }

      /*** R
      d <- data.frame(
        x = 1:50,
        y = ma2(50, 10, c(1, -0.5), 1)
      )
      ggplot(d, aes(x, y)) + geom_line()
      */

#-------------------------------------------------------------------

## ARMA (p, q) model
# An auto-regressive moving average model (ARMA(p, q)) combines the autoregression (AR(p)) and moving average (MA(q)) models into one.
## The current value of the simulated vector depends both on previous values of the same vector as well as previous values of the noise vector.



#include <Rcpp.h>
      using namespace Rcpp;

      // [[Rcpp::export]]
      NumericVector arma(int n, double mu, NumericVector phi, NumericVector theta, double sd) {
        int p = phi.size();
        int q = theta.size();
        NumericVector x(n);

        // Generate the noise vector
        NumericVector eps = rnorm(n, 0.0, sd);

        // Start at the max of p and q plus 1
        int start = std::max(p, q) + 1;

        // Loop i from start to n
        for(int i = start; i < n; i++) {
          // Value is mean plus noise
          double value = mu + eps[i];

          // The MA(q) part
          for(int j = 0; j < q; j++) {
            // Increase by the jth element of theta times
            // the "i minus j minus 1"th element of eps
            value += theta[j] * eps[i - j - 1];
          }

          // The AR(p) part
          for(int j = 0; j < p; j++) {
            // Increase by the jth element of phi times
            // the "i minus j minus 1"th element of x
            value += phi[j] * x[i - j - 1];
          }

          x[i] = value;
        }
        return x;
      }

      /*** R
      d <- data.frame(
          x = 1:50,
          y = arma(50, 10, c(1, -0.5), c(1, -0.5), 1)
      )
        ggplot(d, aes(x, y)) + geom_line()
        */

