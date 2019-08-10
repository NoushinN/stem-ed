###DEMO for Unsupervised Learning: cluster analysis###
# Lessons are adapted and organized by Noushin Nabavi, PhD. (adapted from DataCamp Courses)
## distances for hierarchical and k-means clustering

# load data for cluster analysis
mtcars
starwars<- na.omit(starwars)

# Euclidean distance between obervations when they are continuous
dist(mtcars$mpg)

# scaling when working with euclidean distance observations
mpg_s <- scale(mtcars$mpg)
dist(mpg_s)

# Measuring distance for categorical data
library(dummies)
starwars_dummy <- dummy.data.frame(starwars)

# Perform the hierarchical clustering using the complete linkage
dist_skin_color <- dist(starwars_dummy$skin_colorblue, method = "binary")

#-------------------------------------------------------------------------------

# Hierarchical clustering in R: capturing K clusters
# Calculate the assignment vector with a k of 2
skincol_cluster <- hclust(dist_skin_color, method = "complete")

clusters_k2 <- cutree(skincol_cluster, k = 2)

# Create a new data frame storing these results
starwars_k2_complete <- mutate(starwars_dummy, cluster = clusters_k2)

# Count the cluster assignments
count(starwars_k2_complete, cluster)

# Plot the positions of the players and color them using their cluster
ggplot(starwars_k2_complete, aes(x = skin_colorblue, y = skin_colorpale, color = factor(cluster))) +
  geom_point()

#-------------------------------------------------------------------------------

# Visualizing the Dendrogram
dist_hair <- dist(starwars_dummy$skin_colorblue)


# Generate hclust for complete, single & average linkage methods
hc_complete <- hclust(dist_hair, method = "complete")
hc_single <- hclust(dist_hair, method = "single")
hc_average <- hclust(dist_hair, method = "average")

# Plot & Label the 3 Dendrograms Side-by-Side
# Hint: To see these Side-by-Side run the 4 lines together as one command
par(mfrow = c(1,3))
plot(hc_complete, main = 'Complete Linkage')
plot(hc_single, main = 'Single Linkage')
plot(hc_average, main = 'Average Linkage')


#-------------------------------------------------------------------------------

# Cutting the tree
library(dendextend)

dist_hair <- dist(starwars_dummy$skin_colorblue, method = "euclidean")
hc_hair <- hclust(dist_hair, method = "complete")


# Create a dendrogram object from the hclust variable
dend_hair <- as.dendrogram(hc_hair)

# Plot the dendrogram
plot(dend_hair)

# Color branches by cluster formed from the cut at a height of 20 & plot
dend_20 <- color_branches(dend_hair, h = 20)

# Plot the dendrogram with clusters colored below height 20
plot(dend_20)


# Color branches by cluster formed from the cut at a height of 40 & plot
dend_40 <- color_branches(dend_hair, h = 40)


# Plot the dendrogram with clusters colored below height 40
plot(dend_40)


# Exploring the branches cut from the tree
# Calculate the assignment vector with a h of 20
clusters_h20 <- cutree(hc_hair, h = 20)

# Create a new data frame storing these results
lineup_h20_complete <- mutate(starwars_dummy, cluster = clusters_h20)

# Calculate the assignment vector with a h of 40
clusters_h40 <- cutree(hc_hair, h = 40)

# Create a new data frame storing these results
lineup_h40_complete <- mutate(starwars_dummy, cluster = clusters_h40)

# Plot the positions of the players and color them using their cluster for height = 20
ggplot(lineup_h20_complete, aes(x = skin_colorblue, y = skin_colorpale, color = factor(cluster))) +
  geom_point()

# Plot the positions of the players and color them using their cluster for height = 40
ggplot(lineup_h40_complete, aes(x = skin_colorblue, y = skin_colorpale, color = factor(cluster))) +
  geom_point()

#-------------------------------------------------------------------------------

# load libraries
library(here)
library(tidyverse)

# load data
customers_spend <- readRDS(here::here("Data Analysis Lessons", "3. ML", "ws_customers.rds"))

# Calculate Euclidean distance between customers
dist_customers <- dist(customers_spend)

# Generate a complete linkage analysis 
hc_customers <- hclust(dist_customers, method = "complete")

# Plot the dendrogram
plot(hc_customers)

# Create a cluster assignment vector at h = 15000
clust_customers <- cutree(hc_customers, h = 15000)

# Generate the segmented customers data frame
segment_customers <- mutate(customers_spend, cluster = clust_customers)

# Explore wholesale customer clusters
dist_customers <- dist(customers_spend)
hc_customers <- hclust(dist_customers)
clust_customers <- cutree(hc_customers, h = 15000)
segment_customers <- mutate(customers_spend, cluster = clust_customers)

# Count the number of customers that fall into each cluster
count(segment_customers, cluster)

# Color the dendrogram based on the height cutoff
dend_customers <- as.dendrogram(hc_customers)
dend_colored <- color_branches(dend_customers, h = 15000)

# Plot the colored dendrogram
plot(dend_colored)

# Calculate the mean for each category
segment_customers %>% 
  group_by(cluster) %>% 
  summarise_all(funs(mean(.)))

#-------------------------------------------------------------------------------

# Introduction to K-means

lineup <- starwars_dummy %>%
  select(height, mass)

# Build a kmeans model
model_km2 <- kmeans(lineup, centers = 2)

# Extract the cluster assignment vector from the kmeans model
clust_km2 <- model_km2$cluster

# Create a new data frame appending the cluster assignment
lineup_km2 <- mutate(lineup, cluster = clust_km2)

# Plot the positions of the players and color them using their cluster
ggplot(lineup_km2, aes(x = height, y = mass, color = factor(cluster))) +
  geom_point()


