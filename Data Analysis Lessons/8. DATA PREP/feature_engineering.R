###DEMO for feature engineering in R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons)

# load libraries
library(tidyverse)
library(caret)

#-------------------------------------------------------------------
# load data
starwars 

starwars_logs <- starwars %>%	
  na.omit() %>%
  mutate( 
    # Create male column
    male = ifelse(gender == "male", 1, 0),
    
    # Create female column
    female = ifelse(gender == "female", 1, 0))

#-------------------------------------------------------------------

# Binning encoding: content driven

# Look at a variable in a table
starwars %>%
  select(gender) %>%
  table()

starwars %>%
  select(gender, skin_color) %>%
  table()

# Look at a table of the new column 
starwars_logs %>%
  select(male) %>%
  table()

# Create a new column with the proper string encodings
starwars_logs_new <-  starwars %>%
  na.omit() %>%
  mutate(skin = 
           case_when(skin_color == "fair" ~ "fair skin",
                     skin_color == "white" ~ "white skin"))

# Converting new categories to numeric
starwars_new <- starwars %>%	
  na.omit() %>%
  mutate( 
    # Create hair column
    hair1 = ifelse(hair_color == "fair", 1, 0),
    
    # Create mid_sch column
    hair2 = ifelse(hair_color == "white", 1, 0),
    
    # Create high_sch column
    hair3 = ifelse(hair_color == "brown", 1, 0))

# Create a table of the frequencies
starwars_table <- starwars %>%
  na.omit() %>%
  select(skin_color, hair_color) %>%
  table() 

# Create a table of the proportions
prop_table <- prop.table(starwars_table, 1)

# Combine the proportions and discipline logs data
starwars_join <- inner_join(as.data.frame(starwars_table), as.data.frame(prop_table), by = "skin_color")

# Display a glimpse of the new data frame
glimpse(starwars_join)

# Create a new column with three levels using the proportions as ranges
starwars_join_ed <- starwars_join %>%
  mutate(skin_levels = 
           case_when(skin_color =="blue" ~ "blue skin",
                     skin_color =="brown" ~ "brown skin"))

#-------------------------------------------------------------------

# Numerical bucketing or binning
# Look at a variable in a table
starwars %>%
  na.omit() %>%
  select(mass) %>%
  glimpse()

starwars %>%
  na.omit() %>%
  select(mass) %>%
  summary() 

# Create a histogram of the possible variable values
ggplot(starwars, aes(x = mass)) + 
  geom_histogram(stat = "count")

# Create a sequence of numbers to capture the mass range
seq(1, 140, by = 20)

# Use the cut function to create a variable quant_cat
starwars_mass <- starwars %>% 
  mutate(quant_cat = cut(mass, breaks = seq(1, 140, by = 20))) 


# Create a table of the new column quant_cat
starwars_mass %>%
  select(quant_cat) %>%
  table()

# Create new columns from the quant_cat feature
head(model.matrix(~ quant_cat -1, data = starwars_mass)) # -1 means we want to select all the encodings

# Break the Quantity variable into 3 buckets
starwars_tile <- starwars %>% 
  mutate(quant_q = ntile(mass, 3))

# Use table to look at the new variable
starwars_tile %>% 
  select(quant_q) %>%
  table()

# Specify a full rank representation of the new column
head(model.matrix(~ quant_q, data = starwars_tile))

#-------------------------------------------------------------------

# Date and time feature extraction
library(lubridate)
library(tidyverse)
library(dendextend)

# load data
myData <- data.frame(time=as.POSIXct(c("2019-01-22 14:28:21","2017-01-23 14:28:55",
                            "2019-01-23 14:29:02","2018-01-23 14:31:18")),
                     speed=c(2.0,2.2,3.4,5.5))

# Look at the column times
myData %>%
  select(time) %>%
  glimpse()

# Assign date format to the timestamp_date column
myData %>%
  mutate(times_date = ymd_hms(time))

myData$times <- as.POSIXct(strptime(myData$time,"%Y-%m-%d %H:%M:%S"))


# Create new column dow (day of the week) 
myData_logs <- myData %>% 
  mutate(dow = wday(as.POSIXct(times, label = TRUE)))

head(myData)

# Create new column hod (hour of day) 
myData_logs <- myData %>% 
  mutate(hod = hour(times))

head(myData_logs)


# Create histogram of hod 
ggplot(myData_logs, aes(x = hod)) + 
  geom_histogram(stat = "count")

#-------------------------------------------------------------------

