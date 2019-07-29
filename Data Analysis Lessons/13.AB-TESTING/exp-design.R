###DEMO for experimental design in R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for A/B testing)

# planning experiments
## dependent variables = outcome; and independent variables = explanatory variables

# experiment components
## randomization, replication, blocking

# load dependencies
library(ggplot2) 

#-----------------------------------------------------------------

# load data
data(ToothGrowth) #Dataset - The Effect of Vitamin C on Tooth Growth in Guinea Pigs

# Perform a two-sided t-test
t.test(x = ToothGrowth$len, alternative = "two.sided", mu = 18)

# Perform a t-test
ToothGrowth_ttest <- t.test(len ~ supp, data = ToothGrowth)

# Load broom
library(broom)

# Tidy ToothGrowth_ttest
tidy(ToothGrowth_ttest)

# Load dplyr
library(dplyr)

# Replication
# Count number of observations for each combination of supp and dose
ToothGrowth %>% 
  count(supp, dose)
#-----------------------------------------------------------------

# Blocking
# Create a boxplot with geom_boxplot()
# aov() creates a linear regression model by calling lm() and examining results with anova() all in one function call.
ggplot(ToothGrowth, aes(x = dose, y = len)) + 
  geom_boxplot()

# Create ToothGrowth_aov
ToothGrowth_aov <- aov(len ~ dose + supp, data = ToothGrowth)

# Examine ToothGrowth_aov with summary()
summary(ToothGrowth_aov)

#-----------------------------------------------------------------

# Hypothesis Testing (null and alternative)
library(pwr)

# one sided and two sided tests:
# Less than
?t.test
t.test(x = ToothGrowth$len,
       alternative = "less",
       mu = 18)


# Greater than
t.test(x = ToothGrowth$len,
       alternative = "greater",
       mu = 18)

# It turns out the mean of len is actually very close to 18, so neither of these tests tells us much about the mean of tooth length.
?pwr.t.test()

# Calculate sample size
pwr.t.test(n = NULL,
           d = 0.25, 
           sig.level = 0.05, 
           type = "one.sample", 
           alternative = "greater", 
           power = 0.8)

# Calculate power
pwr.t.test(n = 100,
           d = 0.35,
           sig.level = 0.1,
           type = "two.sample",
           alternative = "two.sided",
           power = NULL)

# power for multiple groups
pwr.anova.test(k = 3,
               n = 20,
               f = 0.2, # effect size
               sig.level = 0.05,
               power = NULL)

#-----------------------------------------------------------------

# Anova tests (for multiple groups) can be done in two ways



#-----------------------------------------------------------------

# Basic Experiments
# Exploratory data analysis including A/B testing

# get data
data(txhousing)

# remove NAs
tx_housing <- na.omit(txhousing)

# Examine the variables with glimpse()
glimpse(tx_housing)

# Find median and means with summarize()
tx_housing %>% summarize(median(volume), mean(sales), mean(inventory))


# Use ggplot2 to build a bar chart of purpose
ggplot(data=tx_housing, aes(x = city)) + 
  geom_bar() +
  coord_flip()

# Use recode() to create the new purpose_recode variable

tx_housing$city_recode <- tx_housing$city %>%
  recode("Bay Area" = "California",
         "El Paso" = "California")

# Build a linear regression model, purpose_recode_model
purpose_recode_model <- lm(sales ~ city_recode, data = tx_housing)

# Examine results of purpose_recode_model
summary(purpose_recode_model)

# Get anova results and save as purpose_recode_anova
purpose_recode_anova <- anova(purpose_recode_model)

# Print purpose_recode_anova
purpose_recode_anova

# Examine class of purpose_recode_anova
class(purpose_recode_anova)

# Use aov() to build purpose_aov
purpose_aov <- aov(sales ~ city_recode, data = tx_housing)

# Conduct Tukey's HSD test to create tukey_output
tukey_output <- TukeyHSD(purpose_aov, "city_recode", conf.level = 0.95)

