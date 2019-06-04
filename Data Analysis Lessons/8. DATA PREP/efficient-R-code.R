###DEMO for writing efficient R code: benchmarking and rcpp ###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons)

# One of the relatively easy optimizations available is to use an up-to-date version of R.
# In general, R is very conservative, so upgrading doesn't break existing code.
# However, a new version will often provide free speed boosts for key functions.

# Print the R version details using version
version

# Assign the variable major to the major component
major <- version$major

# Assign the variable minor to the minor component
minor <- version$minor

#-------------------------------------------------------------------

# Benchmarking
# Load the package
library(microbenchmark)

# Compare the two functions
compare <- microbenchmark(read.csv("movies.csv"),
                          readRDS("movies.rds"),
                          times = 10)

# Print compare
compare

# How long does it take to read movies from CSV?
system.time(read.csv("movies.csv"))

# How long does it take to read movies from RDS?
system.time(readRDS("movies.rds"))


#-------------------------------------------------------------------

# For many problems your time is the expensive part.
# If having a faster computer makes you more productive, it can be cost effective to buy one. However, before you splash out on new toys for yourself, your boss/partner may want to see some numbers to justify the expense.
# Measuring the performance of your computer is called benchmarking, and you can do that with the benchmarkme package.


# Load the package
library(benchmarkme)

# Assign the variable ram to the amount of RAM on this machine
ram <- get_ram()

# Assign the variable cpu to the cpu specs
cpu <- get_cpu()

# The benchmarkme package allows you to run a set of standardized benchmarks and compare your results to other users.
# One set of benchmarks tests is reading and writing speeds.

# Run the benchmark
res <- benchmark_io(runs = 1, size = 5)

# Plot the results
plot(res)

#-------------------------------------------------------------------

# Timings - growing a vector
# Growing a vector is one of the deadly sins in R; you should always avoid it.
# The growing() function generates n random standard normal numbers, but grows the size of the vector each time an element is added!


# Use <- with system.time() to store the result as res_grow
n <- 30000
# Slow code
growing <- function(n) {
  x <- NULL
  for(i in 1:n)
    x <- c(x, rnorm(1))
  x
}
system.time(res_grow <- growing(n))


## Timings - pre-allocation
## The pre_allocate() function is defined below

n <- 30000
# Fast code
pre_allocate <- function(n) {
  x <- numeric(n) # Pre-allocate
  for(i in 1:n)
    x[i] <- rnorm(1)
  x
}
# Use <- with system.time() to store the result as res_allocate
n <- 30000
system.time(res_allocate <- pre_allocate(n))


#-------------------------------------------------------------------

# Importance of vectorizing your code
# The following piece of code is written like traditional C or Fortran code.
# Instead of using the vectorized version of multiplication, it uses a for loop.

x <- rnorm(10)
x2 <- numeric(length(x))
for(i in 1:10)
  x2[i] <- x[i] * x[i]

# Store your answer as x2_imp
x2_imp <- x * x


# Vectorized code: calculating a log-sum
# A common operation in statistics is to calculate the sum of log probabilities.
# The following code calculates the log-sum (the sum of the logs).

# x is a vector of probabilities
# Initial code
n <- 100
total <- 0
x <- runif(n)
for(i in 1:n)
  total <- total + log(x[i])

# Rewrite in a single line. Store the result in log_sum
log_sum <- sum(log(x))

#-------------------------------------------------------------------

# Data frames and matrices
# All values in a matrix must have the same data type, which has efficiency implications when selecting rows and columns.

# Which is faster, mat[, 1] or df[, 1]?
microbenchmark(mat[, 1], df[, 1])

#-------------------------------------------------------------------

# What is code profiling

# Load the profvis package
library(profvis)

data(movies, package = "ggplot2movies")
dim(movies)

# Profile the following code
profvis({
  # Load and select data
  movies <- movies[movies$Comedy == 1, ]

  # Plot data of interest
  plot(movies$year, movies$rating)

  # Loess regression line
  model <- loess(rating ~ year, data = movies)
  j <- order(movies$year)

  # Add fitted line to the plot
  lines(movies$year[j], model$fitted[j], col = "red")
})

