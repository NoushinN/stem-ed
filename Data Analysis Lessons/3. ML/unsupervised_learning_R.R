###DEMO for Unsupervised learning in R###
# Lessons are adapted and organized by Noushin Nabavi, PhD. (adapted from DataCamp Lessons for regression)

# Unsupervised learning - K-means Clustering
# load data
cars <- mtcars %>%
  select(mpg, cyl)


# parallel slopes models = numeric and categorical variables for modeling
# Create the k-means model: km.out
km.out <- kmeans(cars, centers = 3, nstart = 20)

# Inspect the result
summary(km.out)

# Print the cluster membership component of the model
km.out$cluster

# Print the km.out object
km.out

# Scatter plot of mtcars
plot(cars, col = km.out$cluster,
     main = "k-means with 3 clusters", 
     xlab = "", ylab = "")

# Set up 2 x 3 plotting grid
par(mfrow = c(2, 3))

# Set seed
set.seed(1)

for(i in 1:6) {
  # Run kmeans() on x with three clusters and one start
  km.out <- kmeans(cars, centers = 3, nstart = 1)
  
  # Plot clusters
  plot(cars, col = km.out$cluster, 
       main = km.out$tot.withinss, 
       xlab = "", ylab = "")
}

# Initialize total within sum of squares error: wss
wss <- 0

# For 1 to 15 cluster centers
for (i in 1:15) {
  km.out <- kmeans(cars, centers = i, nstart = 20)
  # Save total within sum of squares to wss variable
  wss[i] <- km.out$tot.withinss
}

# Plot total within sum of squares vs. number of clusters
plot(1:15, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")

# Set k equal to the number of clusters corresponding to the elbow location
k <- 2  # 3 is probably OK, too

#-----------------------------------------------------------------

# Create hierarchical clustering model: hclust.out
hclust.out <- hclust(dist(cars))

# Inspect the result
summary(hclust.out)

# Cut by height
cutree(hclust.out, h = 7)

# Cut by number of clusters
cutree(hclust.out, k = 3)

# Cluster using complete linkage: hclust.complete
hclust.complete <- hclust(dist(cars), method = "complete")

# Cluster using average linkage: hclust.average
hclust.average <- hclust(dist(cars), method = "average")

# Cluster using single linkage: hclust.single
hclust.single <- hclust(dist(cars), method = "single")

# Plot dendrogram of hclust.complete
plot(hclust.complete, main = "Complete")

# Plot dendrogram of hclust.average
plot(hclust.average, main = "Average")

# Plot dendrogram of hclust.single
plot(hclust.single, main = "Single")


# View column means
colMeans(cars)

# View column standard deviations
apply(cars, 2, sd)

# Scale the data
cars.scaled <- scale(cars)

# Create hierarchical clustering model: hclust.pokemon
hclust.cars <- hclust(dist(cars.scaled), method = "complete")

# Apply cutree() to hclust.pokemon: cut.pokemon
cut.cars <- cutree(hclust.cars, k = 3)

# Compare methods
table(hclust.out$cluster, cut.cars)

#-----------------------------------------------------------------

# PCA clustering
# Perform scaled PCA: pr.out
pr.out <- prcomp(cars, scale = TRUE)

# Inspect model output
summary(pr.out)

# Variability of each principal component: pr.var
pr.var <- pr.out$sdev^2

# Variance explained by each principal component: pve
pve <- pr.var / sum(pr.var)

# Plot variance explained for each principal component
plot(pve, xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Plot cumulative proportion of variance explained
plot(cumsum(pve), xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")


# Mean of each variable
colMeans(cars)

# Standard deviation of each variable
apply(cars, 2, sd)

# PCA model with scaling: pr.with.scaling
pr.with.scaling <- prcomp(cars, scale = TRUE)

# PCA model without scaling: pr.without.scaling
pr.without.scaling <- prcomp(cars, scale = FALSE)

# Create biplots of both for comparison
biplot(pr.with.scaling)
biplot(pr.without.scaling)
