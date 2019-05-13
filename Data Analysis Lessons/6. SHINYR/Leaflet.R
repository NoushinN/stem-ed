###DEMO for using Leaflet Visualization###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# Load the leaflet library
library(leaflet)
library(tidyverse)
library(htmltools)
library(leaflet.extras)

#------------------------------------------------------------------------------

# Create a leaflet map with default map tile using addTiles()
leaflet() %>%
  addTiles()

# Print the providers list included in the leaflet library
providers

# Print only the names of the map tiles in the providers list 
names(providers)

# Use str_detect() to determine if the name of each provider tile contains the string "CartoDB"
str_detect(names(providers), "CartoDB")

# Use str_detect() to print only the provider tile names that include the string "CartoDB"
names(providers)[str_detect(names(providers), "CartoDB")]

# Change addTiles() to addProviderTiles() and set the provider argument to "CartoDB"
leaflet() %>% 
  addProviderTiles(provider = "CartoDB")

# Create a leaflet map that uses the Esri provider tile
leaflet() %>%
  addProviderTiles("Esri")


# Create a leaflet map that uses the CartoDB.PositronNoLabels provider tile
leaflet() %>%
  addProviderTiles("CartoDB.PositronNoLabels")


# Map with CartoDB tile centered on victoria with zoom of 6
leaflet()  %>% 
  addProviderTiles("CartoDB")  %>% 
  setView(lng = -123.365644, lat = 48.4284, zoom = 6)

#------------------------------------------------------------------------------

# Map with narrower views
leaflet(options = leafletOptions(
  # Set minZoom and dragging 
  minZoom = 12, dragging = TRUE)) %>% 
  addProviderTiles("CartoDB") %>% 
  
  # Set default zoom level
  setView(lng = -123.365644, lat = 48.4284, zoom = 14) %>% 
  
  # Set max bounds of map
  setMaxBounds(lng1 = -123.365644 + .05,
               lat1 = 48.4284 + .05,
               lng2 = -123.365644 - .05,
               lat2 = 48.4284 - .05)

# Plot victoria 
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = -123.365644, lat = 48.4284)


# Plot victoria with zoom of 12    
leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addMarkers(lng = -123.365644, lat = 48.4284)  %>%
  setView(lng = -123.365644, lat = 48.4284, zoom = 12)


# Store leaflet hq map in an object called map
map <- leaflet() %>%
  addProviderTiles("CartoDB") %>%
  # Use victoria for popups
  addMarkers(lng = -123.365644, lat = 48.4284)

# Center the view of map on the Belgium HQ with a zoom of 5
map_zoom <- map %>%
  setView(lat = 48.4284, lng = -123.365644,
          zoom = 5)

# Print map_zoom
map_zoom

#------------------------------------------------------------------------------

# Plot victoria with zoom of 12 with circle markers    
leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addCircleMarkers(lng = -123.365644, lat = 48.4284, radius = 2, color = "red")  %>%
  setView(lng = -123.365644, lat = 48.4284, zoom = 12)

# Add circle markers with popups for name
# Plot victoria with zoom of 12 with circle markers    
leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addCircleMarkers(lng = -123.365644, lat = 48.4284, radius = 2, color = "red", popup = "Victoria")  %>%
  setView(lng = -123.365644, lat = 48.4284, zoom = 12)


# Add circle markers with popups for name - plus spacers - bold first victoria 
# Plot victoria with zoom of 12 with circle markers    
leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addCircleMarkers(lng = -123.365644, lat = 48.4284, radius = 2, color = "red", popup = paste0("<b>", "Victoria","</b>", "<br/>", "victoria"))  %>%
  setView(lng = -123.365644, lat = 48.4284, zoom = 12)

# Add circle markers with popups for name - addint province 
# Plot victoria with zoom of 12 with circle markers    
leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addCircleMarkers(lng = -123.365644, lat = 48.4284, radius = 2, color = "red", popup = paste0("Victoria","<br/>", " (BC)"))  %>%
  setView(lng = -123.365644, lat = 48.4284, zoom = 12)

## Can also add a color palette if using a database
## e.g. pal <- colorFactor(palette = c("blue", "red", "green"), levels = c("Public", "Private", "For-Profit"))
## map %>% addCircleMarkers(color = ~pal(sector_label))


# Add a legend that displays the colors used in pal
pal <- colorNumeric(palette = "RdBu", domain = c(25:50))

leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addCircleMarkers(lng = -123.365644, lat = 48.4284, radius = 2, color = "red", popup = paste0("Victoria","<br/>", " (BC)"))  %>%
  setView(lng = -123.365644, lat = 48.4284, zoom = 12) %>%
  addLegend(values = c(25:50), pal = pal, opacity = 0.5, title = "codes", position = "topright")

#------------------------------------------------------------------------------

# Change up the Base group
leaflet() %>% 
  # Add the OSM, CartoDB and Esri tiles
  addTiles(group = "OSM") %>% 
  addProviderTiles("CartoDB", group = "CartoDB") %>% 
  addProviderTiles("Esri", group = "Esri") %>% 
  # Use addLayersControl to allow users to toggle between basemaps
  addLayersControl(baseGroups = c("OSM", "CartoDB", "Esri"), position = "topleft")

#------------------------------------------------------------------------------

# The Leaflet Extras Package
library(leaflet.extras)

leaflet() %>%
  addTiles() %>% 
  addSearchOSM() %>%
  addReverseSearchOSM()

#------------------------------------------------------------------------------

# Clean the map space - make room for new exercises!
map_clear <- map %>%
  clearMarkers() %>% 
  clearBounds()

map_clear

#------------------------------------------------------------------------------

# Plotting polygons
## Spatial Data
library(rgdal)
if (!file.exists("./polygons/ne_50m_admin_1_states_provinces_lakes/ne_50m_admin_1_states_provinces_lakes.dbf")){
  download.file(file.path('http://www.naturalearthdata.com/http/',
                          'www.naturalearthdata.com/download/50m/cultural',
                          'ne_50m_admin_1_states_provinces_lakes.zip'),
                f <- tempfile())
  unzip(f, exdir = "./polygons/ne_50m_admin_1_states_provinces_lakes")
  rm(f)
}

# Read the .shp files
provinces <- readOGR("./polygons/ne_50m_admin_1_states_provinces_lakes", 'ne_50m_admin_1_states_provinces_lakes', encoding='UTF-8')

# explore the provinces data
summary(provinces)
class(provinces)
slotNames(provinces)

# Glimpse the data slot of provinces
glimpse(provinces@data)

# Print the class of the data slot of provinces
class(provinces@data)

# Print name_tr
provinces@data$name_tr

# plotting polygon 1

provinces[[1]] %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons()

provinces@data <- provinces@data %>%
  left_join(data, by = "xy")

#------------------------------------------------------------------------------

## Mapping Polygons

# map the polygons in provinces
m <- provinces %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons()

saveWidget(m, file = "mymap.html")
