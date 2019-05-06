###DEMO for exploratory and explanatory data visualization in base R +###
# lessons curated by Noushin Nabavi, PhD

# exploring different types of plots:
## base graphics, grid graphics, lattice graphics, ggplot2
require(lattice)
library(MASS)

# load dataset
x <- datasets::ChickWeight

str(x)

# Plot ChickWeight data
plot(x)

# Plot Time vs. weight
plot(ChickWeight$Time, ChickWeight$weight,
     xlab = "Chick weight",
     ylab = "Chick time")

# Apply the plot() function to Diet
plot(ChickWeight$Diet)

#-------------------------------------------------------------------------------

# Plot Time vs. weight as red triangles
plot(ChickWeight$Time, ChickWeight$weight,
     pch = 17, col = "red")

# Plot Time vs. weight as blue circles
points(ChickWeight$Time, ChickWeight$weight,
       pch = 16, col = "blue")

# Add an equality reference line with abline()
abline(a = 0, b = 15, lty = 2) #lty makes the reference line dashed

#-------------------------------------------------------------------------------

# Set up the side-by-side plot array
par(mfrow = c(1, 2))

# First plot: Time vs. weight in its original form
plot(ChickWeight$Time, ChickWeight$weight)

# Add the first title
title("Original representation")

# Second plot: log-log plot of Time vs. weight
plot(ChickWeight$Time, ChickWeight$weight,
     log = "xy")

# Add the second title
title("Log-log plot")

#-------------------------------------------------------------------------------

# Set up a side-by-side plot array
par(mfrow = c(1, 2))

# Create a table of Time record counts and sort
tbl <- sort(table(ChickWeight$Time),
            decreasing = TRUE)

# Create the pie chart
pie(tbl)

# Give it a title
title("Pie chart") # avoid pie charts

# Create the barplot with perpendicular, half-sized labels
barplot(tbl, las = 2, cex.names = 0.5)

# Add a title
title("Bar chart")

#-------------------------------------------------------------------------------

# Characterizing a single variable
# Set up a side-by-side plot array
par(mfrow = c(1, 2))

# Create a histogram of counts with hist()
hist(ChickWeight$Time, main = "hist() plot")

# Create a normalized histogram with truehist()
truehist(ChickWeight$Time, main = "truehist() plot")

# Density plots as smoothed histograms
# Create index16, pointing to 16-week chicks
index16 <- which(ChickWeight$Time == 16)

# Get the 16-week chick weights
weights <- ChickWeight$weight[index16]

# Plot the normalized histogram
truehist(weights)

# Add the density curve to the histogram
lines(density(weights))

#-------------------------------------------------------------------------------

## Using the qqPlot() function to see many details in data
# Load the car package to make qqPlot() available
library(car)

# Create index16, pointing to 16-week chicks
index16 <- which(ChickWeight$Time == 16)

# Get the 16-week chick weights
weights <- ChickWeight$weight[index16]

# Show the normal QQ-plot of the chick weights
qqPlot(weights)

#-------------------------------------------------------------------------------

# Visualizing relations between two variables
# Set up a side-by-side plot array
par(mfrow = c(1, 2))

# Create the standard scatterplot
plot(ChickWeight$Time, ChickWeight$weight)

# Add the title
title("Standard scatterplot")

# Create the sunflowerplot
sunflowerplot(ChickWeight$Time, ChickWeight$weight)

# Add the title
title("Sunflower plot")

#-------------------------------------------------------------------------------
# Create a variable-width boxplot with log y-axis & horizontal labels

# Create a side-by-side boxplot summary
boxplot(ChickWeight$Time, ChickWeight$weight)


boxplot(Time ~ weight, data = x, 
        varwidth = TRUE, log = "x", las = 1)

# Add a title
title("Time vs. Weight Index")

# Create a mosaic plot using the formula interface
mosaicplot(Diet ~ Chick, data = x)

#-------------------------------------------------------------------------------

# Showing more complex relations between variables
# Load aplpack to make the bagplot() function available
library(aplpack)

