
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


#---------------------------------------------------------

# read fixed width files with vroom 

read_data <- vroom::vroom_fwf(fwf_file, 
							fwf_positions(c(1, 6, 9, 12, 20),
										  c(5, 10, 10, 15, 21),
										  str_to_lower(c("COL1", "COL2", "COL3", "COL4", "COL5"))),
						    col_types = c("ccccc")) %>%
						    mutate(COL1 = lubridate::ymd_hms(COL1)) %>%
						    write_fst("read_data.fst", compress = 10)
						    
#---------------------------------------------------------						  

# read fixed width files with readr 

read_data <- readr::read_fwf(file = fwf_file, 
							col_positions = readr::fwf_positions(c(1, 6, 9, 12, 20),
										  c(5, 10, 10, 15, 21),
										  str_to_lower(c("COL1", "COL2", "COL3", "COL4", "COL5"))),
						    col_types = c("ccccc")) %>%
						    mutate(COL1 = lubridate::ymd_hms(COL1)) %>%
						    fst::write_fst("read_data.fst", compress = 10)
						    
#---------------------------------------------------------		