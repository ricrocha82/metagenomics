# install pacman package and load the other packages
# if (!require("pacman", "BiocManager", quietly = TRUE))
#     install.packages("pacman","BiocManager")

library(pacman)  
p_load(tidyverse, dada2, arrow)

# Path to the parent directory
folder_path <- "/fs/project/PAS1117/ricardo/meta_analysis/dada2_output/3.dada2"

# List subfolders (including sub-subfolders) containing seqtab.rds files
seqtabs <- list.files(folder_path, pattern = "seqtab.nochim.rds",full.names = TRUE, recursive = TRUE)

# Read seqtab.rds files from subfolders into a list of data frames
st_list <- map(seqtabs , ~ readRDS(.x))
# gc()
print("merge sequences")
# Merge the sequence tables using reduce
merged_seq <- mergeSequenceTables(tables=seqtabs) # list of sequence tables
saveRDS(merged_seq, paste0(folder_path, "/merged_seq.RDS"))
# merged_seq <- readRDS(paste0(folder_path, "/merged_seq.RDS"))

print("remove chimera")
merged_seqtab.nochim <- removeBimeraDenovo(merged_seq, method="consensus", multithread=TRUE, verbose=TRUE)
saveRDS(merged_seqtab.nochim, paste0(folder_path, "/merged_seqtab.nochim.rds"))
# merged_seqtab.nochim <- readRDS(paste0(folder_path, "/merged_seqtab.nochim.rds"))

print("Assign taxonomy")
# Assign taxonomy
# Taxonomic reference data @ <https://benjjneb.github.io/dada2/training.html>
# 16S ----
# silva database
# refFasta.16s <- "/fs/project/PAS1117/ricardo/16S_vag/code/R/silva_nr99_v138.1_train_set.fa.gz" # updated Mar 10 ,2021
# greengenes
refFasta.16s <- '/fs/project/PAS1117/CONGO_PROJECT/Vaginal_Swabs/16S_Data/raw_reads/SCRIPTS/gg_13_8_train_set_97.fa.gz'

# BACTERIA -----
taxa_ASV_bac <- assignTaxonomy(merged_seqtab.nochim, 
                                    refFasta.16s, 
                                    minBoot = 50, 
                                    tryRC = FALSE,
                                    outputBootstraps = FALSE,
                                    taxLevels = c("Kingdom", "Phylum", "Class",
                                                    "Order", "Family", "Genus", "Species"),
                                    multithread = TRUE, 
                                    verbose = TRUE)

# write.csv(taxa_ASV_bac, paste0(folder_path,'/tax_bac_meta_v3v4_seq.csv'))

# ASV abundance table
asv_bac <- t(merged_seqtab.nochim) %>% 
              as.data.frame() %>% 
              rownames_to_column("seq")  %>% 
              as_tibble() 
            #   rename_with(~ sample.names[which(sample.extr == .x)], .cols = sample.extr) 

###### Wrangling data #########

# asv_bac <- vroom::vroom(paste0(folder_path,'/ASV_bac_v3v4_seq.csv'))
asv_bac <- asv_bac %>% rename(seq = 1)

#taxa_ASV_bac <- vroom::vroom(paste0(folder_path,'/tax_bac_meta_v3v4_seq.csv'))
taxa_ASV_bac <- taxa_ASV_bac %>% rename(seq = 1)

bac_df <- asv_bac %>% left_join(taxa_ASV_bac)

# filter non-bacteria
bac_df <- bac_df %>% filter(Kingdom == "k__Bacteria")

taxa_ASV_bac  %>% count(Class) %>% view()
# remove Phylum NAs
bac_df <- bac_df %>% drop_na(Phylum)
bac_df <- bac_df %>%
            mutate(id = str_c('asv_',1:nrow(.))) %>%
            relocate(id) 

# remove Mitochondria
bac_df <- bac_df %>% filter(!str_detect(Family, "mitochondria"))

# save as parquet
write_parquet(bac_df, paste0(folder_path,'/bac_df_v3v4.parquet'))

# get sample names
bac_df <- read_parquet(paste0(folder_path,'/bac_df_v3v4.parquet')) %>% as_tibble()

sample_names <- bac_df %>% select(-c(id, seq)) %>% colnames()

write(sample_names,  paste0(folder_path,'/sample_names.txt'))

# asv_bac %>% 
#    mutate(total = rowSums(across(where(is.numeric)))) %>%
#  # rowwise() %>% mutate(total = sum(c_across(where(is.numeric)))) %>% 
#   filter(total ==1) # 4,209 ASVs
# asv_bac %>%  mutate(total = reduce(select(., where(is.numeric)), `+`)) %>%
#   filter(total ==2) # 3,161 ASVs


print("dada2 pipeline is finished, please go to dada2 folder to check the results")