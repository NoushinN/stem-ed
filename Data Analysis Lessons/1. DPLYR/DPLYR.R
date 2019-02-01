###DEMO for DPLYR###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# If you don't have ElemStatLearn, you can install it, by running
# install.packages("ElemStatLearn")
# Prostate is a Data to examine the correlation between the level of prostate-specific antigen and a number of clinical measures in men who were about to receive a radical prostatectomy.

# Load data and dependencies: 
library(ElemStatLearn)
library(dplyr)

data(prostate)

____________________________________________________________________________

#Explore the prostate data

head(prostate)
pairs(prostate)
str(prostate)
summary(prostate)


# A. Select: keeps only the variables you mention
select(prostate, 1:3)
select(prostate, age, gleason)
select(prostate, contains("age"))
select(prostate, starts_with("gleason"))
select(prostate, -train)


# B. Arrange: sort a variable in descending order
arrange(prostate, age)
arrange(prostate, desc(age))
arrange(prostate, lcavol, desc(gleason))


# C. Filter: find rows/cases where conditions are true
## Note: rows where the condition evaluates to NA are dropped

filter(prostate, gleason > 5)
filter(prostate, gleason > 5 & age == "60")
filter(prostate, gleason > 5, age == "60") #the comma is a shorthand for &
filter(prostate, !age == "60")


# D. Pipe Example with MaggriteR (ref: Rene Magritte This is not a pipe)
## The long Way, before nesting or multiple variables
data1 <- filter(prostate, gleason > 6)
data2 <- select(data1, age, lcavol)

# With DPLYR: 
select(
  filter(prostate, gleason > 6),
  age, lcavol)

#using pipes with the data variable
prostate %>%
  filter(gleason > 6) %>%
  select(age, lcavol)

#using the . to specify where the incoming variable will be piped to
#e.g. prostate %>%
#  myFunction(arg1, arg2 = .)

prostate %>%
  filter( ., age == "60")

# Other magrittr examples

prostate %>%
  filter(age > 40) %>%
  select(1:3)

prostate %>%
  select(contains("gleason")) %>%
  arrange(gleason) %>%
  head()

prostate %>%
  filter(age == "60") %>%
  arrange(desc(gleason))

prostate %>%
  filter(gleason > 1) %>%
  View()

prostate %>%
  filter(age == "60") %>%
  select(gleason) %>%
  unique()

# a second way to get the unique values
prostate %>%
  filter(age == "60") %>%
  distinct(gleason)

# E. Mutate: adds new variables and preserves existing; transmute() drops existing variables
prostate %>%
  mutate(highGleason = gleason > 6) %>%
  head()

prostate %>%
  mutate(size = lbph + lcavol) %>%
  head()

prostate %>%
  mutate(MeanAge = mean(age, na.rm = TRUE),
         greaterThanMeanAge = ifelse(age > MeanAge, 1, 0)) %>%
  head()
         
prostate %>%
  mutate(buckets = cut(age, 3)) %>%
  head()

prostate %>%
  mutate(ageBuckets = case_when(age < 50 ~ "Low",
                               age >= 60 & gleason < 5 ~ "Med",
                               age >= 70 ~ "High")) %>%
  head()


# E. Group_by and Summarise: used on grouped data created by group_by(). 
## The output will have one row for each group.
prostate %>%
  summarise(AgeMean = mean(age),
            AgeSD = sd(age))

prostate %>%
  group_by(age) %>%
  mutate(AgeMean = mean(age))

prostate %>%
  group_by(age) %>%
  summarise(AgeMean = mean(age))

prostate %>%
  group_by(age, gleason) %>%
  summarise(count = n())

# F. Slice: Slice does not work with relational databases because they have no intrinsic notion of row order. 
## If you want to perform the equivalent operation, use filter() and row_number().

prostate %>%
  slice(2:7)


# Other verbs within DPLYR: 'Scoped verbs' 

#ungroup
prostate %>%
  group_by(age, gleason) %>%
  summarise(count = n()) %>%
  ungroup()


#Summarise_all
prostate %>%
  select(1:4) %>%
  summarise_all(mean)

prostate %>%
  select(1:4) %>%
  summarise_all(funs(mean, min))

prostate %>%
  summarise_all(~length(unique(.)))

#summarise_at
prostate %>%
  summarise_at(vars(-age), mean)

prostate %>%
  summarise_at(vars(contains("age")), funs(mean, min))

#summarise_if
prostate %>%
  summarise_if(is.numeric, sd)

prostate %>%
  summarise_if(is.factor, ~length(unique(.)))

#other verbs
prostate %>%
  mutate_if(is.factor, as.character) %>%
  str()

prostate %>%
  mutate_at(vars(contains("lweight")), ~ round(.))

prostate %>%
  filter_all(any_vars(is.na(.)))

prostate %>%
  filter_all(all_vars(is.na(.)))



#Rename
prostate %>%
  rename(PercentGleason = pgg45) %>%
  head()

# And finally: make a test and save
test <- prostate %>%
  group_by(age) %>%
  summarise(MeanAge = mean(age))



