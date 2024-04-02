#!/usr/bin/Rscript

# install pacman package and load the other packages
# if (!require("pacman", quietly = TRUE))
#     install.packages("pacman",)

pacman::p_load(data.table)

samples = '/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory = "/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

cover_m = list.files(paste0(directory,"/virus/3.virus_coverm"), full.names = T)

# get the first column
column_1 = fread(cover_m[1], select = 1)

#From each file read the file and extract Y column from  it.
result <- as.data.frame(lapply(cover_m, function(x) fread(x, select = 2)))

# combine all the files
final_cover_m = cbind(column_1, result )

# save
fwrite(final_cover_m, sep = "\t", paste0(directory, "/virus/3.virus_coverm/Batch1_vOTUs_coverM_0.7_results.txt"))
