library(readr)
df <- read_csv("LCZ_Shuffled_Random_Dropped.csv")
library(magrittr)

# LCZ16_01 - Local climate zone
# LCZ16_02 - Percent of pixels Compact High-Rise or Compact Mid-Rise
# LCZ16_03 - Percent of pixels Open High-Rise or Open Mid-Rise
# LCZ16_04 - Percent of pixels Open Low-Rise
# LCZ16_05 - Percent of pixels Large Low-Rise, Heavy Industry, Bare Rock or Paved, or Bare Soil or Sand
# LCZ16_06 - Percent of pixels Sparsely Built, Dense Trees, Scattered Trees, or Low Plants
# LCZ16_07 - Water
# LCZ16_08 - Unknown
# LCZ16_09 - Category with highest percentage pixels
# LCZ16_10 - Category with highest percentage pixels, suffixed with _S if less than 50%
# LCZ16_11 - Influence. Category with second highest percentage, unless the first category has more than 75%, then it is "Majority"

# Strip NA rows
df <- df[complete.cases(df),]

# kmeans, and many machine learning tools will not automatically convert
# categorical data into one-hot encoding.
mat.numeric <- model.matrix(~ . - 1, df[2:11])

# Remember that k-means algorithm isn't deterministic, so set the seed!
set.seed(1) 
kmeans.15 <- kmeans(mat.numeric, 15)

# Poke around the kmeans cluster object and look for interesting components.
kmeans.15
str(kmeans.15)
barplot(kmeans.15$withinss)
barplot(kmeans.15$size)

# A lot of time can be spent looking at kmeans centers when you don't have
# anything else to help you understand what the clusters are.
round(kmeans.15$centers, 2)

library(ggplot2)
library(reshape2)
melted.centers <- melt(kmeans.15$centers, varnames = c("cluster", "LCZ"))

ggplot(melted.centers, aes(x = LCZ, y = cluster, fill = value)) + 
  geom_tile(colour = "white") +
  scale_fill_gradient(low = "white", high = "steelblue")
# Plotting things on different scales can be useless.

# Take a look at the column names to find the pattern.
unique(melted.centers$LCZ)

# Find the easiest pattern and "set difference" the rest
continuous.cols <- paste0("LCZ16_0", 2:8)
melted.centers$var.type <- 
  ifelse(melted.centers$LCZ %in%  continuous.cols, "continuous", "binary")

# This still puts it on the same scale.
ggplot(melted.centers, aes(x = as.character(LCZ), y = cluster, fill = value)) + 
  geom_tile(colour = "white") +
  facet_grid(~var.type) +
  scale_fill_gradient(low = "white", high = "steelblue")

# Plot them separately
library(dplyr)
ggplot(melted.centers %>% filter(var.type == "binary"), 
       aes(y = as.character(LCZ), x = cluster, fill = value)) + 
  geom_tile(colour = "white") +
  facet_wrap(~var.type, scales = "free") +
  scale_fill_gradient(low = "white", high = "steelblue")


ggplot(melted.centers %>% filter(var.type == "continuous"), 
       aes(y = as.character(LCZ), x = cluster, fill = value)) + 
  geom_tile(colour = "white") +
  facet_wrap(~var.type, scales = "free") +
  scale_fill_gradient(low = "white", high = "steelblue")


# We don't normally have a "target"/"predicted" variable, but since we have a
# "human-clustered" result in this case, let's take a look.

# Plot the kmeans as columns and the actual LCZ as rows.
table(df$LCZ16_01, kmeans.15$cluster) %>% prop.table(margin = 2) %>% round(2)
# The *columns* sum to one.

# A little tricky to parse. The real numbers don't matter so let's use colours.
vals <- 
  table(LCZ = df$LCZ16_01, cluster = kmeans.15$cluster) %>% 
  prop.table(margin = 2)
vals.df <- data.frame(vals)

ggplot(vals.df, aes(y = LCZ, x = cluster, fill = Freq)) + 
  geom_tile(colour = "white") +
  scale_fill_gradient(low = "white", high = "steelblue")

# Doesn't give us the full picture because Open Low-Rise is almost half the
# data.
table(df$LCZ16_01) %>% prop.table %>% round(2)

# Make the rows sum to one.
vals <- 
  table(LCZ = df$LCZ16_01, cluster = kmeans.15$cluster) %>% 
  prop.table(margin = 1)
vals.df <- data.frame(vals)

ggplot(vals.df, aes(y = LCZ, x = cluster, fill = Freq)) + 
  geom_tile(colour = "white") +
  scale_fill_gradient(low = "white", high = "steelblue")

# It doesn't really match, but should we expect it to match?

# Let's try some hierarchical agglomerative clustering.
# Typically, we would use stats:::hclust, but there is a problem.

# The hclust package takes an object from dist
# Take a look at the help page.
?stats::hclust

# dist basically calculates the distance from each data row to every other row
?dist

# Sounds great, but.. just how many comparisons would that be?
n <- nrow(df)
# 690,803 + 690,802 + .. + 1
sum(1:(n-1))
# So let's imagine that each comparison took 1 microsecond (1 millionth of a second)
num.comparisons <- sum(1:(n-1))

(num.comparisons / 1e6) / 60 / 60 # minutes... hours 
# 66 hours.

# Even if you waited around for that to finish, (or bought a fancier computer),
# just storing those would be a problem.

# Assuming each comparison would be 8 bytes 
num.comparisons * 8  / 1024 / 1024 / 1024 # kilo.. mega.. gigabyte
# 1778 GB of data in memory!

# Which is exactly why this doesn't work.
dist(mat.numeric[,1:7])

# But if you can't run dist, then you can't use stats::hclust
# The problem isn't R, the problem is the algorithm used in the software.

# If you're clever, you don't *have* to calculate every possible comparison.
# (This is the heart of classic computer science.)
# https://en.wikipedia.org/wiki/Nearest-neighbor_chain_algorithm


# Fortunately, it has been implemented by somebody with quite a nice analysis of
# the complexity and comparison to other packages.
library(fastcluster)

# fastcluster has a nice website to go along with it:
# http://danifold.net/fastcluster.html

# So the result is that hclust.vector is a much more efficient version
# hclust(dist(x))
# But it isn't magic; always test when you have larger datasets.
rownames(mat.numeric) <- df$LCZ16_01
system.time(h <- hclust.vector(mat.numeric[1:1000, 1:7]))
system.time(h <- hclust.vector(mat.numeric[1:10000, 1:7]))
# Hm, this won't scale linearly. Let's randomly sample 1000 so it will be easier to work with.
set.seed(1)
samples <- sample.int(nrow(mat.numeric), 100)
mat.sample <- mat.numeric[samples, ]

h <- hclust.vector(mat.sample, method = "single")
plot(h, labels = FALSE)
?plot.hclust

h <- hclust.vector(mat.sample, method = "ward")
plot(h, labels = FALSE)

# Phylogenetic tree library
library(ape)
colors <- topo.colors(15)
cols <- colors[match(rownames(mat.sample), unique(rownames(mat.sample)))]
plot(as.phylo(h), show.tip.label = TRUE, tip.color = cols, cex = 0.6)

plot(as.phylo(h), show.tip.label = TRUE, tip.color = cols, cex = 0.6, type = "fan")

# DBSCAN
# What is DBSCAN?
# https://en.wikipedia.org/wiki/DBSCAN
library(dbscan)
dbscan.test <- dbscan(mat.numeric[1:10000,], eps = 6, minPts = 10)
dbscan.test$cluster %>% table
table(rownames(mat.numeric[1:10000,]))
