import pandas as pd
import numpy as np

df = pd.read_csv('LCZ_Shuffled_Random_Dropped.csv')

# Strip NA rows
df = df.dropna()

from sklearn.preprocessing import OneHotEncoder

# Converting categories to binary variables is not automatic in sci-kit learn
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
X = df.iloc[:,1:]

# Replicate behaviour of model.matrix in R.
cats_9 = np.sort(df.LCZ16_09.unique())
cats_10 = np.sort(df.LCZ16_10.unique())[1:]
cats_11 = np.sort(df.LCZ16_11.unique())[1:]

ct = ColumnTransformer(
  [("OneHot", OneHotEncoder(
    categories=[cats_9, cats_10, cats_11],
    handle_unknown = 'ignore'), 
    [7, 8, 9])],
  remainder = 'passthrough'
)

mat_numeric = ct.fit_transform(X).todense()

# Remember that k-means algorithm isn't deterministic, so set the seed!
from sklearn.cluster import KMeans
n_clusters = 15
kmeans = KMeans(n_clusters = n_clusters, 
                   n_init = 1, 
                   verbose = 1, 
                   random_state = 1).fit(mat_numeric)
clusters = kmeans.predict(mat_numeric)


import matplotlib
import matplotlib.pyplot as plt

# How many in each cluster?
unique, counts = np.unique(clusters, return_counts=True)

# Plot counts
p1 = plt.bar(range(n_clusters), counts)
plt.xticks([])
plt.show()

# What is the within-sum-of-squares?
point_to_mean_distance = kmeans.transform(mat_numeric)
cluster_withinss = \
  [point_to_mean_distance[clusters == cluster, cluster].sum() \
  for cluster in range(n_clusters)]

# Plot within sum of squares.
p1 = plt.bar(range(n_clusters), cluster_withinss)
plt.xticks([])
plt.show()

# A lot of time can be spent looking at kmeans centers when you don't have
# anything else to help you understand what the clusters are.
np.set_printoptions(suppress=True) # Turn of scientific notation
centers = kmeans.cluster_centers_
np.around(centers, 2)

# Plot as heatmap
plt.imshow(centers, cmap='hot', interpolation='nearest')
plt.show()

# Just continuous cols
plt.imshow(centers[:,range(7)], 
  cmap=matplotlib.cm.get_cmap("Blues"), 
  interpolation='nearest')
plt.show()

# Just binary cols
plt.imshow(centers[:,7:], 
  cmap=matplotlib.cm.get_cmap("Blues"), 
  interpolation='nearest')
plt.show()

# Tabulate similarities

# Counts
true_lcz = df[[0]].values.ravel()
pd.crosstab(true_lcz, clusters)

# Normalize by row
by_row = pd.crosstab(true_lcz, clusters, normalize = "index")
by_row.round(2)
by_col = pd.crosstab(true_lcz, clusters, normalize = "columns")
by_col.round(2)

# Plot by row
ax = plt.gca()
ax.imshow(by_row, 
  cmap=matplotlib.cm.get_cmap("Blues"), 
  interpolation='nearest')
ax.set_yticks(np.arange(by_row.shape[1]))
ax.set_yticklabels(by_row.index)
plt.show()

# Plot by column
ax = plt.gca()
ax.imshow(by_col, 
  cmap=matplotlib.cm.get_cmap("Blues"), 
  interpolation='nearest')
ax.set_yticks(np.arange(by_col.shape[1]))
ax.set_yticklabels(by_col.index)
plt.show()


# Hierarchical agglomerative clustering

# Fortunately, it has been implemented by somebody with quite a nice analysis of
# the complexity and comparison to other packages.
import fastcluster

# fastcluster has a nice website to go along with it:
# http://danifold.net/fastcluster.html

# So the result is that linkage_vector is a much more efficient 
# But it isn't magic; always test when you have larger datasets.

from timeit import default_timer as timer

start = timer()
fastcluster.linkage_vector(mat_numeric[0:1000,:7])
end = timer()
# Time for 1000
print(end - start) 

start = timer()
fastcluster.linkage_vector(mat_numeric[0:10000,:7])
end = timer()
# Time for 10000
print(end - start) 

# Hm, this won't scale linearly. Let's randomly sample 1000 so it will be easier to work with.
np.random.seed(1)
samples = np.random.randint(0,df.shape[0], 100)
mat_sample = mat_numeric[samples, :]

h = fastcluster.linkage_vector(mat_sample)

from scipy.cluster.hierarchy import dendrogram
from scipy.spatial.distance import pdist

def plot_with_labels(Z, num_clust, classes):
  # Have a look at the colormaps here and decide which one you'd like:
  # http://matplotlib.org/1.2.1/examples/pylab_examples/show_colormaps.html
  colormap = matplotlib.cm.get_cmap("Set3")
  N = classes.size
  threshold = Z[-num_clust + 1, 2]
  dg = dendrogram(Z, no_labels = True, color_threshold = threshold)
  color = [classes[k] for k in dg['leaves']]
  real_col = [colormap(i*10) for i in color]
  b = .1 * Z[-1, 2]
  plt.bar(
    np.arange(N) * 10, 
    np.ones(N) * b, 
    bottom = -b, 
    width = 10,
    color = real_col,
    edgecolor = 'none',
  )
  plt.gca().set_ylim((-b, None))
  plt.show()


plot_with_labels(h, 15, clusters[samples])

# DBSCAN
# What is DBSCAN?
# https://en.wikipedia.org/wiki/DBSCAN
from sklearn.cluster import DBSCAN
clustering = DBSCAN(eps = 5, min_samples = 10)
dbscan_test = clustering.fit_predict(mat_numeric[:10000, :])

# -1 is the unclustered group.
pd.Series(dbscan_test).value_counts()

true_lcz = df.iloc[:10000, 0].values.ravel()
pd.crosstab(true_lcz, dbscan_test)
