#For R  Program to read the PCCF June 2013 file

# load dependencies
library(tidyverse)
library(readr)
library(here)
library(data.table)
library(LaF)


  
#read file path and PCCF text file and parse based on character lengths
file.dat <- file.path(here("pccf-data", "pccfNat_JUN13_fccpNat.txt"))

# table specs for field names and character lengths
col.names = c("PostalCode", "FSA", "PR", "CDuid", "CSDuid", "CSDname", "CSDtype", "CCScode", 
              "SAC", "SACtype", "CTname", "ER", "DPL", "FED03uid", "POP_CNTR_RA", "POP_CNTR_RA_type",
              "DAuid", "DissBlock", "Rep_Pt_Type", "LAT", "LONG", "SLI", "PCtype", "Comm_Name", 
              "DMT", "H_DMT", "Birth_Date", "Ret_Date", "PO", "QI", "Source", "POP_CNTR_RA_SIZE_CLASS")
widths = c(6, 3, 2, 4, 7, 70, 3, 3, 3, 1, 7, 2, 4, 5, 4, 1, 8, 2, 1, 11, 13, 1, 1, 30, 1, 1, 8, 8, 1, 3, 1, 1) 

# read table using LaF library to read fixed column width txt fast

dat1 <- laf_open_fwf(filename=file.dat,
                     column_types=rep("character",32),
                     column_names=c("PostalCode", "FSA", "PR", "CDuid", "CSDuid", "CSDname", "CSDtype", "CCScode", 
                                    "SAC", "SACtype", "CTname", "ER", "DPL", "FED03uid", "POP_CNTR_RA", "POP_CNTR_RA_type",
                                    "DAuid", "DissBlock", "Rep_Pt_Type", "LAT", "LONG", "SLI", "PCtype", "Comm_Name", 
                                    "DMT", "H_DMT", "Birth_Date", "Ret_Date", "PO", "QI", "Source", "POP_CNTR_RA_SIZE_CLASS"),
                     column_widths=c(6, 3, 2, 4, 7, 70, 3, 3, 3, 1, 7, 2, 4, 5, 4, 1, 8, 2, 1, 11, 13, 1, 1, 30, 1, 1, 8, 8, 1, 3, 1, 1))

#Convert file to data.frame 
system.time(dat1 <- dat1[,]) 

#write table output
write_csv(dat1, here("pccf-data", "PCCF_2013.csv"))

# read the file back to test whether parsing works (get same rows/cols)
dat2 <- fread(here("pccf-data", "PCCF_2013.csv"))






