###DEMO for Basic R, set-up, and visualizations###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# A. RStudio - Basics  

## (i) Open & Save new R Script demonstration

## (ii) short-hand keys
### **Windows**: Alt+Enter or highlight code and click 'Run'  
### **Mac**: cmd+Enter or highlight code and click 'Run'   

## (iii) Creating R Objects
object <- 3 + 5 

#Call object
object

_____________________________________________________________________________

# B. Pre-loaded data - Examine  

## The default installation of R comes with several data sets. 
## Bring up the listing of pre-loaded data sets:

data()


## Some of the more popular data sets used in online demos & tutorials are:
data("iris")
data("mtcars")
data("longley")
data("USArrests")
data("VADeaths")

## Here are some useful R commands for top-line exploration of a data set 
## (insert the name of the dataset in the brackets, e.g. `class(iris`)):

class()
dim()
str()
summary()
head()
tail()
View()

## Query a dataset by ?<name of data set> 

?iris
_____________________________________________________________________________

# C. Make your own data - Geo Chart  

## (i) create a data set by hand
## e.g. popularity of cities as holiday destinations

Country <-  c("France", "Argentina", "USA", "China", "Russia", "Canada", "Romania")
Popularity <- c(20, 25, 22, 15, 5, 10, 20)
geodata <- data.frame(Country, Popularity)

View(geodata)
class(geodata)


## (ii) Install the "googleVis" package - Download "googleVis" package from CRAN 
## This can be done via install.packages:

install.packages("googleVis")

## check whether package has installed via RStudio "Packages" tab. 

## (iii) Load "googleVis" to use in current session  

library(googleVis)
suppressPackageStartupMessages(library(googleVis))

## (iv) Use the "gvisGeoChart" function from the "googleVis" package. 
## Bring up help on the function:

?gvisGeoChart
args(gvisGeoChart)


## __Key arguments:__  
##__data__ = a data.frame, where at least one column has location name.  
##__locationvar__ = column name of data with the geo locations to be analysed.  
##__colorvar__ = column name of data with the optional numeric column used to assign a color to this marker.  

## (v) Create Geo Chart from 'geodata' data frame object:

geochart <- gvisGeoChart(geodata, 
                         locationvar = "Country",
                         colorvar = "Popularity")
plot(geochart)

_____________________________________________________________________________
# D. ggplot2 - Set-up

## Credits: Extremely popular & widely used Graphic System in R created by Hadley Wickham. 
## Credits: An implementation of the Grammar of Graphics concepts developed by Leland Wilkinson.

### Other key Graphic Systems in R are the base graphics package and lattice package.

## (i) Install the "ggplot2" package: Download ggplot2 package from CRAN 
## via install.packages, and check package has installed via RStudio "Packages" tab. 

install.packages("ggplot2")

## (ii) Load "ggplot2"" to use in current session  

library(ggplot2)

## (iii) ggplot2 Documentation & example data sets  

?ggplot

## (iv) Load and examine ggplot2 example data sets:

data("economics", "diamonds")
View(economics)
View(diamonds)

class()
dim()
str()
summary()
head()
tail()
View()
_____________________________________________________________________________

# E. ggplot2 - Data Viz 

## __Key Plotting Layers__   
## * __data__ = a data.frame  
## * __aes__ = short for aesthetics, defines the data to be mapped to the aesthetics of the plot    
## * __geom_xxx__ = short for geometric objects, defines the type of plot produced  

## (i) Line Chart: Plot a line graph of population against time:

line.graph <- ggplot(data = economics, aes(x = date, y = pop)) + geom_line()
plot(line.graph)

## (ii) Bar Chart: Plot a bar chart showing the count of diamonds by cut:

bar.chart <- ggplot(data = diamonds, aes(x = cut)) + geom_bar()
plot(bar.chart)

## (iii) Box Plot: Plot a box plot showing the distribution of prices for each diamond cut:

box.plot <- ggplot(data = diamonds, aes(x = cut, y = price)) + geom_boxplot()
plot(box.plot)

## (iv) Scatterplot: Make a scatterplot showing the relationship between two variables, price and carat:

scatterplot <- ggplot(data = diamonds, aes(x = price, y = carat)) + geom_point()
plot(scatterplot)


#### Extensions to ggplot2
  
#### Add Labels by adding these elements to your plot:
#### + ggtitle("insert title here")
#### + xlab("insert x-axis label here")
#### + ylab("insert y-axis label here")

#### Change colours:
#### R automatically comes with a base colour palette, "R colors". 
#### There are 657 pre-made colours with given names which can be accessed by the `colors()` command. 
#### This is a useful doc for colour swatches: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf  
#### Try changing the colour (outline) or fill (solid area) of the geom_xxx, e.g.

scatterplot <- ggplot(data = diamonds, aes(x = price, y = carat)) + geom_point(colour = "tomato")
plot(scatterplot)

bar.chart <- ggplot(data = diamonds, aes(x = cut)) + geom_bar(colour = "slategrey", fill = "peachpuff")
plot(bar.chart)


box.plot <- ggplot(data = diamonds, aes(x = cut, y = price)) + geom_boxplot(colour = "navy", fill = "oldlace")
plot(box.plot)


#### Subset existing plots with colour demarcation
#### e.g. Sub-setting your plot by a factor variable by specifying an aes data mapping in the geom_xxx.   

bar.chart.subset <- ggplot(data = diamonds, aes(x = cut)) + geom_bar(aes(fill = clarity))
plot(bar.chart.subset)


#### Another e.g. for scatterplots
#### Note: calling the enhanced scatterplot below takes a little while due to the volume of data

scatterplot.subset <- ggplot(data = diamonds, aes(x = price, y = carat)) + geom_point(aes(colour = cut))
plot(scatterplot.subset)

  
#### Faceting:  Facets display subsets of the data in different panels.  
#### Can reproduce the diamonds bar chart but into 7 panels, 
#### each can represent the chart for 1 of the 7 diamond "color" (D-J):

bar.chart.facet <- ggplot(data = diamonds, aes(x = cut)) + geom_bar() + facet_grid(color~.)

#### Additionally, add an `aes(fill = color)` inside the geom_bar for extra demarcation:

bar.chart.facet <- ggplot(data = diamonds, aes(x = cut)) + geom_bar(aes(fill = color)) + facet_grid(color~.)
plot(bar.chart.facet)