# Tidy tukey_output to make sense of the results
tidy(tukey_output)

#-----------------------------------------------------------------

# Multiple factor experiments

# Use aov() to build purpose_emp_aov
purpose_emp_aov <- aov(sales ~ city_recode + volume , data = tx_housing)

# Print purpose_emp_aov to the console
purpose_emp_aov

# Call summary() to see the p-values
summary(purpose_emp_aov)

#-----------------------------------------------------------------

# Model validation
# Pre-modeling exploratory data analysis

# Examine the summary of sales
summary(tx_housing$sales)


# Examine sales by volume
tx_housing %>% 
  group_by(volume) %>% 
  summarize(mean = mean(sales), var = var(sales), median = median(sales))

# Make a boxplot of sales by volume
ggplot(tx_housing, aes(x = volume, y = sales)) + 
  geom_boxplot()

# Use aov() to create volume_aov plus call summary() to print results
volume_aov <- aov(volume ~ sales, data = tx_housing)
summary(volume_aov)

# Post-modeling validation plots + variance
# For a 2x2 grid of plots:
par(mfrow = c(2, 2))

# Plot grade_aov
plot(volume_aov)

# Bartlett's test for homogeneity of variance
# We can test for homogeneity of variances using bartlett.test(), which takes a formula and a dataset as inputs
bartlett.test(volume ~ sales, data = tx_housing)

# Conduct the Kruskal-Wallis rank sum test
# kruskal.test() to examine whether volume varies by sales when a non-parametric model is employed
kruskal.test(volume ~ sales,
             data = tx_housing)

# The low p-value indicates that based on this test, we can be confident in our result, which we found across this experiment, that volume varies by sales

#-----------------------------------------------------------------

# Sample size for A/B test
# Load the pwr package
library(pwr)

# Use the correct function from pwr to find the sample size
pwr.t.test(n = NULL, 
           d = 0.2, # small effect size of 0.2
           sig.level = 0.05,
           power = 0.8,
           alternative = "two.sided")



# Plot the A/B test results
ggplot(tx_housing, aes(x = sales, y = volume)) + 
  geom_boxplot()

# Conduct a two-sided t-test
t.test(sales ~ volume, data = tx_housing)

#-----------------------------------------------------------------

# Sampling [randomized experiments]

# load data from NHANES dataset
# https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2015

# Load haven
library(haven)

# Import the three datasets using read_xpt()
nhanes_demo <- read_xpt(url("https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DEMO_I.XPT"))
nhanes_bodymeasures <- read_xpt(url("https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/BMX_I.XPT"))
nhanes_medical <- read_xpt(url("https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/MCQ_I.XPT"))

# Merge the 3 datasets you just created to create nhanes_combined
nhanes_combined <- list(nhanes_demo, nhanes_medical, nhanes_bodymeasures) %>%
  Reduce(function(df1, df2) inner_join(df1, df2, by = "SEQN"), .)


# Fill in the dplyr code
nhanes_combined %>% 
  group_by(MCQ035) %>% 
  summarize(mean = mean(INDHHIN2, na.rm = TRUE))

# Fill in the ggplot2 code
nhanes_combined %>% 
  ggplot(aes(as.factor(MCQ035), INDHHIN2)) +
  geom_boxplot() +
  labs(x = "Disease type",
       y = "Income")


# NHANES Data Cleaning
# Filter to keep only those 16+
nhanes_filter <- nhanes_combined %>% filter(RIDAGEYR > 16)

# Load simputation & impute bmxwt by riagendr
library(simputation)
nhanes_final <- impute_median(nhanes_filter, INDHHIN2 ~ RIDAGEYR)

# Recode mcq365d with recode() & examine with count()
nhanes_final$mcq365d <- recode(nhanes_final$MCQ035, 
                               `1` = 1,
                               `2` = 2,
                               `9` = 2)
nhanes_final %>% count(MCQ035)


