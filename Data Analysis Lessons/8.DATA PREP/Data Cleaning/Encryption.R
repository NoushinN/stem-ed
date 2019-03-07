# File Encryption
# load library dependencies
remotes::install_github("ropensci/cyphr", upgrade = FALSE)
library(here)

# To do anything we first need a key:
key <- cyphr::key_sodium(sodium::keygen())

# load and encrypt file
here("Family csv")
cyphr::encrypt_file("2004_Family_Table_19_New_LIM.csv", key, "2004_FAM_Table_19.encrypted.csv")

# the file is encripted now
# let's decrypt to test
cyphr::decrypt_file("2004_FAM_Table_19.encrypted.csv", key, "2004_FAM_Table_19.clear.csv")

# -----------------------------------------------------------------------------

# File Compression
# # load library dependencies
library(zip)

# Read the CSV file names from working directory
Zip_Files <- list.files(path = getwd(), pattern = ".csv$")

zip::zip(zipfile = "TestZip", files = Zip_Files)