## Box-Cox and Yeo-Johnson are used to address issues with non-normally distributed features
# Box-Cox transformations

# Select the variables
cars_vars <- mtcars %>%
  select(mpg, cyl) 

# Perform a Box-Cox transformation on the two variables.
processed_vars <- preProcess(cars_vars, method = c("BoxCox"))

# Use predict to transform data
cars_vars_pred <- predict(processed_vars, cars_vars)

# Plot transformed features
ggplot(cars_vars_pred, aes(x = mpg)) + 
  geom_density()

ggplot(cars_vars_pred, aes(x = cyl)) + 
  geom_density()

# Yeo-Johnson transformations

# Select the variables
cars_vars <- mtcars %>%
  select(mpg, wt) 

# Perform a Yeo-Johnson transformation 
processed_vars <- preProcess(cars_vars, method = c("YeoJohnson"))

# Use predict to transform data
cars_vars_pred <- predict(processed_vars, cars_vars)

# Plot transformed features
ggplot(cars_vars_pred,aes(x = mpg)) + 
  geom_density()

ggplot(cars_vars_pred,aes(x = wt)) + 
  geom_density()

#-------------------------------------------------------------------

## Other normalization techniques include scale features
## including mean centering and z-score standardization


# scaling:
# Create a scaled new feature scaled_mpg 
mtcars_df <- mtcars %>%
  mutate(scaled_mpg = (mpg - min(mpg)) / 
           (max(mpg) - min(mpg)))

# Summarize both features
mtcars_df %>% 
  select(mpg, scaled_mpg) %>%
  summary()


# Use mutate to create column mean_mpg
mtcars_df <- mtcars %>%
  select(mpg) %>%
  mutate(mpg_mean = mpg - mean(mpg)) %>%
  summary()

# Select variables 
mtcars_vars <- mtcars %>% 
  select(mpg, cyl, wt)

# Use preProcess to mean center variables
processed_vars <- preProcess(mtcars_vars, method = c("center"))

# Use predict to include tranformed variables into data
mtcars_pred_df <- predict(processed_vars, mtcars_vars)

# Summarize the three new column scales
mtcars_pred_df %>% 
  select(mpg, cyl, wt) %>%
  summary()


# Z-score standardization:
# Standardize mppg
mtcars_df <- mtcars %>% 
  mutate(z_mpg = (mpg - mean(mpg))/
           sd(mpg))

# Summarize new and original variable
mtcars_df %>% 
  select(mpg, z_mpg) %>%
  summary()

# Select variables 
mtcars_vars <- mtcars %>% 
  select(mpg, cyl, wt)

# Create preProcess variable list 
processed_vars <- preProcess(mtcars_vars, method = c("center", "scale"))

# Use predict to assign standardized variables
mtcars_vars_df <- predict(processed_vars, mtcars_df)

# Summarize new variables
mtcars_df %>% 
  select(mpg, cyl, wt) %>% 
  summary()

#-------------------------------------------------------------------

# Feature crossing

# Group the data and create a summary of the counts
mtcars %>% 
  group_by(mpg, gear) %>%
  summarize(n = n()) %>%
  # Create a grouped bar graph 
  ggplot(., aes(mpg, n, fill = gear)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Create a table of the variables of interest
mtcars %>% 
  select(mpg, gear) %>%
  table()

# Create a feature cross between mpg and gear  
dmy <- dummyVars( ~ mpg:gear, data = mtcars)

# Create object of your resulting data frame
oh_data <- predict(dmy, newdata = mtcars)

# Summarize the resulting output
summary(oh_data)

#-------------------------------------------------------------------

# Principal component analysis

# Create the df
mtcars_x <- mtcars %>% 
  select(cyl, mpg, gear, carb, wt)

# Perfom PCA
mtcars_x_pca <- prcomp(mtcars_x,
                   center = TRUE,
                   scale. = TRUE) 

summary(mtcars_x_pca)

# visualizing and plotting the outcome of PCA
# Create pca component column 
prop_var <- tibble(sdev = mtcars_x_pca$sdev) %>%
  mutate(pca_comp = 1:n())

# Calculate the proportion of variance
prop_var <- prop_var %>%
  mutate(pcVar = sdev^2,
         propVar_ex = pcVar/sum(pcVar), 
         pca_comp = as.character(pca_comp))

ggplot(prop_var, aes(pca_comp, propVar_ex), group = 1) +
  geom_line() +
  geom_point()


autoplot(mtcars_x_pca, data = mtcars_x, colour = "carb")






