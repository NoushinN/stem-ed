###DEMO for grammer of graphics in R###
# lessons curated by Noushin Nabavi, PhD

# load dependencies
library(tidyverse)
library(ggplot2)
library(ggridges)
library(waffle)

#-------------------------------------------------------------------------------

# get data from US Gov data catalogue
# print dataframe to inspect and use ggplot for counts
url = "https://data.cdc.gov/api/views/bi63-dtpu/rows.csv?accessType=DOWNLOAD"

death_causes <- read.csv(url, stringsAsFactors = FALSE, header = TRUE, sep = ",")

# set x aesthetic to region column
# print dataframe to inspect
death_causes

# set x aesthetic to region column
ggplot(death_causes, aes(x = State)) +
  geom_bar()

# filter data to AMR region. 
amr_region <- death_causes %>% 
  filter(State == 'California')

# map x to year and y to cases. 
ggplot(amr_region, aes(x = Year, y = Deaths)) + 
  # lower alpha to 0.5 to see overlap.   
  geom_point(alpha = 0.5)

#-------------------------------------------------------------------------------

# pie charts
# Wrangle data into form we want. 
deaths <- death_causes %>%
  mutate(Cause.Name = ifelse(Cause.Name %in% c('Suicide'), Cause.Name, 'other')) %>%
  group_by(Cause.Name) %>%
  summarise(total_deaths = sum(Deaths))

ggplot(deaths, aes(x = 1, y = total_deaths, fill = Cause.Name)) +
  # Use a column geometry.
  geom_col() +
  # Change coordinate system to polar and set theta to 'y'.
  coord_polar(theta = "y")

# Cleaning up the pie
ggplot(deaths, aes(x = 1, y = total_deaths, fill = Cause.Name)) +
  # Use a column geometry.
  geom_col() +
  # Change coordinate system to polar.
  coord_polar(theta = "y") +
  # Clean up the background with theme_void and give it a proper title with ggtitle.
  theme_void() +
  ggtitle('Proportion of deaths')

#-------------------------------------------------------------------------------

# waffle plots to visualize proportions of populations
death_counts <- death_causes %>%
  group_by(Cause.Name) %>%
  summarise(total_deaths = sum(Deaths)) %>% 
  mutate(percent = round(total_deaths/sum(total_deaths)*100))

# Create an array of rounded percentages for diseases.
case_counts <- death_counts$percent

# Name the percentage array
names(case_counts) <- death_counts$Cause.Name

# Pass case_counts vector to the waffle function to plot
waffle(case_counts)

#-------------------------------------------------------------------------------

#Basic stacked bars
death_counts <- death_causes %>%
  mutate(Cause.Name = ifelse(Cause.Name %in% c("Kidney disease", "Alzheimer's disease"), Cause.Name, "other")) %>%
  group_by(Cause.Name, Year) %>% # note the addition of year to the grouping.
  summarise(total_deaths = sum(Deaths))

# add the mapping of year to the x axis. 
ggplot(death_counts, aes(x = Year, y = total_deaths, fill = Cause.Name)) +
  # Change the position argument to make bars full height
  geom_col(position = 'fill')

#-------------------------------------------------------------------------------

# ordering stacks for readability

death_counts <- death_causes %>%
  mutate(
    Cause.Name = ifelse(Cause.Name %in% c("Kidney disease", "Alzheimer's disease"), Cause.Name, "other") %>% 
      factor(levels = c("Kidney disease", "other", "Alzheimer's disease")) # change factor levels to desired ordering
  ) %>%
  group_by(Cause.Name, Year) %>%
  summarise(total_deaths = sum(Deaths)) 

# plot
ggplot(death_counts, aes(x = Year, y = total_deaths, fill = Cause.Name)) +
  geom_col(position = 'fill')

#-------------------------------------------------------------------------------

# Categorical x-axis

death_counts <- death_causes %>%
  mutate(Cause.Name = ifelse(Cause.Name %in% c("Kidney disease", "Alzheimer's disease"), Cause.Name, "other")) %>%
  group_by(Cause.Name, Year) %>% # note the addition of year to the grouping.
  filter(Year >= 2005 & Year <=2010) %>%
  summarise(total_deaths = sum(Deaths))