#-------------------------------------------------------------------

# Load the microbenchmark package
library(microbenchmark)

# to optimize code, Change the data frame to a matrix

# The previous data frame solution is defined
# d() Simulates 6 dices rolls
d <- function() {
  data.frame(
    d1 = sample(1:6, 3, replace = TRUE),
    d2 = sample(1:6, 3, replace = TRUE)
  )
}

# Complete the matrix solution
m <- function() {
  matrix(sample(1:6, 6, replace = TRUE), ncol = 2)
}

# Use microbenchmark to time m() and d()
microbenchmark(
  data.frame_solution = d(),
  matrix_solution     = m()
)

# Example data
movies

# Define the previous solution
app <- function(x) {
  apply(x, 1, sum)
}

# Define the new solution
r_sum <- function(x) {
  rowSums(x)
}

# Compare the methods
microbenchmark(
  app_sol = app(movies),
  r_sum_sol = r_sum(movies)
)


# Use && instead of &
# To determine if both dice are the same, the move_square() function uses if statements.
# Using microbenchmark(), compare the function improved_move() to the previous version move().



# Define the previous solution
move <- function(movies) {
  if (movies[1] & movies[2] & movies[3]) {
    current <- 11 # Go To Jail
  }
}

# Define the improved solution
improved_move <- function(movies) {
  if (movies[1] && movies[2] && movies[3]) {
    current <- 11 # Go To Jail
  }
}

## microbenchmark both solutions
microbenchmark(move(movies), improved_move(movies), times = 1e5)

#-------------------------------------------------------------------

# CPUs - why do we have more than one
# How many cores does this machine have?
# Load the parallel package
library(parallel)

# Store the number of cores in the object no_of_cores
no_of_cores <- detectCores()

# Print no_of_cores
no_of_cores

# What sort of problems benefit from parallel computing?
# Moving to parApply

#To run code in parallel using the parallel package, the basic workflow has three steps.
## Create a cluster using makeCluster().
## Do some work.
## Stop the cluster using stopCluster().

# Determine the number of available cores.
detectCores()

# Create a cluster via makeCluster
cl <- makeCluster(2)

dd <- data.frame(x=rnorm(100), y=runif(100))

# Parallelize this code
parApply(cl, dd, 2, median)

# Stop the cluster
stopCluster(cl)


# The parallel package - parSapply
# Create a cluster via makeCluster (2 cores)
cl <- makeCluster(2)


play <- function() {
  total <- no_of_rolls <- 0
  while(total < 10) {
    total <- total + sample(1:6, 1)

    # If even. Reset to 0
    if(total %% 2 == 0) total <- 0
    no_of_rolls <- no_of_rolls + 1
  }
  no_of_rolls
}

# Export the play() function to the cluster
clusterExport(cl, "play")

# Re-write the above sapply as parSapply
res <- parSapply(cl, 1:100, function(i) play())

# Stop the cluster
stopCluster(cl)


# Timings parSapply()
# parSapply() takes three arguments.
# The cluster, the vector of numbers, and the play() wrapper function.

# Set the number of games to play
no_of_games <- 1e5

## Time serial version
system.time(serial <- sapply(1:no_of_games, function(i) play()))

## Set up cluster
cl <- makeCluster(4)
clusterExport(cl, "play")

## Time parallel version
system.time(par <- parSapply(cl, 1:no_of_games, function(i) play()))

## Stop cluster
stopCluster(cl)

#-------------------------------------------------------------------

# Load microbenchmark
library(microbenchmark)

# Define the function sum_loop
sum_loop <- function(x) {
  result <- 0
  for(i in x) result <- result + i
  result
}

# Check for equality
all.equal(sum_loop(10), sum(10))

# Compare the performance
microbenchmark(sum_loop = sum_loop(10), R_sum = sum(10))

## can notice sum() function is way faster than the function containing the for loop

#-------------------------------------------------------------------

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
