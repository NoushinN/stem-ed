
# compare multiple packages speed in reading a zipped file
library(vroom)
library(feather)
library(here)

df <- iris

# works with RStudio + default setting of Microsoft R Open 3.5.1
# works with RStudio + R3.5.3 62-bit 
# works with RStudio + R3.5.3 32-bit 
# works with R3.5.3 32-bit GUI
# but bonks through R3.5.3 62-bit GUI & Microsoft R Open 3.5.1 GUI

vroom_write(df, "test.csv.gz", delim = ",")

# bonks with RStudio + default setting of Microsoft R Open 3.5.1
# bonks with with RStudio + R3.5.3 62-bit (and the R3.5.3 62-bit GUI)
# works with RStudio + R3.5.3 32-bit (and the R3.5.3 32-bit GUI)

iris_vroom<- vroom("test.csv.gz", delim = ",")

# works with all options
write_feather(df, "test.feather")

# bonks with all options
iris_feather <- read_feather("test.feather")

# but this hack works with all options (the default behaviour is
# is meant to be read all columns)

colnms <- colnames(df)
iris_feather <- read_feather("test.feather", columns = colnms)