# Create a bagplot for the same two variables
bagplot(ChickWeight$Time, ChickWeight$weight, cex = 1.2)

# Add an equality reference line
abline(a = 0, b = 1, lty = 2)

#-------------------------------------------------------------------------------

#Plotting correlation matrices with the corrplot() function
# Load the corrplot library for the corrplot() function
library(corrplot)

# Extract the numerical variables from ChickWeight
numericalVars <- ChickWeight[,1:4]

# Compute the correlation matrix for these variables
corrMat <- cor(numericalVars)

# Generate the correlation ellipse plot
corrplot(corrMat, method = "ellipse")

#-------------------------------------------------------------------------------

#Building and plotting rpart() models
# Load the rpart library
library(rpart)

# Fit an rpart model to predict medv from all other ChickWeight variables
tree_model <- rpart(Time ~ ., data = x)


# Set up plot array
par(mfrow = c(1, 1))

# Plot the structure of this decision tree model
plot(tree_model)

# Add labels to this plot
text(tree_model, cex = 0.4)

#-------------------------------------------------------------------------------

#Introduction to the par() function
# Assign the return value from the par() function to plot_pars
plot_pars <- par()

# Display the names of the par() function's list elements
names(plot_pars)

# Display the number of par() function list elements
length(plot_pars)


# Set up a 2-by-2 plot array
par(mfrow = c(2, 2))

# Plot the ChickWeight Time data as points
plot(ChickWeight$Time, type = "p")

# Add the title
title("points")

# Plot the ChickWeight Time with lines
plot(ChickWeight$Time, type = "l")

# Add the title
title("lines")

# Plot the ChickWeight Time as lines overlaid with points
plot(ChickWeight$Time, type = "o")

# Add the title
title("overlaid")

# Plot the ChickWeight Time as steps
plot(ChickWeight$Time, type = "s")

# Add the title
title("steps")

#-------------------------------------------------------------------------------

# Adding lines and points to plots
# Compute ChickWeight Time, weight
max_cwt <- max(ChickWeight$Time, ChickWeight$weight)

# Compute max_mpg
max_cwtd <- max(ChickWeight$Time, ChickWeight$weight,
               ChickWeight$Diet)

# Create plot              
plot(ChickWeight$Time, ChickWeight$weight)


# Create plot with type = "n"               
plot(ChickWeight$Time, ChickWeight$weight,
     xlim = c(0, max_cwt),
     ylim = c(0, max_cwtd), xlab = "time",
     ylab = "chick demographics")

# Add open circles to plot: this is useful for overlaying outliers 
points(ChickWeight$Time, ChickWeight$Chick, pch = 1)

# Add solid squares to plot
points(ChickWeight$Diet, ChickWeight$weight,
       pch = 15)

# Add open triangles to plot:  pch = 2

#-------------------------------------------------------------------------------
# Create the numerical vector x
x <- seq(0, 10, length = 200)

# Compute the Gaussian density for x with mean 2 and standard deviation 0.2
gauss1 <- dnorm(x, mean = 2, sd = 0.2)

# Compute the Gaussian density with mean 4 and standard deviation 0.5
gauss2 <- dnorm(x, mean = 3, sd = 0.4)

# Plot the first Gaussian density
plot(x, gauss1, type = "l", ylab = "Gaussian probability density")

# Add lines for the second Gaussian density
lines(x, gauss2, lty = 2, lwd = 3)

#-------------------------------------------------------------------------------
# Create an empty plot 
plot(ChickWeight$Time, ChickWeight$weight,
     xlab = "Time", ylab = "Weight")

# Add points with shapes determined by weight number
points(ChickWeight$Time, ChickWeight$weight, pch = ChickWeight$weight)

# Add points with shapes as characters
points(ChickWeight$Time, ChickWeight$weight, 
       pch = as.character(ChickWeight$weight))

# Create a second empty plot
plot(ChickWeight$Diet, ChickWeight$weight,
     xlab = "Diet", ylab = "Weight")

