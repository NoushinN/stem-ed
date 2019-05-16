###DEMO for mathematical models in R###
# lessons curated by Noushin Nabavi, PhD

# Load dependent packages
library(tidyverse)
library(ggplot2)
library(mosaicData)
library(statisticalModeling)

#-------------------------------------------------------------------------------

# load data for this exercise
mosaicData::CPS85
mosaicData::Riders
statisticalModeling::Trucking_jobs
AARP <- statisticalModeling::AARP

#-------------------------------------------------------------------------------


# Find the mean cost broken down by sex
mean(AARP$Cost)

# Create a boxplot using base, lattice, or ggplot2
boxplot(Cost ~ Sex, data = AARP)

# Make a scatterplot using base, lattice, or ggplot2
plot(Cost ~ Age, data = AARP)

