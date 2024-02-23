library(tidyverse)
library(here)

here()

# get the sample names
dir_path <- here("/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/raw_reads/")
project_name <- list.files(dir_path) %>% 
                    str_remove(".fastq.gz") %>%
                    tibble(project_name =.)


seq_names <- read_delim(here("ricardo/metaG/hiv_fecal_pilot/seq_names.txt"), col_names = F) %>% 
                select(-X1) %>% 
                rename(seq_name = X2) %>%
                mutate(sample_name = str_remove(seq_name, "_R[0-9]_[^_]+$"),
                        project_name = str_extract(sample_name, "^[0-9A-Za-z]+_[0-9A-Za-z]+")) %>%
                left_join(project_name) %>%
                mutate(old_name = paste0("/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/raw_reads/", project_name, ".fastq.gz"),
                        new_name = paste0("/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/raw_reads/", sample_name, ".fastq.gz"))

seq_names %>% view()

write.table(seq_names, file = "/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/file_names.txt", col.names = F, row.names = F,  quote = FALSE)

# rename files
from_files <- unique(seq_names$old_name)
to_files <- unique(seq_names$new_name)
file.rename(from_files,to_files)