points(ChickWeight$Diet, ChickWeight$weight, 
       pch = as.character(ChickWeight$weight))

#-------------------------------------------------------------------------------

# Build a linear regression model for the ChickWeight data
x <- datasets::ChickWeight
linear_model <- lm(Time ~ weight, data = x)

# Create a Time vs. weight scatterplot from the ChickWeight data
plot(ChickWeight$Time, ChickWeight$weight)

# Use abline() to add the linear regression line
abline(linear_model, lty = 2)

#-------------------------------------------------------------------------------

# Adding explanatory text to plots as labels, titles, legends or just additional text
# Create a Time vs. weight scatterplot from the ChickWeight data
plot(ChickWeight$Time, ChickWeight$weight, pch = 15)

# Create index3, pointing to Diet 3
index3 <- which(ChickWeight$Diet == 3)

# Add text giving diet of chicks next to data points
text(x = ChickWeight$Time[index3], 
     y = ChickWeight$weight[index3],
     labels = ChickWeight$Diet[index3], adj = 0)


# Highlight diet 3 as solid circles
points(ChickWeight$Time[index3],
       ChickWeight$weight[index3],
       pch = 16)

# Add car names, offset from points, with larger bold text
text(ChickWeight$Time[index3],
     ChickWeight$weight[index3],
     ChickWeight$Diet[index3],
     adj = -0.2, cex = 1.2, font = 4)
#-------------------------------------------------------------------------------

# Rotating text with the srt argument
# Plot Time vs. weight as solid triangles
plot(ChickWeight$Time, ChickWeight$weight, pch = 17)

# Create indexB, pointing to "Before" data
indexB <- which(ChickWeight$Time == 10)

# Create indexA, pointing to "After" data
indexA <- which(ChickWeight$Time == 16)

# Add "Before" text in blue, rotated 30 degrees, 80% size
text(x = ChickWeight$Time[indexB], y = ChickWeight$weight[indexB],
     labels = "Before", col = "blue", srt = 30, cex = 0.8)

# Add "After" text in red, rotated -20 degrees, 80% size
text(x = ChickWeight$Time[indexA], y = ChickWeight$weight[indexA],
     labels = "After", col = "red", srt = -20, cex = 0.8)

#-------------------------------------------------------------------------------

# Using the legend() function
# Set up and label empty plot of Time vs. weight
plot(ChickWeight$Time, ChickWeight$weight,
     xlab = "Time",
     ylab = "weight")

# Create indexB, pointing to "Before" data
indexB <- which(ChickWeight$weight == 175)

# Create indexA, pointing to "After" data
indexA <- which(ChickWeight$weight == 185)

# Add "Before" data as solid triangles
points(ChickWeight$Time[indexB], ChickWeight$weight[indexB],
       pch = 17)

# Add "After" data as open circles
points(ChickWeight$Time[indexA], ChickWeight$weight[indexA],
       pch = 1)

# Add legend that identifies points as "175" and "185"
legend("topright", pch = c(17, 1), 
       legend = c("175", "185"))


#-------------------------------------------------------------------------------

# Create a boxplot of sugars by shelf value, without axes
boxplot(Time ~ weight, data = x,
        axes = FALSE)

# Add a default y-axis to the left of the boxplot
axis(side = 2)

# Add an x-axis below the plot, labelled 1, 2, and 3
axis(side = 1, at = c(1, 100, 200))

# Add a second x-axis above the plot
axis(side = 3, at = c(1, 50, 100),
     labels = c("low", "mid", "high"))


#-------------------------------------------------------------------------------

# Using the supsmu() function to add smooth trend curves
# Create a scatterplot of Time vs. weight
plot(ChickWeight$Time, ChickWeight$weight)

# Call supsmu() to generate a smooth trend curve, with default bass
trend1 <- supsmu(ChickWeight$Time, ChickWeight$weight)

# Add this trend curve to the plot
lines(trend1)

# Call supsmu() for a second trend curve, with bass = 10
trend2 <- supsmu(ChickWeight$Time, ChickWeight$weight,
                 bass = 10)

