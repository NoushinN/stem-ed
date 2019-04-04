###DEMO for working with time and date in R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for working with dates)

# load dependencies and libraries
library(ggplot2)
library(dplyr)
library(ggridges)
library(hflights)
library(lubridate)

## check lubridate functions for fun :)
today()
now()
# and check your local  timezone
Sys.timezone()

#-------------------------------------------------------------------------------

# Rule to work with dates according to ISO 8601 standard
# format is YYYY-MM-DD 

# The date R 3.0.0 was released
x <- "2013-04-03"

# Examine structure of x
str(x)

# Use as.Date() to interpret x as a date
x_date <- as.Date(x)

# Examine structure of x_date
str(x_date)

# Store April 10 2019 as a Date
april_10_2019 <- as.Date("2019-04-10")

# round dates
r_3_4_1 <- ymd_hms("2016-05-03 07:13:28 UTC")

# Round down to day
floor_date(r_3_4_1, unit = "day")

# Round to nearest 5 minutes
round_date(r_3_4_1, unit = "5 minutes")

# Round up to week
ceiling_date(r_3_4_1, unit = "week")

# Subtract r_3_4_1 rounded down to day
r_3_4_1 - floor_date(r_3_4_1, unit = "day")

#-------------------------------------------------------------------------------

# Setting the timezone
# Game2: CAN vs NZL in Edmonton
game2 <- mdy_hm("June 11 2015 19:00")

# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")

# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = "America/Edmonton")
game2_local

# Set the timezone to "America/Winnipeg"
game3_local <- force_tz(game3, tzone = "America/Winnipeg")
game3_local

# How long does the team have to rest?
as.period(game2_local %--% game3_local)


# What time is game2_local in NZ?
with_tz(game2_local, tzone = "Pacific/Auckland")

# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = "America/Los_Angeles")

# What time is game3_local in NZ?
with_tz(game3_local, tzone = "Pacific/Auckland")

#-------------------------------------------------------------------------------

# Examine DepTime and ArrTime in library(hflights) and others
head(hflights$DepTime)
head(hflights$ArrTime)

# Examine structure of time column
str(hflights$DepTime)
str(hflights$ArrTime)

tibble::glimpse(hflights)

# Are DepTime and ArrTime the same moments
table(hflights$DepTime - hflights$ArrTime)


# A plot using just time
ggplot(hflights, aes(x = DepTime, y = ArrTime)) +
  geom_line(aes(group = make_date(Year, Month, DayofMonth)), alpha = 0.2)

# Force datetime to Pacific/Auckland
hflights_hourly <- hflights %>%
  mutate(
    Dep = make_date(Year, Month, DayofMonth),
    newDep = force_tz(Dep, tzone = "Pacific/Auckland"))

# check whether times changed
hflights_hourly$newDep == hflights$DepTime


#-------------------------------------------------------------------------------

# Taking differences of datetimes 
## difftime(time1, time2) takes an argument units which specifies the units for the difference. 
## Your options are "secs", "mins", "hours", "days", or "weeks"

# The date landing and moment of step
date_landing <- mdy("July 20, 1969")
moment_step <- mdy_hms("July 20, 1969, 02:56:15", tz = "UTC")

# How many days since the first man on the moon?
difftime(today(), date_landing, units = "days")

# How many seconds since the first man on the moon?
difftime(now(), moment_step, units = "secs")

# another example with three dates
mar_11 <- ymd_hms("2017-03-11 12:00:00", 
                  tz = "America/Los_Angeles")
mar_12 <- ymd_hms("2017-03-12 12:00:00", 
                  tz = "America/Los_Angeles")
mar_13 <- ymd_hms("2017-03-13 12:00:00", 
                  tz = "America/Los_Angeles")

# Difference between mar_13 and mar_12 in seconds
difftime(mar_13, mar_12, units = "secs")

# Difference between mar_12 and mar_11 in seconds
difftime(mar_12, mar_11, units = "secs")

#-------------------------------------------------------------------------------

# Getting datetimes into R
# Use as.POSIXct to enter the datetime 
as.POSIXct("2010-10-01 12:12:00")

# Use as.POSIXct again but set the timezone to `"America/Los_Angeles"`
as.POSIXct("2010-10-01 12:12:00", tz = "America/Los_Angeles")

#-------------------------------------------------------------------------------

# timespans
# Add a period of one week to mon_2pm
mon_2pm <- dmy_hm("27 Aug 2018 14:00")
mon_2pm + weeks(1)

# Add a duration of 81 hours to tue_9am
tue_9am <- dmy_hm("28 Aug 2018 9:00")
tue_9am + hours(81)

# Subtract a period of five years from today()
today() - years(5)

# Subtract a duration of five years from today()
today() - dyears(5)

# Arithmetic with timespans
# Time of North American Eclipse 2017
eclipse_2017 <- ymd_hms("2017-08-21 18:26:40")

