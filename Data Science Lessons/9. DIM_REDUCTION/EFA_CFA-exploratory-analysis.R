###DEMO for exploratory and confirmatory factor analysis in R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for R)

# Another data that can be downloaded will be Download the data: gcbs or also bfi (=Big Five personality traits)
## example here is "1_IND.csv" which is a csv turned into matrix

library(psych)
library(here)
library(data.table)
library(dplyr)
library(readr)
library(ggplot2)
library(lattice)
#-------------------------------------------------------------------------------
input_files_paths <- list.files(here("input-data"), pattern = "*.csv")

# function to read input files without extension name
read_input_files <- function(paths){
  data_files <- paths %>%
    basename() %>%
    tools::file_path_sans_ext()
  return(data_files)
}

data_files <- read_input_files(input_files_paths)
print(data_files)

ind_1 <- fread(here("input-data", "1_IND.csv"))
head(ind_1)
dim(ind_1)
summary(ind_1)

unique(ind_1$`level|of|geo|`)

# Levels of geography are:
# 12 (CANADA)
# 11(PROVINCE/TERRITORY TOTAL)
# 6 (RURAL POSTAL CODE AREAS)
# 8 (CITY TOTAL)
# 9 (RURAL COMMUNITIES)
# 61 (CENSUS TRACT)
# 3  (URBAN FSA)
# 7 (OTHER URBAN AREAS)
# 10 (OTHER PROVINCIAL TOTAL)
# 31 (FEDERAL ELECTORAL DISTRICT)
# 51 (ECONOMIC REGION)
# 41 (CENSUS METROPOLITAN AREA)
# 42 (CENSUS AGGLOMERATION)
# 21 (CENSUS DIVISION)
# more info: https://www12.statcan.gc.ca/census-recensement/2016/ref/98-304/chap12-eng.cfm

#-------------------------------------------------------------------------------
plot(x = ind_1$`taxfilers|#|`, y = ind_1$`level|of|geo|`,
     xlab = "no. of taxfilers", ylab = "level of geography",
     main = "Taxfilers Population Density",
     pch = 4, col = "blue")
axis(2, seq(2,62, 2))
#-------------------------------------------------------------------------------
ggplot(ind_1) + geom_density(aes(x = `taxfilers|#|`, color = year)) + facet_wrap(~ `level|of|geo|`, scales = "free")
#-------------------------------------------------------------------------------
# all geo level boxplot
ggplot(ind_1, aes(x= factor(`level|of|geo|`), y= `taxfilers|#|`, group = `level|of|geo|`)) +
                    scale_x_discrete("Levels of Geo", #breaks= c("3", "6", "7", "8", "9", "10", "11", "12", "21", "31", "41", "42", "51", "61"),
                    labels = c("URBAN FSA", "RURAL PC", "OTHER URBAN", "CITY TTL", "RURAL COMM", "OTHER PROV TTL", "PRO TER TTL", "CANADA", "CD", "FED ELE D", "CMA", "CA", "ECON REGION", "CT")) +
                    geom_boxplot(fill = "white", colour = "#3366FF") +
                    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
                    labs(title = "Taxfilers Distribution", subtitle = "based on geo level", y = "No. of Taxfilers") +
                    theme(axis.text.x = element_text(angle = 90, hjust = 1))
#-------------------------------------------------------------------------------
# boxplot removing Canada and provincial level of geo's
ind_1_plot <- ind_1 %>%
  select(`taxfilers|#|`,`level|of|geo|`) %>%
  filter(ind_1$`level|of|geo|` != 11 & ind_1$`level|of|geo|` != 12)

ggplot(ind_1_plot, aes(x= factor(`level|of|geo|`), y= `taxfilers|#|`, group = `level|of|geo|`)) +
  scale_x_discrete("Levels of Geo", #breaks= c("3", "6", "7", "8", "9", "10", "21", "31", "41", "42", "51", "61"),
                   labels = c("URBAN FSA", "RURAL PC", "OTHER URBAN", "CITY TTL", "RURAL COMM", "OTHER PROV TTL", "CD", "FED ELE D", "CMA", "CA", "ECON REGION", "CT")) +
  geom_boxplot(fill = "white", colour = "#3366FF") +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  labs(title = "Taxfilers Distribution", subtitle = "based on geo level", y = "No. of Taxfilers") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
