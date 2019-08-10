###DEMO for Dimensionality Reduction###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# install.packages("ggcorrplot")
# install.packages("survminer")
# install.packages("FactoMineR")
# install.packages("factoextra")
# install.packages("paran")
# install.packages("NMF")
# install.packages("polycor")
# install.packages("missMDA")
# install.packages("psych")
# install.packages("GPArotation")

____________________________________________________________________________


# ls("package:survival") #other things in this package
# Mayo Clinic Primary Biliary Cirrhosis Data, to know more type: ?pbc

# Load data and dependencies: 
library(survminer)
library(survival)
library(survMisc)
library(ggcorrplot)
library(FactoMineR)
library(factoextra)
library(RColorBrewer)
library(paran)
library(Hmisc)
library(NMF)
library(polycor)
library(missMDA)
library(psych)
library(GPArotation)


data(pbc)

# more often than not, large datasets have missing values
# ignoring NA roles is not preferrable as they pose risks to unreliable PCA models and often costly to ignore collected data

pbc <- na.omit(pbc) # remove NAs from nows
pbc <- pbc[,-5] #remove sex column as it's not numeric OR convert sex to binary 

# could also use PCA to estimate missing values using missMDA and then FactoMineR or pcaMethods
____________________________________________________________________________
# First visually Explore the pbc data

head(pbc)
pairs(pbc)
str(pbc)
summary(pbc)
describe(pbc)

____________________________________________________________________________

# explore the correlation structure of the data set
pbc_cor <- cor(pbc, use = "complete.obs")
ggcorrplot(pbc) #visualizing correlation patterns with ggcorrplot

____________________________________________________________________________
# dimensionality reduction: 
## Principal Component Analysis - PCA
## Non-Negative Matrix Factorization - NNMF
## Exploratory Factor Analysis - EFA

# First: Principal Component Analysis - PCA and FactoMineR
# five steps: pre-processing, change of coordinate system, explained variance: centering, standardization, rotation, projection, reduction
# PCA doesn't apply to count/frequency data

pbc_pca <- prcomp(pbc) #prcomp is in base R

pbc_pca <- PCA(pbc) #using factominer package in R

#digging into PCA()
#output matrix with 3 columns, Percentages of variance and cummulative percentage of variance for each component
pbc_pca$eig  

#cosine squared returns dimensions and variables. Closer to 1 means the better the quality
pbc_pca$var$cos2 

#contribution of all variables to dimensions
pbc_pca$var$contrib 

#reduces the most correlated variables to the first it sees
dimdesc(pbc_pca)


#plotting contributions of variables for visual inspection (factoextra)
fviz_pca_var(pbc_pca,
             col.var = "contrib",
             gradient.cols = c("009999", "#0000FF"),
             repel = TRUE)

#plotting contributions of selected variables
fviz_pca_var(pbc_pca,
             select.var = list(contrib = 4),
             repel = TRUE)

#barplotting contributions of variables
fviz_contrib(pbc_pca,
             choice = "var",
             axes = 1,
             top = 5)

#plotting cos2 for individuals 
fviz_pca_ind(pbc_pca,
             col.ind="cos2", #all individuals
             gradient.cols = c("009999", "#0000FF"),
             repel = TRUE)

fviz_pca_ind(pbc_pca,
             select.ind = list(cos2 = 0.6), #for individuals with cos close to higher value
             gradient.cols = c("009999", "#0000FF"),
             repel = TRUE)

fviz_pca(pbc_pca) #biplot of individuals and variables

# can also add ellipsoids (to plot the supplementary information, after they are converted to factors)
pbc$status <- as.factor(pbc$status)
fviz_pca_ind(pbc_pca,
             label = "var",
             habillage = pbc$status, 
             addEllipses = TRUE) 
____________________________________________________________________________

# dimensionality reduction: 
# how to determine the right number of PCs: 3 stopping roles: 1. scree plot, 2. kaiser-guttman rule, 3. parallel analysis
# 1.scree plot: 
fviz_screeplot(pbc_pca, ncp =5)
fviz_screeplot(pbc_pca, ncp =10) #also known as elbow criterion

# in our case, the elbo component can be at the 4th principle component
# so we can safely diregard the dimensions after component 4