# Add this trend curve as a heavy, dotted line
lines(trend2, lty = 3, lwd = 2)

#-------------------------------------------------------------------------------

# Managing visual complexity
# Compute the number of plots to be displayed
ncol(ChickWeight)^2

# Plot the array of scatterplots
plot(ChickWeight)


#Deciding how many scatterplots is too many
# Construct the vector keep_vars
keep_vars <- c("Time", "weight", "Diet", "Chick")

# Use keep_vars to extract the desired subset of UScereal
df <- ChickWeight[, keep_vars]

# Set up a two-by-two plot array
par(mfrow = c(2, 2))

# Use matplot() to generate an array of two scatterplots
matplot(df$Time, df[, c("weight")], 
        xlab = "Time", ylab = "")

# Add a title
title("Two scatterplots")

# Use matplot() to generate an array of three scatterplots
matplot(df$Time, df[, c("Diet", "weight")], 
        xlab = "Time", ylab = "")

# Add a title
title("Three scatterplots")

# Use matplot() to generate an array of four scatterplots
matplot(df$Time, df[, c("Diet", "weight", "Chick")], 
        xlab = "Time", ylab = "")

# Add a title
title("Four scatterplots")

#-------------------------------------------------------------------------------

# Create mfr_table of Time frequencies
mfr_table <- table(ChickWeight$Time)

# Create the default wordcloud from this table
library(wordcloud2)
library(wordcloud)
library(RColorBrewer)
wordcloud(words = names(mfr_table), 
          freq = as.numeric(mfr_table), 
          scale = c(2, 0.25))

# Change the minimum word frequency
wordcloud(words = names(mfr_table), 
          freq = as.numeric(mfr_table), 
          scale = c(2, 0.25), 
          min.freq = 1)

# Create model_table of model frequencies
model_table <- table(ChickWeight$Time)

# Create the wordcloud of all model names with smaller scaling
wordcloud(words = names(model_table), 
          freq = as.numeric(model_table), 
          scale = c(0.75, 0.25), 
          min.freq = 1)

#-------------------------------------------------------------------------------

# Set up a two-by-two plot array
par(mfrow = c(2, 2))

# Plot y1 vs. x1 
plot(ChickWeight$Time, ChickWeight$weight,
     main = "1st dataset")

# Plot y2 vs. x2
plot(ChickWeight$Time, ChickWeight$Diet,
     main = "2nd dataset")

# Plot y3 vs. x3
plot(ChickWeight$Time, ChickWeight$Chicks,
     main = "3rd dataset")

#-------------------------------------------------------------------------------

# Set up a two-by-two plot array
par(mfrow = c(2, 2))

# Plot the raw duration data
plot(ChickWeight$Time, main = "Raw data")

# Plot the normalized histogram of the duration data
truehist(ChickWeight$Time, main = "Histogram")

# Plot the density of the duration data
plot(density(ChickWeight$Time), main = "Density")

# Construct the normal QQ-plot of the duration data
qqPlot(ChickWeight$Time, main = "QQ-plot")

#-------------------------------------------------------------------------------

# Creating plot arrays with the layout() function
# Use the matrix function to create a matrix with three rows and two columns
layoutMatrix <- matrix(
  c(
    0, 1,
    2, 0,
    0, 3
  ), 
  byrow = TRUE, 
  nrow = 3
)
# Call the layout() function to set up the plot array
layout(layoutMatrix)

# Show where the three plots will go 
layout.show(3)

# Set up the plot array
layout(layoutMatrix)

# Construct the vectors indexB and indexA
indexB <- which(ChickWeight$Time == 16)
indexA <- which(ChickWeight$Time == 20)

# Create plot 1 and add title
plot(ChickWeight$Time[indexB], ChickWeight$weight[indexB],
     ylim = c(0, 8))
title("16 only")

# Create plot 2 and add title
plot(ChickWeight$Time, ChickWeight$weight,
     ylim = c(0, 8))
title("Complete dataset")