# Duration of 29 days, 12 hours, 44 mins and 3 secs
synodic <- ddays(29) + dhours(12) + dminutes(44) + dseconds(3)

# 223 synodic months
saros <- 223*synodic

# Add saros to eclipse_2017
eclipse_2017 + saros

#-------------------------------------------------------------------------------

# Generating sequences of datetimes

# Add a period of 8 hours to today
today_8am <- today() + hours(8) 

# Sequence of two weeks from 1 to 26
every_two_weeks <- 1:26 * weeks(2)

# Create datetime for every two weeks for a year
today_8am + every_two_weeks


# A sequence of 1 to 12 periods of 1 month
month_seq <- 1:12 * months(1)

# Add 1 to 12 months to jan_31
jan_31 + month_seq 

# Replace + with %m+%
jan_31 %m+% month_seq

# %m+% and %m-% are operators not functions. 
# That means you don't need parentheses, just put the operator between the two objects to add or subtract.

# Replace + with %m-%
jan_31 %m-% month_seq

#-------------------------------------------------------------------------------

# Intervals
# The operator %within% tests if the datetime (or interval) on the left hand side is within the interval of the right hand side. 

# New column for interval from start to end date
hflights_intervals <- hflights %>% 
  mutate(
    start_date = make_datetime(Year, Month, DayofMonth, DepTime), 
    end_date =  make_datetime(Year, Month, DayofMonth, ArrTime),
    visible = start_date %--% end_date)

# The individual elements 
hflights_intervals$visible[14, ] 

# within
hflights_intervals %>% 
  filter(hflights_intervals$start_date %within% hflights_intervals$end_date) %>%
  select(Year, Month, DayofMonth, ArrTime)

# overlaps
hflights_intervals %>% 
  filter(int_overlaps(hflights_intervals$start_date, hflights_intervals$end_date)) %>%
  select(Year, Month, DayofMonth, ArrTime)



#can create an interval by using the operator %--% with two datetimes. For example ymd("2001-01-01") %--% ymd("2001-12-31") creates an interval for the year of 2001.
# Once you have an interval you can find out certain properties like its start, end and length with int_start(), int_end() and int_length() respectively.

# Create an interval for flights
flights <- hflights_intervals %>%
  mutate(ints = start_date %--% end_date) 

# Find the length of flights, and arrange
flights %>%
  mutate(length = int_length(hflights_intervals$start_date)) %>% 
  arrange(desc(length)) 

# Intervals are the most specific way to represent a span of time since they retain information about the exact start and end moments. 
# They can be converted to periods and durations exactly: it's possible to calculate both the exact number of seconds elapsed between the start and end date, as well as the perceived change in clock time.
# New columns for duration and period
fly <- flights %>%
  mutate(
    duration = as.duration(hflights_intervals$start_date),
    period = as.period(hflights_intervals$start_date)) 

# use the as.period(), and as.duration() functions, parsing in an interval as the only argument.

#-------------------------------------------------------------------------------

# example data for this lesson can be downloaded from devtools/github source
library(hflights)

# Data - Ambient Temperature For The City Of Mumbai, India For All Of 2013
data(hflights)
print(hflights)


# Examine the structure of the date column
str(hflights)

min(hflights$Year)
max(hflights$Year)


# Find the largest date
last_date <- max(hflights$Year)

#current date:
Sys.Date()

# How long since last date?
Sys.Date() - last_date

#-------------------------------------------------------------------------------
# Load the readr package which also has build-in functions for dealing with dates
library(readr)

# Load the anytime package
library(anytime)

# Various ways of writing Sep 10 2009
sep_10_2009 <- c("September 10 2009", "2009-09-10", "10 Sep 2009", "09-10-2009")

# Use anytime() to parse sep_10_2009
anytime(sep_10_2009)

#-------------------------------------------------------------------------------

# Examine the head() of hflights
head(hflights)

# Examine the head() of the months of release_time
head(month(hflights))

# Extract the month of hflights 
month(hflights$Month) %>% table()

# Extract the year of hflights
year(hflights$Year) %>% table()

# How often is the hour before 12 (noon)?
mean(as.POSIXct(hflights$DepTime, origin="1991-01-01"))

# How often is the release in am?
mean(am(hflights$DepTime))


# Use wday() to tabulate release by day of the week
wday(hflights$DepTime) %>% table()

# Add label = TRUE to make table more readable
wday(hflights$DepTime, label = TRUE) %>% table()

# Create column wday to hold week days
hflights$wday <- wday(hflights$DepTime, label = TRUE)

# Plot barchart of weekday by type of release
ggplot(hflights, aes(wday)) +
  geom_bar() +
  facet_wrap(~ DepTime, ncol = 1, scale = "free_y")

#-------------------------------------------------------------------------------

# Add columns for year, yday and month
hflights_daily <- hflights %>%
  mutate(
    year = year(Year),
    yday = yday(Year),
    month = month(DayofMonth, label = TRUE))

