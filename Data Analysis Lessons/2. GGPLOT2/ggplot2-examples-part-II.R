###DEMO for visualizing spatial data in R using ggplot2###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for cleaning data into R)

# working with spatial data
## line data, point data, polygon, raster
# There are two steps to adding a map to a ggplot2 plot with ggmap:
##Download a map using get_map()
##Display the map using ggmap()

library(ggmap)
library(sp)

victoria <- c(lon = -123.329773, lat = 48.407326)

# Get map at zoom level 5: map_5
map_5 <- get_map(victoria, zoom = 5, scale = 1)


# Plot map at zoom level 5
ggmap(map_5)

# Get map at zoom level 13: corvallis_map
victoria_map <- get_map(victoria, zoom = 13, scale = 1)

# another way to get map
victoria_map <- get_map(victoria, zoom = 13, 
                        maptype = "terrain",
                        source = "google")
?get_map # for other options

# Plot map at zoom level 13
ggmap(victoria)
?ggmap? # for other options

# Look at head() of sales
head(sales)

# Swap out call to ggplot() with call to ggmap()
ggmap(victoria_map) +
  geom_point(aes(lon, lat), data = sales)

# additional Insight through aesthetics
# Map color to year_built
ggmap(victoria_map) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Map size to bedrooms
ggmap(victoria_map) +
  geom_point(aes(lon, lat, size = bedrooms), data = sales)

# Map color to price / finished_squarefeet
ggmap(victoria_map) +
  geom_point(
    aes(lon, lat, color = price / finished_squarefeet), 
    data = sales
  )



# other different maps
victoria <- c(lon = -123.329773, lat = 48.407326)

# Add a maptype argument to get a satellite map
victoria_map_sat <- get_map(victoria, zoom = 13, 
                             maptype = "satellite")

# Edit to get display satellite map
ggmap(victoria_map_sat) +
  geom_point(aes(lon, lat, color = year_built), data = sales)


# Leveraging ggplot2's strengths
# Use base_layer argument to ggmap() to specify data and x, y mappings
# Use base_layer argument to ggmap() and add facet_wrap()
ggmap(victoria_map_sat, base_layer = ggplot(sales, aes(lon, lat))) +
  geom_point(aes(color = class)) +
  facet_wrap(~ class)


