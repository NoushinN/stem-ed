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