#-------------------------------------------------------------------------------

# boxplot removing Canada, provincial, federal electoral districts, and metropolitan area level of geo's
ind_2_plot <- ind_1 %>%
  select(`taxfilers|#|`,`level|of|geo|`) %>%
  filter(ind_1$`level|of|geo|` != "11" & ind_1$`level|of|geo|` != "12" & ind_1$`level|of|geo|` != "31" & ind_1$`level|of|geo|` != "41")

ggplot(ind_2_plot, aes(x= factor(`level|of|geo|`), y= `taxfilers|#|`, group = `level|of|geo|`)) +
  scale_x_discrete("Levels of Geo", #breaks= c("3", "6", "7", "8", "9", "10", "21", "42", "51", "61"),
                   labels = c("URBAN FSA", "RURAL PC", "OTHER URBAN", "CITY TTL", "RURAL COMM", "OTHER PROV TTL", "CD", "CA", "ECON REGION", "CT")) +
  geom_boxplot(fill = "white", colour = "#3366FF") +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  labs(title = "Taxfilers Distribution", subtitle = "based on geo level", y = "No. of Taxfilers") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
#-------------------------------------------------------------------------------

# Exploratory factor analysis (EFA)
library(psych)

# prepare  the data for analysis with fa()
# data needs to be in a matrix
head(ind_1)
ind_new <- ind_1[,-c(3, 4, 6, 50)]
ind_new[is.na(ind_new)] <- 0
sapply(ind_new, mode)
ind_1_matrix <- as.matrix(ind_new)

# desciptive stats of the data
describe(ind_1_matrix)
error.dots(ind_1_matrix)

# Conduct a single-factor EFA
EFA_model <- fa(ind_1_matrix)

# View the results
EFA_model

# View the factor loadings
EFA_model$loadings
#-------------------------------------------------------------------------------
# Create a path diagram of the items' factor loadings
# fa.diagram() function takes a result object from fa() and creates a path diagram showing the items’ loadings ordered from strongest to weakest.
# Path diagrams are more common for structural equation modeling than for factor analysis, but this type of visualization can be a helpful way to represent data
fa.diagram(EFA_model)

# To get a feel for how the factor scores are distributed, look at their summary statistics and density plot.
summary(EFA_model$scores)

# These factor scores are an indication of how much or how little of the factor each row is thought to possess.
# scores contains factor scores for each row
plot(density(EFA_model$scores, na.rm = TRUE),
     main = "Factor Scores")

# Can view graphical representations of the error bars for different variables using error.dots() and error.bars()
error.bars(ind_1_matrix)
error.dots(ind_1_matrix)

#-------------------------------------------------------------------------------
# Establish two sets of indices to split the dataset
N <- nrow(ind_1_matrix)
indices <- seq(1, N)
indices_EFA <- sample(indices, floor((.5*N)))
indices_CFA <- indices[!(indices %in% indices_EFA)]

# Use those indices to split the dataset into halves for your EFA and CFA
ind_1_matrix_EFA <- ind_1_matrix[indices_EFA, ]
ind_1_matrix_CFA <- ind_1_matrix[indices_CFA, ]

indices_CFA <- as.matrix(indices_CFA)
indices_EFA <- as.matrix(indices_EFA)

# Use the indices to create a grouping variable
group_var <- vector("numeric", nrow(indices_CFA))

group_var[indices_EFA] <- 1
group_var[indices_CFA] <- 2

# Bind that grouping variable onto the gcbs dataset
ind_1_matrix_grouped <- cbind(ind_1_matrix, group_var)

# Compare stats across groups
describeBy(ind_1_matrix_grouped, group = group_var)
statsBy(ind_1_matrix_grouped, group = "group_var")

