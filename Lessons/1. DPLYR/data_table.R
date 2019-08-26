###DEMO for data.tables in R###
# Lessons are adapted and organized by Noushin Nabavi, PhD. (Adapted from DataCamp)

# Load data.table
library(data.table)
library(bikeshare14)

# Create the data.table X
X <- data.table(id = c("a", "b", "c"), value = c(0.5, 1.0, 1.5))

# View X
X

# Get number of columns in batrips
batrips <- as.data.table(batrips)
col_number <- ncol(batrips)

# Print the first 8 rows
head(batrips, 8)

# Print the last 8 rows
tail(batrips, 8)

# Print the structure of batrips
str(batrips)

# Filter third row
row_3 <- batrips[3]
row_3

# Filter rows 1 through 2
rows_1_2 <- batrips[1:2]
rows_1_2

# Filter the 1st, 6th and 10th rows
rows_1_6_10 <- batrips[c(1, 6, 10)]
rows_1_6_10

# Select all rows except the first two
not_first_two <- batrips[-(1:2)]
not_first_two

# Select all rows except 1 through 5 and 10 through 15
exclude_some <- batrips[-c(1:5, 10:15)]
exclude_some

# Select all rows except the first and last
not_first_last <- batrips[-c(1, .N)] # Or batrips[-c(1, nrow(batrips))]
not_first_last


# Filter all rows where start_station is "Market at 10th"
trips_mlk <- batrips[start_station == "Market at 10th"]
trips_mlk

# Filter all rows where start_station is "MLK Library" AND duration > 1600
trips_mlk_1600 <- batrips[start_station == "MLK Library" & duration > 1600]
trips_mlk_1600

# Filter all rows where `subscription_type` is not `"Subscriber"` 
customers <- batrips[subscription_type != "Subscriber"]
customers

# Filter all rows where start_station is "Ryland Park" AND subscription_type is not "Customer"
ryland_park_subscribers <- batrips[start_station == "Ryland Park" & subscription_type != "Customer"]
ryland_park_subscribers

#------------------------------------------------------------------------------

# Filter all rows where end_station contains "Market"
any_markets <- batrips[end_station %like% "Market"]
any_markets

# Filter all rows where trip_id is 588841, 139560, or 139562
filter_trip_ids <- batrips[trip_id %in% c(588841, 139560, 139562)]
filter_trip_ids

# Filter all rows where duration is between [5000, 6000]
duration_5k_6k <- batrips[duration %between% c(5000, 6000)]
duration_5k_6k

# Filter all rows with specific start stations
two_stations <- batrips[start_station %chin% c("San Francisco City Hall", "Embarcadero at Sansome")]
two_stations

#------------------------------------------------------------------------------

# Selecting columns from a data.table
# Select bike_id and trip_id using a character vector
df_way <- batrips[, c("bike_id", "trip_id")]
df_way

# Select start_station and end_station cols without a character vector
dt_way <- batrips[, .(start_station, end_station)]
dt_way

# Deselect start_terminal and end_terminal columns
drop_terminal_cols <- batrips[, !c("start_terminal", "end_terminal")]
drop_terminal_cols


# Calculate median duration using the j argument
median_duration <- batrips[, median(duration)]
median_duration

# Get median duration after filtering
median_duration_filter <- batrips[end_station == "Market at 10th" & subscription_type == "Subscriber", median(duration)]
median_duration_filter

# Compute duration of all trips
trip_duration <- batrips[, difftime(end_date, start_date, units = "min")]
head(trip_duration)

# Have the column mean_durn
mean_duration <- batrips[, .(mean_durn = mean(duration))]
mean_duration

# Get the min and max duration values
min_max_duration <- batrips[, .(min(duration), max(duration))]
min_max_duration

# Calculate the number of unique values
other_stats <- batrips[, .(mean_duration = mean(duration), 
                           last_ride = max(end_date))]
other_stats

duration_stats <- batrips[start_station == "Townsend at 7th" & duration < 500, 
                          .(min_dur = min(duration), 
                            max_dur = max(duration))]
duration_stats

# Plot the histogram of duration based on conditions
batrips[start_station == "Townsend at 7th" & duration < 500, hist(duration)]

#------------------------------------------------------------------------------

# Computations by groups
# Compute the mean duration for every start_station
mean_start_stn <- batrips[, .(mean_duration = mean(duration)), by = start_station]
mean_start_stn

# Compute the mean duration for every start and end station
mean_station <- batrips[, .(mean_duration = mean(duration)), by = .(start_station, end_station)]
mean_station


# Compute the mean duration grouped by start_station and month
mean_start_station <- batrips[, .(mean_duration = mean(duration)), by = .(start_station, month(start_date))]
mean_start_station

# Compute mean of duration and total trips grouped by start and end stations
aggregate_mean_trips <- batrips[, .(mean_duration = mean(duration), 
                                    total_trips = .N), 
                                by = .(start_station, end_station)]
aggregate_mean_trips

# Compute min and max duration grouped by start station, end station, and month
aggregate_min_max <- batrips[, .(min_duration = min(duration), 
                                 max_duration = max(duration)), 
                             by = .(start_station, end_station, 
                                    month(start_date))]
aggregate_min_max


# Chaining data.table expressions
# Compute the total trips grouped by start_station and end_station
trips_dec <- batrips[, .N, by = .(start_station, 
                                  end_station)]
trips_dec