# add the mapping of year to the x axis. 
ggplot(death_counts, aes(x = Year, y = total_deaths, fill = Cause.Name)) +
  # Change the position argument to make bars full height
  geom_col(position = 'fill')


#-------------------------------------------------------------------------------

# Working with geom_col
death_causes %>% 
  # filter to Arizona in 2010
  filter(State == "Arizona", Year == 2010) %>% 
  # map x aesthetic to Cause.Name and y to Deaths
  ggplot(aes(x = Cause.Name, y = Deaths)) +
  # use geom_col to draw
  geom_col()


#-------------------------------------------------------------------------------

# Wrangling geom_bar
death_causes %>%
  # filter data to observations of greater than 20000 cases
  filter(Deaths > 20000) %>%
  # map the x-axis to the region column
  ggplot(aes(x = State)) +
  # add a geom_bar call
  geom_bar()

#-------------------------------------------------------------------------------
# Point Charts
death_subset <- death_causes %>% 
  filter(
    State %in% c("California", "Arizona", "Florida", "Colorado"),
    Cause.Name == "Alzheimer's disease",
    Year %in% c(2006, 2011) # Modify years to 2006 and 2011
  ) %>% 
  mutate(Year = paste0('deaths_', Year)) %>% 
  spread(Year, Deaths)

# Reorder y axis and change the Deaths year to 1992
ggplot(death_subset, aes(x = log10(deaths_2006), y = reorder(State, deaths_2006))) +
  geom_point()

#-------------------------------------------------------------------------------

# Adding visual anchors

death_subset %>% 
  # calculate the log fold change between 2006 and 2011
  mutate(logFoldChange = log2(deaths_2006/deaths_2011)) %>% 
  # set y axis as State ordered with respect to logFoldChange
  ggplot(aes(x = logFoldChange, y = reorder(State, logFoldChange))) +
  geom_point() +
  # add a visual anchor at x = 0
  geom_vline(xintercept = 0)

#-------------------------------------------------------------------------------

# Faceting to show structure.
death_subset %>% 
  mutate(logFoldChange = log2(deaths_2006/deaths_2011)) %>% 
  ggplot(aes(x = logFoldChange, y = reorder(State, logFoldChange))) +
  geom_point() +
  geom_vline(xintercept = 0) +
  xlim(-6,6) +
  # add facet_grid arranged in the column direction by region and free_y scales
  facet_grid(State~., scales = 'free_y')

#-------------------------------------------------------------------------------

# Tuning the charts
## e.g. flipping the axis

amr_alz <- death_causes %>% 
  filter(   # filter data to our desired subset
    State == c('Hawaii', 'Arizona', 'Colorado', 'Nebraska'), 
    Cause.Name == "Alzheimer's disease"
  )
# Set x axis as country ordered with respect to cases. 
ggplot(amr_alz, aes(x = reorder(State, Cause.Name), y = Deaths)) +
  geom_point() +
  # flip axes
  coord_flip()

#-------------------------------------------------------------------------------

# Cleaning up the bars

amr_alz %>% 
  # filter to countries that had > 0 cases. 
  filter(Deaths > 0) %>% 
  ggplot(aes(x = reorder(State, Cause.Name), y = Deaths)) +
  geom_point() +
  coord_flip() +
  theme(
    # get rid of the 'major' y grid lines
    panel.grid.major.y = element_blank()
  )

#-------------------------------------------------------------------------------

# Importance of distributions
# orienting with the data

death_causes %>% 
  filter(State == 'Hawaii') %>% 
  # switch x mapping to Deaths column
  ggplot(aes(x = Deaths)) +
  geom_histogram() +
  # give plot a title
  ggtitle('Death Counts in Hawaii')

#-------------------------------------------------------------------------------

# looking at all data

ggplot(death_causes) + 
  # Add the histogram geometry
  geom_histogram(
    # Map Deaths to x
    aes(x = Deaths),
    # Lower alpha to 0.7
    alpha = 0.7
  ) +
  # Add minimal theme
  theme_minimal()