#-------------------------------------------------------------------------------
# Measure features: Correlations and reliability
lowerCor(ind_1_matrix)
# # Take a look at p-value and correlation data
corr.test(ind_1_matrix, use = "pairwise.complete.obs")
corr.test(ind_1_matrix, use = "pairwise.complete.obs")$p #p list to get the p-values
corr.test(ind_1_matrix, use = "pairwise.complete.obs")$ci #confidence intervals

## Higher CFI corresponds to better model

# Estimate coefficient alpha
alpha(ind_1_matrix) #internal consistency or reliability analysis, alpha > 0.8 for reliability

# Calculate split-half reliability
splitHalf(ind_1_matrix) #split-alf reliability

#-------------------------------------------------------------------------------

# Determining dimensionality
# Establish two sets of indices to split the dataset
N <- nrow(ind_1_matrix)
indices <- seq(1, N)
indices_EFA <- sample(indices, floor((.5*N)))
indices_CFA <- indices[!(indices %in% indices_EFA)]

# Use those indices to split the dataset into halves for your EFA and CFA
ind_1_matrix_EFA <- bfi[indices_EFA, ]
ind_1_matrix_CFA <- bfi[indices_CFA, ]


# Calculate the correlation matrix first
ind_1_matrix_EFA_cor <- cor(ind_1_matrix_EFA, use = "pairwise.complete.obs")

# Then use that correlation matrix to calculate eigenvalues
eigenvals <- eigen(ind_1_matrix_EFA_cor)

# Look at the eigenvalues returned
eigenvals$values # greater than 1 is reliable eigen

# Calculate the correlation matrix first
ind_1_matrix_EFA_cor <- cor(ind_1_matrix_EFA, use = "pairwise.complete.obs")

# Then use that correlation matrix to create the scree plot
scree(ind_1_matrix_EFA_cor, factors = FALSE)

#-------------------------------------------------------------------------------
#multidimensional data
# Run the EFA with seve factors (as indicated by your scree plot)
EFA_model <- fa(ind_1_matrix_EFA, nfactors = 7)

# View results from the model object
EFA_model

# Run the EFA with sevenn factors (as indicated by your scree plot)
EFA_model <- fa(ind_1_matrix_EFA, nfactors = 7)

# View items' factor loadings
EFA_model$loadings

# View the first few lines of examinees' factor scores
head(EFA_model$scores)

#-------------------------------------------------------------------------------

# Investigating model fit: absolute vs. relative
# commonly used cut-off values:
## Chi-square test = non-significant results
## tucker lewis index (TLI) > 0.9
## RMSEA < 0.05
## if comparing multiple models, use relative fit statistics -> BIC: lower BIC is preferred

# Selecting the best model
# Run each theorized EFA on your dataset
bfi_theory <- fa(ind_1_matrix_EFA, nfactors = 6)
bfi_eigen <- fa(ind_1_matrix_EFA, nfactors = 7)

# Compare the BIC values
bfi_theory$BIC
bfi_eigen$BIC

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Setting up a CFA (confirmatory factor analysis)
# CFA specifies variable/factor relationships
## CFA results is needed for a separate datasets in publications

# Creating CFA syntax from EFA results
# Conduct a five-factor EFA on the EFA half of the dataset
EFA_model <- fa(ind_1_matrix_EFA, nfactors = 5)

# Use the wrapper function to create syntax for use with the sem() function
EFA_syn <- structure.sem(EFA_model)

# Set up syntax specifying which items load onto each factor
theory_syn_eq <- "
AGE: A1, A2, A3, A4, A5
CON: C1, C2, C3, C4, C5
EXT: E1, E2, E3, E4, E5
NEU: N1, N2, N3, N4, N5
OPE: O1, O2, O3, O4, O5
"
# Feed the syntax in to have variances and covariances automatically added
library(lavaan)
theory_syn <- cfa(text = theory_syn_eq,
                  reference.indicators = FALSE)

# Use the sem() function to run a CFA
theory_CFA <- sem(theory_syn, data = ind_1_matrix_CFA)

# Use the summary function to view fit information and parameter estimates
summary(theory_CFA)
#-------------------------------------------------------------------------------