# Plot max_temp by yday for all years
ggplot(hflights_daily, aes(x = yday, y = AirTime)) +
  geom_line(aes(group = year), alpha = 0.5)

#-------------------------------------------------------------------------------

# Create day_hour, datetime rounded down to hour
hflights_hourly <- hflights %>%
  mutate(
    dep_hour = floor_date(DepTime, unit = "hour")
  )

# Count observations per hour  
hflights %>% 
  count(DepTime) 

# Find dep_hours with n != 2 
hflights %>% 
  count(DepTime) %>%
  filter(n != 2) %>% 
  arrange(desc(n))

#-------------------------------------------------------------------------------

# Examine distribtion by month
# Create new columns year, month 
hflights_hourly <- hflights_dates %>%
  mutate(
    years = year(date),
    months = month(date, label = TRUE)
  )

# Filter for moths between 8 and 22 (months)
akl_day <- hflights_hourly %>% 
  filter(months >= 8, months <= 22)


#------------------------------------------------------------------------------

# Parsing dates with `lubridate`
library(lubridate)

# Parse x 
x <- "2010 September 20th" # 2010-09-20
ymd(x)

# Parse y 
y <- "02.01.2010"  # 2010-01-02
dmy(y)

# Parse z 
z <- "Sep, 12th 2010 14:00"  # 2010-09-12T14:00
mdy_hm(z)

# Specifying an order with `parse_date_time()`
# Specify an order string to parse x
x <- "Monday June 1st 2010 at 4pm"
parse_date_time(x, orders = "ABdyIp")

# Specify order to include both "mdy" and "dmy"
two_orders <- c("October 7, 2001", "October 13, 2002", "April 13, 2003", 
                "17 April 2005", "23 April 2017")
parse_date_time(two_orders, orders = c("mdy", "dmy"))

# Specify order to include "dOmY", "OmY" and "Y"
short_dates <- c("11 December 1282", "May 1372", "1253")
parse_date_time(short_dates, orders = c("dOmY", "OmY", "Y"))

#-------------------------------------------------------------------------------

library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)


# Use make_date() to combine year, month and mday 
hflights_dates  <- hflights  %>% 
  mutate(date = make_date(year = Year, month = Month, day = DayofMonth))

# Plot to check work
ggplot(hflights_dates, aes(x = date, y = DepDelay)) +
  geom_line()

#-------------------------------------------------------------------------------

# If you plot a Date on the axis of a plot, you expect the dates to be in calendar order, 
## and that's exactly what happens with plot() or ggplot().
library(ggplot2)

# Set the x axis to the date column
ggplot(hflights, aes(x = Year, y = DayofMonth)) +
  geom_line(aes(group = 1, color = factor(Month)))

# Limit the axis to between 2010-01-01 and 2014-01-01
ggplot(hflights, aes(x = Year, y = Month)) +
  geom_line(aes(group = 1, color = factor(DayofMonth))) +
  xlim(as.Date("2010-01-01"), as.Date("2014-01-01"))

# Specify breaks every ten years and labels with "%Y"
ggplot(hflights, aes(x = Year, y = Month)) +
  geom_line(aes(group = 1, color = factor(DayofMonth)))  +
  scale_x_date(date_breaks = "10 years", date_labels = "%Y")

#-------------------------------------------------------------------------------

# Outputting pretty dates and times
# Create a stamp based on April 04 2019
D <- ymd("2019-04-04") - days(1:5)
stamp("Created on Sunday, Jan 1, 1999 3:34 pm")(D)

# Print date_stamp
date_stamp

#-------------------------------------------------------------------------------

# More on importing and exporting datetimes
# Fast parsing with `fasttime`
# The fasttime package provides a single function fastPOSIXct()
## designed to read in datetimes formatted according to ISO 8601. 
## Because it only reads in one format, and doesn't have to guess a format, it is really fast!

library(fasttime)
library(microbenchmark)
# The arguments to microbenchmark() are just R expressions that you want to time. 
# Make sure you match up the names of these arguments to the parsing functions.


# Examine structure of dates
str(hflights_dates)

# Use fastPOSIXct() to parse dates
fastPOSIXct(hflights_dates$date) %>% str()

# Compare speed of fastPOSIXct() to ymd_hms()
microbenchmark(
  ymd_hms = ymd_hms(hflights_dates),
  fasttime = fastPOSIXct(hflights_dates),
  times = 20)


# Head of dates
head(hflights_dates$date)

# Parse dates with fast_strptime
fast_strptime(hflights_dates$date, 
              format = "%Y-%m-%dT%H:%M:%SZ") %>% str()

# Comparse speed to ymd_hms() and fasttime
microbenchmark(
  ymd_hms = ymd_hms(hflights_dates$date),
  fasttime = fastPOSIXct(hflights_dates$date),
  fast_strptime = fast_strptime(hflights_dates$date, 
                                format = "%Y-%m-%dT%H:%M:%SZ"),
  times = 20)
