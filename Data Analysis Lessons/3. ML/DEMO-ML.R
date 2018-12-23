###DEMO for ML###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

## Machine Learning technique - Clustering

### Intro + Steps 
### Clustering is a classic Machine Learning (ML) problem 
### The task is to cluster your data points into groups based on similar properties. 
### Common business applications are Market/Customer/Product Segmentation. 
### If data is unlabeled, ML is classified as  *'Unsupervised'* problem (vs *'Supervised'*)
### That is,  there are no indication of a target classification. 
### This ML algorithm is used to look for patterns and discover/uncover structure within the data.
### There are several classes of clustering methods including k-means and PAM Partioning Around Medoids
### Both of above require upfront specification of the number of clusters in the final solution. 
### In this exercise, we'll use the Hierarchical Agglomerative Clustering method, which outputs a complete set of solutions (from a single cluster solution to n cluster solution (n = no. of data points)).
### For all methods the process of grouping the data points into clusters is based on a numerical measure of *'distance'* between points, to quantify dis/similarity. In this exercise we calculate Euclidean Distance measures between pairs of data points (based on the square root of the sum of squares of the differences between corresponding elements of two vectors).

###  What: Cluster a set of 32 cars models based on road test performance stats (the pre-loaded mtcars data set)  
###  How: Hierarchical Agglomerative Clustering algorithm    
###  Output: Dendrogram data viz, membership classification  

###  R documentation for the `hclust` Hierarchical Agglomerative Clustering function that we're using: https://stat.ethz.ch/R-manual/R-patched/library/stats/html/hclust.html  

### Steps of ML
#### (i)    Load & Explore data  
#### (ii)   Clean data  
#### (iii)  Standardise data  
#### (iv)   Calculate Euclidean Distance Matrix  
#### (v)    Calculate Clusters  
#### (vi)   Make Dendrogram data viz  
#### (vii)  Define appropriate no. of Clusters  
#### (viii) Charcterise each Cluster by their variable statistics  
#### (ix)   Create final Cluster Membership data  

  
#### **NOTE:** notice how we don't need to install & load any packages for this exercise? 
#### All the functions we're using here are base R!

  
#### (i) Load & Explore data: Also note the critera on which we're clustering the cars:

data(mtcars)
View(mtcars)
?mtcars

#### (ii) Clean data  
#### Take out the binary variables, "vs" and "am" by removing a vector referencing their specific column positions from the original dataset, i.e. column 8 and 9:

mtcars[,8:9]
mtcars1 <- mtcars[, -c(8, 9)]

#Eyeball cleaned data
View(mtcars1)

#### (iii) Standardise data: A common data pre-processing step to give the same importance to all the variables
#### Need to normalise the data so that each variable/column has a mean of 0, and a comparable range of values:

#Calculate the column-wise medians
medians <- apply(mtcars1, 2, median)

#Calculate the column-wise mean average standard deviation (mads)
mads <- apply(mtcars1, 2, mad)
View(mads)

#Update the mtcars1 data set by scaling each column by it's median and mad
mtcars2 <- scale(mtcars1, center = medians, scale = mads)
View(mtcars2)
print(mtcars2, digits=2)

#Eyeball normalised data
print(head(mtcars2, n = 5), digits=2)

#### (iv) Calculate Euclidean Distance Matrix  
#### Calculate a matrix of dis/similarity measures between each pair of cars using the `dist` function:
#### The 'method' argument specifies the distance measure to be used from number of options - here "euclidean" is chosen

mtcars3 <- dist(mtcars2, method = "euclidean")
print(mtcars3, digits=2)

#### (v) Calculate Clusters  
#### Once the Euclidean Distances between every pair of cars have been calculated, we call the `hclust` function
#### i.e. this is where we apply the algorithm to cluster the 32 cars based on their dis/similarity:
#### Default agglomeration method is Complete Linkage 
#### (distance between clusters are based on largest existing pairwise dissimilarity)
#### Specifying Ward's minimum variance method here which minimises the total within-cluster variance (see hclust documentation)

clusters <- hclust(mtcars3, method = "ward.D2")

#### (vi) Make Dendrogram data viz: You can plot as-is:

plot(clusters)

#### Or plot where the labels are bottom-aligned:

plot(clusters, hang = -1)

#### (vii) Define appropriate no. of Clusters  
#### Choosing a 6 cluster solution here, and visualising this on the dendrogram:
  
rect.hclust(clusters, 6)

#### Use `cutree` function to cut the tree into the 6 groups of data (clusters):
clusters.6 <- cutree(clusters, 6)

#### Use `table` function to build a contingency table of the counts for each levels of the new clusters.6 factor variable, i.e. how many cars are in each cluster:

table(clusters.6)

#### (viii) Charcterise each Cluster by their variable statistics  
#### Calculate & Interpret variable stats in their standardised scale:
#### Use aggregate command to compute chosen summary statistics (mean) which is then applied to all subsets (the 6 clusters) of the scaled mtcars data
means.scaled <- aggregate(mtcars2, list(clusters.6), mean)

#### Bring up info, formatted to 2 d.p
options(digits = 2)
means.scaled

#### Calculate & Interpret variable stats in their original scale:
#### Use aggregate command to compute chosen summary statistics (mean) which is then applied to all subsets (the 6 clusters) of the un-scaled mtcars data
means.orig <- aggregate(mtcars1, list(clusters.6), mean)

#### Bring up info
means.orig

#### (ix) Create final Cluster Membership data  
####  Bind the new 6 cluster factor variable to the original (cleaned) mtcars data to create an additional column indicating the computed Cluster Membership of each car:

mtcars.membership <- cbind(clusters.6, mtcars1)

#### Display the resulting data set:

mtcars.membership
mtcars.membership[1:6,1:10]


### DENODROGRAM PREVIEW: 
### The tree construct visualising the complete set of clustering solutions from single cluster (root) to 32 cluster (leaves), and a manually chosen 6 cluster solution:

data(mtcars)
mtcars.clean <- mtcars[, -c(8,9)]

medians <- apply(mtcars.clean, 2, median)
mads <- apply(mtcars.clean, 2, mad)

mtcars.standardised <- scale(mtcars.clean, center = medians, scale = mads)
mtcars.stan.dist <- dist(mtcars.standardised, method = "euclidean")
mtcars.clust <- hclust(mtcars.stan.dist, method = "ward.D2")

plot(mtcars.clust, hang = -1)
rect.hclust(mtcars.clust, 6)


#### Extensions:
#### Try one of the many packages available to created enhanced dendrogram visualisations. Here we'll create coloured leaves:

install.packages("sparcl")

#### dendrogram extension library

library(sparcl)
ColorDendrogram(clusters, y = clusters.6, labels = names(clusters.6), branchlength = 5)



