#!/usr/bin/Rscript

pacman::p_load(dplyr, vroom, tidyr) 

samples = '/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
path = "/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

# outputs
out_table = paste0(path, '/virus/Batch1_final_viral_contigs_VS2_GENOMAD_VIBRANT.txt')
out_fast = paste0(path, '/virus/Batch1_final_viral_contigs.fasta')

# inputs
input_table = paste0(path, '/virus/1.virus_detection/combined/batch1_putative_viral_contigs.txt')
input_table_checkv = paste0(path, '/virus/1.virus_detection/checkv/quality_summary.tsv')

# get the tables
virus_id_df = vroom(input_table)
check_v_df = vroom(input_table_checkv) %>% rename(contig = contig_id)
# join both datasets
full_df <- virus_id_df %>% full_join(check_v_df, by = "contig")
# unique(full_df$max_score_group)
# only ssDNA
ssdna_df <- full_df %>% 
                filter(max_score_group == "ssDNA") %>%
                filter(host_genes == 0, 
                        max_score >=0.9 | virus_score >= 0.9) %>%
                filter(grepl("Viruses", taxonomy))

# dsDNA
dsDNA_df <- full_df %>% 
                filter(max_score_group == "dsDNAphage") %>%
                filter(length > 10000,
                        host_genes == 0, 
                        max_score >=0.9 | virus_score >= 0.9,
                        hallmark >=2 | n_hallmarks >=2) %>%
                filter(grepl("Viruses", taxonomy))

# filtered df
filt_df <- ssdna_df %>% 
                bind_rows(dsDNA_df) %>%
                select(contig, max_score_group, checkv_quality, miuvig_quality, completeness, contamination, taxonomy)

# get contig/scaffold names
contig_filt <- filt_df %>% select(contig)

# save as txt
vroom_write(filt_df , out_table)
vroom_write(contig_filt , paste0(path, '/virus/final_viral_contigs.txt'), col_names = FALSE)