# Build a kmeans model
model_km3 <- kmeans(lineup, centers = 3)

# Extract the cluster assignment vector from the kmeans model
clust_km3 <- model_km3$cluster

# Create a new data frame appending the cluster assignment
lineup_km3 <- mutate(lineup, cluster = clust_km3)

# Plot the positions of the players and color them using their cluster
ggplot(lineup_km3, aes(x = height, y = mass, color = factor(cluster))) +
  geom_point()

#-------------------------------------------------------------------------------

# Many K's many models
# evaluating k's by eye: Elbow (Scree) plot

library(purrr)

# Use map_dbl to run many models with varying value of k (centers)
tot_withinss <- map_dbl(1:10,  function(k){
  model <- kmeans(x = lineup, centers = k)
  model$tot.withinss
})

# Generate a data frame containing both k and tot_withinss
elbow_df <- data.frame(
  k = 1:10,
  tot_withinss = tot_withinss
)


# Use map_dbl to run many models with varying value of k (centers)
tot_withinss <- map_dbl(1:10,  function(k){
  model <- kmeans(x = lineup, centers = k)
  model$tot.withinss
})

# Generate a data frame containing both k and tot_withinss
elbow_df <- data.frame(
  k = 1:10,
  tot_withinss = tot_withinss
)

# Plot the elbow plot
ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
  geom_line() +
  scale_x_continuous(breaks = 1:10)


# Silhouette analysis: Observation level performance
## 1: well matched to cluster
## 0: is on border between two clusters
## -1: poorly matched to each cluster

library(cluster)

# Generate a k-means model using the pam() function with a k = 2
pam_k2 <- pam(lineup, k = 2)

# Plot the silhouette visual for the pam_k2 model
plot(silhouette(pam_k2))

# Generate a k-means model using the pam() function with a k = 3
pam_k3 <- pam(lineup, k = 3)

# Plot the silhouette visual for the pam_k3 model
plot(silhouette(pam_k3))

#-------------------------------------------------------------------------------

# Use map_dbl to run many models with varying value of k
sil_width <- map_dbl(2:10,  function(k){
  model <- pam(x = customers_spend, k = k)
  model$silinfo$avg.width
})

# Generate a data frame containing both k and sil_width
sil_df <- data.frame(
  k = 2:10,
  sil_width = sil_width
)

# Plot the relationship between k and sil_width
ggplot(sil_df, aes(x = k, y = sil_width)) +
  geom_line() +
  scale_x_continuous(breaks = 2:10)


set.seed(42)

# Build a k-means model for the customers_spend with a k of 2
model_customers <- kmeans(customers_spend, centers = 2)

# Extract the vector of cluster assignments from the model
clust_customers <- model_customers$cluster

# Build the segment_customers data frame
segment_customers <- mutate(customers_spend, cluster = clust_customers)

# Calculate the size of each cluster
count(segment_customers, cluster)

# Calculate the mean for each category
segment_customers %>% 
  group_by(cluster) %>% 
  summarise_all(funs(mean(.)))

#-------------------------------------------------------------------------------

# time-series data analysis using occupational wage data

oes <- readRDS(here::here("Data Analysis Lessons", "3. ML", "occupation_wage.rds"))

# Calculate Euclidean distance between the occupations
dist_oes <- dist(oes, method = 'euclidean')

# Generate an average linkage analysis 
hc_oes <- hclust(dist_oes, method = 'average')

# Create a dendrogram object from the hclust variable
dend_oes <- as.dendrogram(hc_oes)

# Plot the dendrogram
plot(dend_oes)

# Color branches by cluster formed from the cut at a height of 100000
dend_colored <- color_branches(dend_oes, h = 100000)

# Plot the colored dendrogram
plot(dend_colored)

dist_oes <- dist(oes, method = 'euclidean')
hc_oes <- hclust(dist_oes, method = 'average')


# Hierarchical clustering: Preparing for exploration
library(tibble)
library(tidyr)

# Use rownames_to_column to move the rownames into a column of the data frame
df_oes <- rownames_to_column(as.data.frame(oes), var = 'occupation')

# Create a cluster assignment vector at h = 100,000
cut_oes <- cutree(hc_oes, h = 100000)

# Generate the segmented the oes data frame
clust_oes <- mutate(df_oes, cluster = cut_oes)

# Create a tidy data frame by gathering the year and values into two columns
gathered_oes <- gather(data = clust_oes, 
                       key = year, 
                       value = mean_salary, 
                       -occupation, -cluster)


# View the clustering assignments by sorting the cluster assignment vector
sort(cut_oes)

# Plot the relationship between mean_salary and year and color the lines by the assigned cluster
ggplot(gathered_oes, aes(x = year, y = mean_salary, color = factor(cluster))) + 
  geom_line(aes(group = occupation))

# Use map_dbl to run many models with varying value of k (centers)
tot_withinss <- map_dbl(1:10,  function(k){
  model <- kmeans(x = oes, centers = k)
  model$tot.withinss
})

# Generate a data frame containing both k and tot_withinss
elbow_df <- data.frame(
  k = 1:10,
  tot_withinss = tot_withinss
)

# Plot the elbow plot
ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
  geom_line() +
  scale_x_continuous(breaks = 1:10)


# Use map_dbl to run many models with varying value of k
sil_width <- map_dbl(2:10,  function(k){
  model <- pam(oes, k = k)
  model$silinfo$avg.width
})

# Generate a data frame containing both k and sil_width
sil_df <- data.frame(
  k = 2:10,
  sil_width = sil_width
)

# Plot the relationship between k and sil_width
ggplot(sil_df, aes(x = k, y = sil_width)) +
  geom_line() +
  scale_x_continuous(breaks = 2:10)

