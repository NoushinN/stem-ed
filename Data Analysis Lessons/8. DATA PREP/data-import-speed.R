
# compare multiple packages speed in reading a zipped file
library(vroom)
library(feather)
library(here)

df <- iris

# write with vroom
vroom_write(df, "test.csv.gz", delim = ",")

# read with vroom
iris_vroom<- vroom("test.csv.gz", delim = ",")

# write with feather
write_feather(df, "test.feather")

# read with feather
iris_feather <- read_feather("test.feather")


colnms <- colnames(df)
iris_feather <- read_feather("test.feather", columns = colnms)
