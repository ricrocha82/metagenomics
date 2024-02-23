## Code to calculate base pairs and read count for each sequence (output = table in txt format)

# conda activate r
# cd /fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/2.clean_reads

library(pacman)
p_load(Biostrings, tidyverse, vroom, here)

print(paste0("the output will be safe in the path: ", here()))

# fasta_path <- "/fs/project/PAS1117/ricardo/metaG/project1/2.clean_reads/"

count_fa <- function(fasta_path){
    
        print("getting sequence")
    fq <- readDNAStringSet(fasta_path, format='FASTQ')

            # get the numbers
            seq_number <- basename(fasta_path) %>% str_remove("_[^_]+$")
            library <- basename(fasta_path) %>% str_remove("_R[0-9]_[^_]+$")
            read_count <- length(fq)
            print("calculating bp numbers")
            bp_count <- sum(letterFrequency(fq, letters="ACGT"))

            #make a tibble
            df <- tibble(Sequence = seq_number, Library = library, read_count = read_count, bp_count = bp_count)

            print(paste0("done for: ", seq_number))

            return(df)

}

print("running function")
df_numbers <- list.files(here("ricardo/metaG/project1/2.clean_reads"), full.names = T) %>% map_df(count_fa)

vroom_write(df_numbers , here("ricardo/metaG/project1/metaG_read_and_bp_numbers.txt"))


# seqfu bases --header "fastq.gz"