# Arrange the total trips grouped by start_station and end_station in decreasing order
trips_dec <- batrips[, .N, by = .(start_station, 
                                  end_station)][order(-N)]
trips_dec


# Top five most popular destinations
top_5 <- batrips[, .N, by = end_station][order(-N)][1:5]
top_5

# Compute most popular end station for every start station
popular_end_station <- trips_dec[, .(end_station = end_station[1]), 
                                 by = start_station]
popular_end_station

# Find the first and last ride for each start_station
first_last <- batrips[order(start_date), 
                      .(start_date = start_date[c(1, .N)]), 
                      by = start_station]
first_last

# Using .SD (I)
relevant_cols <- c("start_station", "end_station", 
                   "start_date", "end_date", "duration")

# Find the row corresponding to the shortest trip per month
shortest <- batrips[, .SD[which.min(duration)], 
                    by = month(start_date), 
                    .SDcols = relevant_cols]
shortest

# Using .SD (II)
# Find the total number of unique start stations and zip codes per month
unique_station_month <- batrips[, lapply(.SD, uniqueN), 
                                by = month(start_date), 
                                .SDcols = c("start_station", "zip_code")]
unique_station_month

#------------------------------------------------------------------------------

# Adding and updating columns by reference
# Add a new column, duration_hour
batrips[, duration_hour := duration / 3600]

# Print batrips
head(batrips, 2)

# Fix/edit spelling in the second row of start_station
batrips[2, start_station := "San Francisco City Hall 2"]

# Replace negative duration values with NA
batrips[duration < 0, duration := NA]

# Add a new column equal to total trips for every start station
batrips[, trips_N := .N, by = start_station]

# Add new column for every start_station and end_station
batrips[, duration_mean := mean(duration), by = .(start_station, end_station)]

# Calculate the mean duration for each month
batrips[, mean_dur := mean(duration, na.rm = TRUE), 
            by = month(start_date)]

# Replace NA values in duration with the mean value of duration for that month
batrips[, mean_dur := mean(duration, na.rm = TRUE), 
            by = month(start_date)][is.na(duration), 
                                    duration := mean_dur]

# Delete the mean_dur column by reference
batrips[, mean_dur := mean(duration, na.rm = TRUE), 
            by = month(start_date)][is.na(duration), 
                                    duration := mean_dur][, mean_dur := NULL]

# Add columns using the LHS := RHS form
# LHS := RHS form. In the LHS, you specify column names as a character vector and in the RHS, you specify values/expressions to be added inside list() (or the alias, .()).
batrips[, c("mean_duration", 
            "median_duration") := .(mean(duration), median(duration)), 
        by = start_station]

# Add columns using the functional form
batrips[, `:=`(mean_duration = mean(duration), 
               median_duration = median(duration)), 
        by = start_station]

# Add the mean_duration column
batrips[duration > 600, mean_duration := mean(duration), 
        by = .(start_station, end_station)]

#------------------------------------------------------------------------------
# Fread is much faster!
# Use read.csv() to import batrips
system.time(read.csv("batrips.csv"))

# Use fread() to import batrips
system.time(fread("batrips.csv"))

# Import using read.csv()
csv_file <- read.csv("sample.csv", fill = NA, quote = "", 
                     stringsAsFactors = FALSE, strip.white = TRUE, 
                     header = TRUE)
csv_file

# Import using fread()
csv_file <- fread("sample.csv")
csv_file

# Check the class of id column
class(csv_file$id)

# Import using read.csv with defaults
str(csv_file)

# Select "id" and "val" columns
select_columns <- fread("sample.csv", select = c("id", "val"))
select_columns

# Drop the "val" column
drop_column <- fread(url, drop = "val")
drop_column

# Import the file while avoiding the warning
only_data <- fread("sample.csv", nrows = 3)
only_data

# Import only the metadata
only_metadata <- fread("sample.csv", skip = 7)
only_metadata

# Import using read.csv
base_r <- read.csv("sample.csv", 
                   colClasses = c(rep("factor", 4), 
                                  "character", "integer", 
                                  rep("numeric", 4)))
str(base_r)

# Import using fread
import_fread <- fread("sample.csv", 
                      colClasses = list(factor = 1:4, numeric = 7:10))
str(import_fread)

# Import the file correctly,  use the fill argument to ensure all rows are imported correctly
correct <- fread("sample.csv", fill = TRUE)
correct

# Import the file using na.strings
# The missing values are encoded as "##". Note that fread() handles an empty field ,, by default as NA
missing_values <- fread("sample.csv", na.strings = "##") 
missing_values

# Write dt to fwrite.txt
fwrite(dt, "fwrite.txt")

# Import the file using readLines()
readLines("fwrite.txt")

# Import the file using fread()
fread("fwrite.txt")

# Write batrips_dates to file using "ISO" format
fwrite(batrips_dates, "iso.txt", dateTimeAs = "ISO")

# Import the file back
iso <- fread("iso.txt")
iso

# Write batrips_dates to file using "squash" format
fwrite(batrips_dates, "squash.txt", dateTimeAs = "squash")

# Import the file back
squash <- fread("squash.txt")
squash

# Write batrips_dates to file using "epoch" format
fwrite(batrips_dates, "epoch.txt", dateTimeAs = "epoch")

# Import the file back
epoch <- fread("epoch.txt")
epoch

# Use write.table() to write batrips
system.time(write.table(batrips, "base-r.txt"))

# Use fwrite() to write batrips
system.time(fwrite(batrips, "data-table.txt"))




