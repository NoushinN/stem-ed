### DEMO for Bringing JavaScript to RStudio for Visualization
#Demo of 4 htmlwidgets: A. Time-Series Plot, B. Heatmap, C. 3D Scatterplot, D. 3D Globe  
#Lessons are adapted, created, and organized by Noushin Nabavi, PhD.


#What are htmlwidgets for R? http://www.htmlwidgets.org  
#A growing number of htmlwidget R libraries have been developed from popular JavaScript charting libraries, such as D3.js, plotly.js, Leaflet.js etc.  
#This htmlwidgets framework/interface therefore allows R users to generate interactive JavaScript data visualisations using R code, through the normal operation of loading relevant libraries and calling appropriate functions.
#These interactive plots can be displayed in RStudio, embedded in R markdown documents and Shiny web apps, and shared in standalone html files over email, dropbox etc.

#What Use-Cases do we have for htmlwidgets for R? 
#1. Data Storytelling: presenting & communicating findings   
#2. Exploratory Data Analysis (EDA) 

______________________________________________________________________________________

### A. Time-Series Plot
Produce an interactive time-series visualisation using the `dygraphs` R library. 
Objects for plotting must be in `xts` format (extensible time series).
Time-series data = Australian wine sales in no. of bottles, by wine makers, between Jan 1980 - Aug 1994.   
Using the `stl` function to perform the seasonal trend decomposition, which extracts the seasonal component, trend, component and remainder from the original data.

#### (i) Call dygraph & xts libraries

library(dygraphs)
library(xts)


#### (ii) Load Data
### In this instance the Australian Wine dataset `wineind` being used is from the `forecast` package so we load this first, then call the data.    
### (Original source: http://data.is/TSDLdemo)

install.packages('forecast', dependencies = TRUE)
library(forecast)
data("wineind")


#### (iii) Explore Data
?wineind
class(wineind)
wineind

plot(wineind) #base R plot


#### (iv) Apply Decomposition algorithm
###Apply `stl` algorithm, which divides the time series into 3 components, trend, seasonality & remainder, using Loess (a method for estimating nonlinear relationships).
### `stl` documentation: https://stat.ethz.ch/R-manual/R-devel/library/stats/html/stl.html 

stl_wine <- stl(wineind, s.window = "periodic") #s.window controls variation of seasonal component
stl_wine
plot(stl_wine) #base R plot


#### (v) Prepare decomposed data as a single xts object
#### 1. First, convert each decomposed component into a separate `ts` (time series) object, 
#### 2. Then convert into `xts` (extensible time series) object:
#### (1980, 1) is start year & unit of observations, 12 is the no. of observations per period i.e. monthly

seasonal_stl <- ts(stl_wine$time.series[,1], start = c(1980, 1), frequency=12)
seasonal_stl.xts <- as.xts(seasonal_stl)

trend_stl <- ts(stl_wine$time.series[,2], start = c(1980, 1), frequency=12)
trend_stl.xts <- as.xts(trend_stl)

random_stl <- ts(stl_wine$time.series[,3], start = c(1980, 1), frequency=12)
random_stl.xts <- as.xts(random_stl)

#### Secondly, column bind the 3 `xts` components together to create a single `xts` object for plotting (3 to 1):

wine.plot <- cbind(random_stl.xts, seasonal_stl.xts, trend_stl.xts)

#re-name columns
colnames(wine.plot) <- c("remainder", "seasonal", "trend")


#### (vi) Create Dygraph

dygraph(wine.plot) %>%
  dyOptions(stackedGraph = TRUE)


#### (vii) Customise Dygraph
#### Add Title & Range Selector & change colours:

dygraph(wine.plot, main = "Australian Wine Sales") %>%
  dyOptions(stackedGraph = TRUE, colors=RColorBrewer::brewer.pal(3, "Set1"))%>%
  dyRangeSelector()
______________________________________________________________________________________

### B. Heatmap
#### Produce a D3 heatmap using the `d3heatmap` R library.

#### (i) Call d3heatmap library

devtools::install_github("rstudio/d3heatmap")
library(d3heatmap)

#### (ii) Load Data
####Data created from a personal burger blog, in `wide` format necessary to use this library. (https://burgerite.blogspot.co.uk)    
#### Data available here: https://github.com/RLadiesCodingLondon/MayEvent-Chiin-htmlwidgets

setwd("~/STEM_Education/Data Analysis Lessons/4. JAVA WITH R") # the path to your csv file
getwd()
burger <- read.csv("burger.csv", header = TRUE, row.names = 1)

#### (iii) Explore Data
### 5 attributes, 25 burgers reviewed.

View(burger)


#### (iv) Create Heatmap
### Blue = higher score, Red = lower score

d3heatmap(burger)
______________________________________________________________________________________
  
### C. 3D Scatterplot
### Produce a 3D scatterplot using the `threejs` R library using same `burger` data.

#### (i) Call threejs library

library(threejs)

#### (ii) Create Scatterplot

scatterplot3js(burger$proportions, burger$ingredients, burger$patty, flip.y=FALSE) #flip.y to control direction of y-axis

#### (iii) Customise Scatterplot

label <- c("proportions", "patty", "ingredients") #define axis labels

scatterplot3js(burger$proportions, burger$ingredients, burger$patty, 
               axisLabels = label,
               labels=row.names(burger),
               flip.y = FALSE,
               color=rainbow(length(burger$value)),
               stroke = NULL,
               size=burger$value/5,
               renderer = "canvas")
______________________________________________________________________________________
  
### D. 3D Globe
### Produce a 3D globe, again using the `threejs` R library.

#### (i) Load Data
### Geo-location data from Google Analytics of burger blog traffic.
### Data available here: https://github.com/RLadiesCodingLondon/MayEvent-Chiin-htmlwidgets

setwd("~/STEM_Education/Data Analysis Lessons/4. JAVA WITH R") # the path to your csv file
getwd()

views <- read.csv("globejs.csv", header = TRUE, row.names = 1)


#### (ii) Explore Data
### 169 cities with cumulative blog page views >= 2 since Sep '15.

View(views)


#### (iii) Create Globe


globejs(lat = views$Lat, long = views$Long, value = views$PageViews)


#### (iv) Customise Globe


traffic <- 10000*views$PageViews/max(views$PageViews)

globejs(lat = views$Lat, long = views$Long, value = traffic,
atmosphere = TRUE,
pointsize = 0.5)