# Resampling NHANES data
# Use sample_n() to create nhanes_srs
nhanes_srs <- nhanes_final %>% sample_n(2500)

# Create nhanes_stratified with group_by() and sample_n()
nhanes_stratified <- nhanes_final %>% group_by(RIDAGEYR) %>% sample_n(2000, replace = TRUE)


nhanes_stratified %>% 
  count(RIDAGEYR)

# Load sampling package and create nhanes_cluster with cluster()
library(sampling)
nhanes_cluster <- cluster(nhanes_final, c("INDHHIN2"), 6, method = "srswor")

#-----------------------------------------------------------------

# Randomized complete block designs (RCBD)
## block = experimental groups are blocked to be similar (e.g. by sex)
## complete = each treatment is used the same # of times in every block
## randomized = the treatment is assigned randomly inside each block

library(agricolae)

# Create designs using ls()
designs <- ls("package:agricolae", pattern = "design")
print(designs)

# Use str() to view design.rcbd's criteria
str(design.rcbd)

# Build treats and rep
treats <- LETTERS[1:5]
blocks <- 4

# NHANES RCBD
# Build my_design_rcbd and view the sketch
my_design_rcbd <- design.rcbd(treats, r = blocks, seed = 42)
my_design_rcbd$sketch

# Use aov() to create nhanes_rcbd
nhanes_rcbd <- aov(INDHHIN2 ~ MCQ035 + RIDAGEYR, data = nhanes_final)

# Check results of nhanes_rcbd with summary()
summary(nhanes_rcbd)

# Print mean weights by mcq365d and riagendr
nhanes_final %>% 
  group_by(MCQ035, RIDAGEYR) %>% 
  summarize(mean_ind = mean(INDHHIN2, na.rm = TRUE))

# RCBD Model Validation
# Set up the 2x2 plotting grid and plot nhanes_rcbd
par(mfrow = c(2, 2))
plot(nhanes_rcbd)

# Run the code to view the interaction plots
with(nhanes_final, interaction.plot(MCQ035, RIDAGEYR, INDHHIN2))

#-----------------------------------------------------------------

# Balanced incomplete block design (BIBD)
## Balanced = each pair of treatment occur together in a block an equal # of times
## Incomplete = not every treatment will appear in every block

# Use str() to view design.bibd's criteria
str(design.bib) 

# Columns are a blocking factor

#create my_design_bibd_1
my_design_bibd_1 <- design.bib(LETTERS[1:3], k = 4, seed = 42)

#create my_design_bibd_2
my_design_bibd_2 <- design.bib(LETTERS[1:8], k = 3, seed = 42)

#create my_design_bibd_3
my_design_bibd_3 <- design.bib(LETTERS[1:4], k = 4, seed = 42)
my_design_bibd_3$sketch

# Calculate lambda
## lambda <- r(k - 1) / (t - 1)
t = 4
k = 3
r = 3
lambda(4, 3, 3)


# Build the data.frame
creatinine <- c(1.98, 1.97, 2.35, 2.09, 1.87, 1.95, 2.08, 2.01, 1.84, 2.06, 1.97, 2.22)
food <- as.factor(c("A", "C", "D", "A", "B", "C", "B", "C", "D", "A", "B", "D"))
color <- as.factor(rep(c("Black", "White", "Orange", "Spotted"), each = 3))
cat_experiment <- as.data.frame(cbind(creatinine, food, color))

# Create cat_model and examine with summary()
cat_model <- aov(creatinine ~ food + color, data = cat_experiment)
summary(cat_model)


# Calculate lambda
lambda(3, 2, 2)

# Create weightlift_model & examine results
weightlift_model <- aov(MCQ035 ~ INDHHIN2 + RIDAGEYR, data = nhanes_final)
summary(weightlift_model)

#-----------------------------------------------------------------

# Latin Squares Design
## Key assumption: the treatment and two blocking factors do NOT interact
## Two blocking factors (instead of one)
## Analyze like RCBD

