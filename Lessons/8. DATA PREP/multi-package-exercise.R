###DEMO for multiple package use ###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# set working directory
setwd("~/Desktop/location")
getwd()
dir.wrk <- "~/Desktop/location"
dir.wrk <- getwd()

# library dependencies
library(data.table)
library(dplyr)
library(ggplot2)
library(reshape2)
library(formattable)


file.dat <- file.path(dir.wrk, "Import_table.csv", col.names=TRUE, row.names=FALSE)
dat1 <- fread("Import_table.csv")

#explore data
head(dat1)

# ministry counts for table
Y <- table(dat1$Ministry)
plot(table(dat1$Ministry))

Y <- melt(Y) # transpose table and add more columns 
Y <- rename(Y, Ministry = Var1, Count = value)
Y$Percent <- (Y$Count) *100/127 #making a new column here
Y <- formattable(Y, digits =2, format = "f") #formattable can help with asthetics of table
head(Y)

qplot(data=Y, Ministry, Count, color = Ministry, geom = c("boxplot", "jitter") + 
  theme_linedraw() +
  theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1)) #these coordinates help fit the labels in one plot view

qplot(data=Y, Ministry, Percent, color = Ministry, geom = c("boxplot", "jitter")) + 
  theme_linedraw() + 
  theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1))


write.table(Y, "Export_table.csv", col.names = TRUE, row.names = FALSE, sep = ",")

# proportion table
# X <- prop.table(Y) * 100
# plot(table(X))