# 2. kaiser-guttman rule:
summary(pbc_pca)
pbc_pca$eig
get_eigenvalue(pbc_pca) # keep the PCs with eigenvalue >1 

# 3. parallel analysis

pbc_complete <- pbc[complete.cases(pbc),]
pbc_paran <- paran(pbc_complete)

#check out the suggested number of PCs to retain
pbc_paran$Retained

#visualize paran analysis with 3 retained values
pbc_pca_ret <- paran(pbc_complete,
                     graph = TRUE) #uses the paran package

____________________________________________________________________________

# dimensionality reduction: 
## Non-Negative Matrix Factorization - NNMF nmf()
# applies to data sets with positive data: divide data into bases and coefficient matrix
# minimizing the data using objective functions: (1) the square of the euclidean distance, (2) kullback-leibler divergence

data(pbc)

norma_pbc <- apply(pbc, 2, normal)

W <- basis(pbc)
H <- coef(pbc)


____________________________________________________________________________

# dimensionality reduction: 
## Exploratory Factor Analysis - EFA
# Variance/covariance are only partially explained by factors
# measuring the unobserved (latent constructs) from observed variables
# steps: dataset factorability, extract factors, chose right number of factors to retain, rotate factors, interpret the results

data(pbc)
head(pbc)

# 1.check for factorability
# Bartlett sphericity test

pbc_hector <- hetcor(pbc) #calculates the correlations
pbc_c <- pbc_hector$correlations #retrieve the correlation matrix

pbc_factorability <- cortest.bartlett(pbc_c) #apply the bartlet test
pbc_factorability # usually significant for large data so can also do a KMO test

#check for factorability
# kaiser-meyer-olkin (KMO) test for sampling adequcy

KMO(pbc_c) #compares pairwise correlation matrix with partial correlation matrix

# if KMO is close to 1, the more effective and reliable the reduction will be
# KMO should be in 60s to be reliable

# 2. extract factors

# EFA with 3 factors 
pbc_minres <-fa(pbc_c, nfactors = 3, rotate = "none")
# sorted communality
pbc_minres_common <- sort(pbc_minres$communality, decreasing = TRUE)
# create a dataframe for an improved overview
data.frame(pbc_minres_common)

# OR
# EFA factors with MLE (maximum likelihood error)
pbc_mle <-fa(pbc_c, nfactors = 3, fm = "mle", rotate = "none")
# sorted communality
pbc_mle_common <- sort(pbc_mle$communality, decreasing = TRUE)
# create a dataframe for an improved overview
data.frame(pbc_mle_common)

# good news, our model is factorable, now:
# 3. chose optimal number of factors to retain
# not an easy task, but three formal methods (Kaiser-Guttman criterion, Scree test, and Parallel methods)
fa.parallel(pbc_c, n.obs = 200,
            fa="fa", fm ="minres") #fm is the ectraction method, #fa makes sure only factors of fa end in scree plot

fa.parallel(pbc_c, n.obs = 200,
            fa="fa", fm ="mle")

#results are identical between mle and minres

# 4. Interpretation of EFA and factor rotation
# so we checked for factorability, extracted the factors, and chose optimal number of factors
# now: factor rotation: orthonogal methods or oblique methods: 
# if targeted factors are correlated, oblique method rotation should be employed
# if variables are not correlated, use orthogonal method: i.e. varimax

# applying varimax
f_pbc_varimax <-fa(pbc_c, 
                   fm = "minres",
                   nfactors = 5,
                   rotate = "varimax")


# path diagrams make EFA interpretation easier
fa.diagram(f_pbc_varimax) #visual inspection of factors with repect to variables
print(f_pbc_varimax$loadings, cut = 0) #correlation between variables and factors

____________________________________________________________________________

# performing PCA on datasets with missing values
#missMDA package
# replace missing value with a starting value

data(pbc)
pbc <- pbc[,-5] #remove sex column as it's not numeric OR convert sex to binary 

pbc <- apply(as.matrix.data.frame(pbc), 2, as.numeric)

#checkout the number of cells with missing values
sum(is.na(pbc))

pbc_ncp <- estim_ncpPCA(pbc)

pbc_ncp$ncp

complete_pbc <- imputePCA(pbc, ncp = pbc_ncp$ncp, scale = TRUE)
____________________________________________________________________________






