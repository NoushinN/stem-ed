
# load dependencies

url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1903/datasets/WisconsinCancer.csv"

# Download the data: wisc.df
wisc.df <- read.csv(url)
summary(wisc.df)
dim(wisc.df)
head(wisc.df)
str(wisc.df)


# Convert the features of the data: wisc.data
wisc.data <- as.matrix(wisc.df[3:32])

# Set the row names of wisc.data
row.names(wisc.data) <- wisc.df$id

# Create diagnosis vector
diagnosis <- as.numeric(wisc.df$diagnosis == "M")

#-----------------------------------------------------------------


# Check column means and standard deviations
colMeans(wisc.data)
apply(wisc.data, 2, sd)

# check for NAs in the data
# colSums(sapply(wisc.data,is.na))
wisc.data[is.na(wisc.data)] <- 0

#-----------------------------------------------------------------
# Execute PCA, scaling if appropriate: wisc.pr
wisc.pr <- prcomp(wisc.data, scale = TRUE)

# Look at summary of results
summary(wisc.pr)


# Create a biplot of wisc.pr
biplot(wisc.pr)

# Scatter plot observations by components 1 and 2
plot(wisc.pr$x[, c(1, 2)], col = (diagnosis + 1), 
     xlab = "PC1", ylab = "PC2")

# Repeat for components 1 and 3
plot(wisc.pr$x[, c(1, 3)], col = (diagnosis + 1), 
     xlab = "PC1", ylab = "PC3")

#-----------------------------------------------------------------

# Set up 1 x 2 plotting grid
par(mfrow = c(1, 2))

# Calculate variability of each component
pr.var <- wisc.pr$sdev^2

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

# Set up 2 x 3 plotting grid
par(mfrow = c(2, 3))

# Set seed
set.seed(1)

for(i in 1:6) {
  # Run kmeans() on x with three clusters and one start
  kmc <- kmeans(wisc.data, centers = 3, nstart = 1)
  
  # Plot clusters
  plot(wisc.data, col = kmc$cluster, 
       main = kmc$tot.withinss, 
       xlab = "", ylab = "")
}

#-----------------------------------------------------------------

# Scale the wisc.data data: data.scaled
data.scaled <- scale(wisc.data)

# Calculate the (Euclidean) distances: data.dist
data.dist <- dist(data.scaled)

# Create a hierarchical clustering model: wisc.hclust
wisc.hclust <- hclust(data.dist, method = "complete")


# Cut tree so that it has 4 clusters: wisc.hclust.clusters
wisc.hclust.clusters <- cutree(wisc.hclust, k = 4)

# Compare cluster membership to actual diagnoses
table(wisc.hclust.clusters, diagnosis)


# Create a k-means model on wisc.data: wisc.km
wisc.km <- kmeans(scale(wisc.data), centers = 2, nstart = 20)

# Compare k-means to actual diagnoses
table(wisc.km$cluster, diagnosis)

# Compare k-means to hierarchical clustering
table(wisc.hclust.clusters, wisc.km$cluster)

# Visualizing and interpreting results of kmeans()
# Scatter plot of wisc.data
plot(wisc.data, col = wisc.km$cluster,
     main = "k-means with 2 clusters", 
     xlab = "", ylab = "")


# Create a hierarchical clustering model: wisc.pr.hclust
wisc.pr.hclust <- hclust(dist(wisc.pr$x[, 1:7]), method = "complete")

# Cut model into 4 clusters: wisc.pr.hclust.clusters
wisc.pr.hclust.clusters <- cutree(wisc.pr.hclust, k = 4)

# Compare to actual diagnoses
table(diagnosis, wisc.pr.hclust.clusters)

# Compare to k-means and hierarchical
table(diagnosis, wisc.hclust.clusters)
table(diagnosis, wisc.km$cluster)

#-----------------------------------------------------------------

# Selecting number of clusters
# Initialize total within sum of squares error: wss
wss <- 0

# For 1 to 15 cluster centers
for (i in 1:15) {
  kmc <- kmeans(wisc.data, centers = i, nstart = 20)
  # Save total within sum of squares to wss variable
  wss[i] <- kmc$tot.withinss
}

# Plot total within sum of squares vs. number of clusters
plot(1:15, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")

# Set k equal to the number of clusters corresponding to the elbow location
k <- 2  # 3 is probably OK, too

#-----------------------------------------------------------------

# hierarchical clustering in R using the hclust() function

# Create hierarchical clustering model: hclust.out
# (using euclidean distance)
hclust.out <- hclust(dist(wisc.data))

# Inspect the result
summary(hclust.out)

# draw a dendrogram 
plot(hclust.out)
abline(h=6, col = "red")


# Selecting number of clusters
#  cutree() is the R function that cuts a hierarchical model. 
# The h and k arguments to cutree() allow you to cut the tree based on a certain height h or a certain number of clusters k.

# Cut by height
cutree(hclust.out, h = 7)

# Cut by number of clusters
cutree(hclust.out, k = 3)

# Clustering linkage and practical matters
# how is distance between clusters determined? 1) complete, 2) single, 3) average, 4) centroid methods
## complete uses largest of similarities as distance between clusters, single uses smallest of similarities
## average uses average of similarities, and centroid uses similarity between two centroids
# scaling is another consideration one needs to make for clustering

# Cluster using complete linkage: hclust.complete
hclust.complete <- hclust(dist(wisc.data), method = "complete")

# Cluster using average linkage: hclust.average
hclust.average <- hclust(dist(wisc.data), method = "average")

# Cluster using single linkage: hclust.single
hclust.single <- hclust(dist(wisc.data), method = "single")

# Plot dendrogram of hclust.complete
plot(hclust.complete, main = "Complete")

# Plot dendrogram of hclust.average
plot(hclust.average, main = "Average")

# Plot dendrogram of hclust.single
plot(hclust.single, main = "Single")

# scaling the features if they have different distributions
# View column means
colMeans(wisc.data)

# View column standard deviations
apply(wisc.data, 2, sd)

# Scale the data
dat.scaled <- scale(wisc.data) #na.rm = TRUE 


# Create hierarchical clustering model:
hclust.dat <- hclust(dist(dat.scaled), method = "complete")

# Comparing kmeans() and hclust()
# Apply cutree() to hclust.pokemon: cut.pokemon
cut.dat <- cutree(hclust.dat, k = 3)

# Compare methods
table(kmc$cluster, cut.dat)

#-----------------------------------------------------------------

# Dimensionality Reduction using PCA (find structures in features and aid in visualization)
# Perform scaled PCA: pr.out
pr.out <- prcomp(wisc.data, scale = TRUE, na.rm = TRUE, center = TRUE)

# Inspect model output
summary(pr.out)

## the biplot() function plots both the principal components loadings and the mapping of the observations to their first two principal component values
## The second common plot type for understanding PCA models is a scree plot. 
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


# PCA model with scaling: pr.with.scaling
pr.with.scaling <- prcomp(wisc.data, scale = TRUE)

# PCA model without scaling: pr.without.scaling
pr.without.scaling <- prcomp(wisc.data, scale = FALSE)

# Create biplots of both for comparison
biplot(pr.with.scaling)
biplot(pr.without.scaling)