# Create plot 3 and add title
plot(ChickWeight$Time[indexA], ChickWeight$weight[indexA],
     ylim = c(0, 8))
title("20 only")

#-------------------------------------------------------------------------------

# Creating arrays with different sized plots
# Create row1, row2, and layoutVector
row1 <- c(1, 0, 0)
row2 <- c(0, 2, 2)
layoutVector <- c(row1, rep(row2, 2))

# Convert layoutVector into layoutMatrix
layoutMatrix <- matrix(layoutVector, byrow = TRUE, nrow = 3)

# Set up the plot array
layout(layoutMatrix)

# Plot scatterplot
plot(ChickWeight$Time, ChickWeight$weight)

# Plot sunflower plot
sunflowerplot(ChickWeight$Time, ChickWeight$weight)

#-------------------------------------------------------------------------------

# Creating and saving more complex plots
# Some plot functions also return useful information
# Create a table of Cylinders frequencies
tbl <- table(ChickWeight$Time)

# Generate a horizontal barplot of these frequencies
mids <- barplot(tbl, horiz = TRUE, 
                col = "transparent",
                names.arg = "")

# Add names labels with text()
text(20, mids, names(tbl))

# Add count labels with text()
text(35, mids, as.numeric(tbl))

# Call symbols() to create the default bubbleplot
symbols(ChickWeight$Time, ChickWeight$weight,
        circles = sqrt(ChickWeight$weight))

# Repeat, with the inches argument specified
symbols(ChickWeight$Time, ChickWeight$weight,
        circles = sqrt(ChickWeight$weight),
        inches = 0.1)


# Call png() with the name of the file we want to create
png("bubbleplot.png")

# Save our file and return to our interactive session
dev.off()

# Verify that we have created the file
list.files(pattern = "png")

#-------------------------------------------------------------------------------

# Using color effectively
## consider color-blindness, printing black-white pages
## Lliinsky Steele's recommended colors (...below)

# Iliinsky and Steele color name vector
IScolors <- c("red", "green", "yellow", "blue",
              "black", "white", "pink", "cyan",
              "gray", "orange", "brown", "purple")

# Create the data for the barplot
barWidths <- c(rep(2, 6), rep(1, 6))

# Recreate the horizontal barplot with colored bars
barplot(rev(barWidths), horiz = TRUE, 
        col = rev(IScolors), axes = FALSE,
        names.arg = rev(IScolors), las = 1)

# Create the `weight` variable
cylinderLevels <- as.numeric(ChickWeight$weight)


# Create the colored bubbleplot
symbols(ChickWeight$Time, ChickWeight$weight, 
        circles = cylinderLevels, inches = 0.2, 
        bg = IScolors[cylinderLevels])


# Create a table of weight by Origin
tbl <- table(ChickWeight$Time, ChickWeight$weight)

# Create the default stacked barplot
barplot(tbl)

# Enhance this plot with color
barplot(tbl, col = IScolors)

#-------------------------------------------------------------------------------

# grid graphics 
# Load the insuranceData package
library(insuranceData)

# Use the data() function to load the Insurance data frame
data(Insurance)

# Load the tabplot package
suppressPackageStartupMessages(library(tabplot))

# Generate the default tableplot() display
tableplot(Insurance)



# Load the lattice package
library(lattice)

# Construct the formula
calories_vs_sugars_by_shelf <- calories ~ sugars | shelf

# Use xyplot() to draw the conditional scatterplot
xyplot(calories_vs_sugars_by_shelf, data = UScereal)



# Load the ggplot2 package
library(ggplot2)

# Create the basic plot (not displayed): basePlot
basePlot <- ggplot(Cars93, aes(x = Horsepower, y = MPG.city))

# Display the basic scatterplot
basePlot + 
  geom_point()

# Color the points by Cylinders value
basePlot + 
  geom_point(color = IScolors[Cars93$Cylinders])

# Make the point sizes also vary with Cylinders value
basePlot + 
  geom_point(color = IScolors[Cars93$Cylinders], 
             size = as.numeric(Cars93$Cylinders))