#-------------------------------------------------------------------------------

# can use built in stat(density) to explore distribution

ggplot(death_causes) +
  geom_histogram(
    # set x and y aesthetics to hour_of_day and stat(density) respectively.
    aes(x = Deaths, y = stat(density)), 
    # make points see-through by setting alpha to 0.8
    alpha = 0.8
  )

#-------------------------------------------------------------------------------

# Adjusting the bin numbers

ggplot(death_causes) + 
  # Add the histogram geometry
  geom_histogram(
    # Map Deaths to x
    aes(x = Deaths),
    bins = 40,
    # Lower alpha to 0.7
    alpha = 0.7
  ) +
  # Add minimal theme
  theme_minimal()

#-------------------------------------------------------------------------------

# more bar options (i.e. color fill)
ggplot(death_causes) +
  geom_histogram(
    aes(x = Deaths),
    bins = 100,         # switch to 100 bins
    fill = 'steelblue', # set the fill of the bars to 'steelblue'
    alpha = 0.8 )
 

#-------------------------------------------------------------------------------

# Histogram to KDE (kernel density estimation)
# filter data to just heavy duty trucks
death_filter <- death_causes %>% 
  filter(State == "California")

ggplot(death_filter, aes(x = Age.adjusted.Death.Rate)) +
  # switch to density with bin width of 1.5, keep fill 
  geom_density(bw = 1.5, fill = 'steelblue') +
  # add a subtitle stating binwidth
  labs(title = 'Age adjusted death rates', subtitle = "Gaussian kernel SD = 1.5")

#-------------------------------------------------------------------------------

# adding rugs!
ggplot(death_filter, aes(x = Age.adjusted.Death.Rate)) +
  # Adjust opacity to see gridlines with alpha = 0.7
  geom_density(bw = 1.5, fill = 'steelblue', alpha = 0.7) +
  # add a rug plot using geom_rug to see individual datapoints, set alpha to 0.5.
  geom_rug(alpha = 0.5) +
  labs(title = 'Age adjusted death rates', subtitle = "Gaussian kernel SD = 1.5")

#-------------------------------------------------------------------------------

# KDE with lots of data
ggplot(death_filter, aes(x = Age.adjusted.Death.Rate)) +
  # Increase bin width to 2.5
  geom_density(fill = 'steelblue', bw = 2.5,  alpha = 0.7) + 
  # lower rugplot alpha to 0.05
  geom_rug(alpha = 0.05) + 
  labs(
    title = 'Age adjusted death rates', 
    # modify subtitle to reflect change in kernel width
    subtitle = "Gaussian kernel SD = 2.5"
  )

#-------------------------------------------------------------------------------

# comparing distributions
# boxplots
death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  # add a boxplot geometry
  geom_boxplot()
# give plot supplied title
labs(title = 'Causes of Deaths')

#-------------------------------------------------------------------------------

# Adding some jitter
death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  geom_jitter(alpha = 0.3, color = 'steelblue') + 
  # make boxplot transparent with alpha = 0
  geom_boxplot(alpha = 0) +
# give plot supplied title
labs(title = 'Causes of Deaths')

#-------------------------------------------------------------------------------

# Faceting to show all years
death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  geom_jitter(alpha = 0.3, color = 'steelblue') + 
  # make boxplot transparent with alpha = 0
  geom_boxplot(alpha = 0) +
  facet_wrap(~Year) +
  # give plot supplied title
  labs(title = 'Causes of Deaths')


#-------------------------------------------------------------------------------

# Beeswarms and violins

# Load library for making beeswarm plots
library(ggbeeswarm)

death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  geom_beeswarm(cex = 0.5, alpha = 0.8) +
  # make boxplot transparent with alpha = 0
  geom_boxplot(alpha = 0) +
  # give plot supplied title
  labs(title = 'Causes of Deaths')

#-------------------------------------------------------------------------------

# Fiddling with a violin plot