# Investigating model fit
## GFI (good model fit) or CFI (comparitive fit index)
## GFI should be above 0.9
## lower BIC the better

# Set the options to include various fit indices so they will print
options(fit.indices = c("CFI", "GFI", "RMSEA", "BIC"))

# Run a CFA using the EFA syntax you created earlier
EFA_CFA <- sem(EFA_syn, data = ind_1_matrix_CFA)

# Locate the BIC in the fit statistics of the summary output
summary(EFA_CFA)$BIC

# Compare EFA_CFA BIC to the BIC from the CFA based on theory
summary(theory_CFA)$BIC
#-------------------------------------------------------------------------------

# View the first five rows of the EFA loadings
EFA_model$loadings[1:5,]

# View the first five loadings from the CFA estimated from the EFA results
summary(EFA_CFA)$coeff[1:5,]


# Plotting differences in persons' factor scores
# Extracting factor scores from the EFA model
EFA_scores <- EFA_model$scores

# Calculating factor scores by applying the CFA parameters to the EFA dataset
CFA_scores <- fscores(EFA_CFA, data = ind_1_matrix_EFA)

# Comparing factor scores from the EFA and CFA results from the bfi_EFA dataset
plot(density(EFA_scores[,1], na.rm = TRUE),
     xlim = c(-3, 3), ylim = c(0, 1), col = "blue")
lines(density(CFA_scores[,1], na.rm = TRUE),
      xlim = c(-3, 3), ylim = c(0, 1), col = "red")
#-------------------------------------------------------------------------------
# Adding loadings to improve fit and comparing revised models using ANOVA
# for more info, checkout: http://davidakenny.net/cm/fit.htm
## Higher CFI corresponds to better model

# Add loadings to improve fit
# Add some plausible item/factor loadings to the syntax
theory_syn_add <- "
AGE: A1, A2, A3, A4, A5
CON: C1, C2, C3, C4, C5
EXT: E1, E2, E3, E4, E5, N4
NEU: N1, N2, N3, N4, N5, E3
OPE: O1, O2, O3, O4, O5
"
# Convert your equations to sem-compatible syntax
theory_syn2 <- cfa(text = theory_syn_add, reference.indicators = FALSE)


# Run a CFA with the revised syntax
theory_CFA_add <- sem(model = theory_syn2, data = ind_1_matrix_CFA)

# Conduct a likelihood ratio test
anova(theory_CFA, theory_CFA_add)

# Compare the comparative fit indices - higher is better!
summary(theory_CFA)$CFI
summary(theory_CFA_add)$CFI

# Compare the RMSEA values - lower is better!
summary(theory_CFA)$RMSEA
summary(theory_CFA_add)$RMSEA

# Compare BIC values, lower BIC improves fit
summary(theory_CFA)$BIC
summary(theory_CFA_add)$BIC

#-------------------------------------------------------------------------------
# Improving fit by removing loadings
# Remove the weakest factor loading from the syntax
theory_syn_del <- "
AGE: A1, A2, A3, A4, A5
CON: C1, C2, C3, C4, C5
EXT: E1, E2, E3, E4, E5
NEU: N1, N2, N3, N4, N5
OPE: O1, O2, O3, O5
"

# Remove the weakest factor loading from the syntax
theory_syn_del <- "
AGE: A1, A2, A3, A4, A5
CON: C1, C2, C3, C4, C5
EXT: E1, E2, E3, E4, E5
NEU: N1, N2, N3, N4, N5
OPE: O1, O2, O3, O5
"

# Convert your equations to sem-compatible syntax
theory_syn3 <- cfa(text = theory_syn_del, reference.indicators = FALSE)

# Run a CFA with the revised syntax
theory_CFA_del <- sem(model = theory_syn3, data = ind_1_matrix_CFA)


# Compare the comparative fit indices - higher is better!
summary(theory_CFA)$CFI
summary(theory_CFA_del)$CFI

# Compare the RMSEA values - lower is better!
summary(theory_CFA)$RMSEA
summary(theory_CFA_del)$RMSEA

# Compare BIC values
summary(theory_CFA)$BIC
summary(theory_CFA_del)$BIC