sat_scores <- read.csv(url("https://data.ct.gov/api/views/kbxi-4ia7/rows.csv?accessType=DOWNLOAD"))

# Mean, var, and median of Math score by Borough
sat_scores %>%
  group_by(District, Test.takers..2012) %>% 
  summarize(mean = mean(Test.takers..2012, na.rm = TRUE),
            var = var(Test.takers..2012, na.rm = TRUE),
            median = median(Test.takers..2012, na.rm = TRUE))

# Load naniar
library(naniar)

# Dealing with Missing Test Scores
# Examine missingness with miss_var_summary()
sat_scores %>% miss_var_summary()
sat_scores <- na.omit(sat_scores)

# Examine missingness with md.pattern()
md.pattern(sat_scores)

# Impute the Math score by Borough
sat_scores_2 <- impute_median(sat_scores, Test.takers..2012 ~ District)


# Convert Math score to numeric
sat_scores$Average_testtakers2012 <- as.numeric(sat_scores$Test.takers..2012)


# Examine scores by Borough in both datasets, before and after imputation
sat_scores %>% 
  group_by(District) %>% 
  summarize(median = median(Test.takers..2012, na.rm = TRUE), 
            mean = mean(Test.takers..2012, na.rm = TRUE))
sat_scores_2 %>% 
  group_by(District) %>% 
  summarize(median = median(Test.takers..2012), 
            mean = mean(Test.takers..2012))


# Drawing Latin Squares with agricolae
# Load agricolae
library(agricolae)

# Design a LS with 5 treatments A:E then look at the sketch
my_design_lsd <- design.lsd(trt = LETTERS[1:5], seed = 42)
my_design_lsd$sketch

# Build nyc_scores_ls_lm
sat_scores_ls_lm <- lm(Test.takers..2012 ~ Test.takers..2013 + District,
                       data = sat_scores)

# Tidy the results with broom
tidy(sat_scores_ls_lm)

# Examine the results with anova
anova(sat_scores_ls_lm)

#-----------------------------------------------------------------

# Graeco-Latin Squares
## three blocking factors (when there is treatments)
## Key assumption: the treatment and two blocking factors do NOT interact
## Analyze like RCBD

# Drawing Graeco-Latin Squares with agricolae
# Create trt1 and trt2
trt1 <- LETTERS[1:5]
trt2 <- 1:5

# Create my_graeco_design
my_graeco_design <- design.graeco(trt1, trt2, seed = 42)

# Examine the parameters and sketch
my_graeco_design$parameters
my_graeco_design$sketch


# Create a boxplot of scores by District, with a title and x/y axis labels
ggplot(sat_scores, aes(District, Test.takers..2012)) +
  geom_boxplot() + 
  labs(title = "Average SAT Math Scores by District in 2012",
       x = "District",
       y = "Test Takers in 2012")

# Build sat_scores_gls_lm
sat_scores_gls_lm <- lm(Test.takers..2012 ~ Test.takers..2013 + District + School,
                        data = sat_scores)

# Tidy the results with broom
tidy(sat_scores_gls_lm)

# Examine the results with anova
anova(sat_scores_gls_lm)

#-----------------------------------------------------------------

# Factorial Experiment Design
## 2 or more factor variables are combined and crossed
## All of the possible interactions between factors are considered as effect on outcome
## e.g. high/low water on high/low light


# Load ggplot2
library(ggplot2)

# Build the boxplot for the district vs. test taker score
ggplot(sat_scores,
       aes(District, Test.takers..2012)) + 
  geom_boxplot()

# Create sat_scores_factorial and examine the results
sat_scores_factorial <- aov(Test.takers..2012 ~ Test.takers..2013 * District * School, data = sat_scores)

tidy(sat_scores_factorial)


# Evaluating the sat_scores Factorial Model

# Use shapiro.test() to test the outcome
shapiro.test(sat_scores$Test.takers..2013)

# Plot nyc_scores_factorial to examine residuals
par(mfrow = c(2,2))
plot(sat_scores_factorial)