death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  # make boxplot transparent with alpha = 0
  geom_violin(bw = 2.5) +
  # add individual points on top of violins and set their alpha to 0.3 and size to 0.5
  geom_point(alpha = 0.3, size = 0.5)

#-------------------------------------------------------------------------------

# violin and boxplot!

death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  
  # make boxplot transparent with alpha = 0
  geom_violin(bw = 2.5) +
  # add a transparent boxplot and shrink its width
  geom_boxplot(alpha = 0, width = 0.3) + 
  
  # add individual points on top of violins and set their alpha to 0.3 and size to 0.5
  geom_point(alpha = 0.3, size = 0.5, shape = 95) +
  # Supply a subtitle detailing the kernel width
  labs(subtitle = 'Gaussian kernel SD = 2.5')


#-------------------------------------------------------------------------------

# Comparing lots of distributions
death_causes %>% 
  filter(State == 'Hawaii') %>%
  # Map x and y to Cause.Name and Deaths columns respectively
  ggplot(aes(x = Cause.Name, y = Deaths)) + 
  
  # make boxplot transparent with alpha = 0
  geom_violin(fill = 'steelblue', bw = 2.5) +
  # add a transparent boxplot and shrink its width
  geom_boxplot(alpha = 0, width = 0.3) + 
  
  # add individual points on top of violins and set their alpha to 0.3 and size to 0.5
  geom_point(alpha = 0.3, size = 0.5, shape = 95) +
  facet_wrap(~Year) +
  
  # Supply a subtitle detailing the kernel width
  labs(title = 'Separate by years', subtitle = 'Gaussian kernel SD = 2.5')

#-------------------------------------------------------------------------------

# Comparing spatially related distributions
# using basic ridgeline plot

death_causes %>% 
  mutate(Cause.Name = factor(Cause.Name, levels = c("Kidney disease", "Suicide", "Influenza and pneumonia", "Alzheimer's disease") )) %>% 
  ggplot(aes( x = Deaths, y = Cause.Name)) + 
  # Set bandwidth to 3.5
  geom_density_ridges(bandwidth = 3.5) +
  # add limits of 0 to 150 to x-scale
  scale_x_continuous(limits = c(0,150)) +
  # provide subtitle with bandwidth
  labs(subtitle = 'Gaussian kernel SD = 3.5')

#-------------------------------------------------------------------------------

# Cleaning up your ridgelines

death_causes %>% 
  mutate(Cause.Name = factor(Cause.Name, levels = c("Kidney disease", "Suicide", "Influenza and pneumonia", "Alzheimer's disease") )) %>% 
  ggplot(aes( x = Deaths, y = Cause.Name)) + 
  # Set bandwidth to 3.5
  geom_density_ridges(bandwidth = 3.5, alpha = 0.7) +
  # add limits of 0 to 150 to x-scale
  scale_x_continuous(limits = c(0,150), expand  = c(0,0)) +
  # provide subtitle with bandwidth
  labs(subtitle = 'Gaussian kernel SD = 3.5') +
  # remove y axis ticks by setting equal to element_blank()
  theme(axis.ticks.y = element_blank() )

#-------------------------------------------------------------------------------

# making it rain
death_causes %>% 
  mutate(Cause.Name = factor(Cause.Name, levels = c("Kidney disease", "Suicide", "Influenza and pneumonia", "Alzheimer's disease") )) %>% 
  ggplot(aes( x = Deaths, y = Cause.Name)) + 
  geom_point(
    alpha = 0.2,  # make semi-transparent with alpha = 0.2
    shape = '|',  # turn points to vertical lines with shape = '|'
    position = position_nudge(y = -0.05) # nudge the points downward by 0.05
  ) +
  # Set bandwidth to 3.5
  geom_density_ridges(bandwidth = 3.5, alpha = 0.7) +
  # add limits of 0 to 150 to x-scale
  scale_x_continuous(limits = c(0,150), expand  = c(0,0)) +
  # provide subtitle with bandwidth
  labs(subtitle = 'Gaussian kernel SD = 3.5') +
  # remove y axis ticks by setting equal to element_blank()
  theme(axis.ticks.y = element_blank() )
