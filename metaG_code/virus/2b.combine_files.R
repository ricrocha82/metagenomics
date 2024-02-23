#!/usr/bin/Rscript

pacman::p_load(tidyverse, vroom) 

samples = '/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
path = "/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection/"

samples <- vroom(samples, delim = " ", col_names = FALSE)

if(!dir.exists("/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection/combined")){
    dir.create("/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection/combined")
}else{
    print("dir /fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection/combined already exist! ")
}

for(i in samples$X1){

    # read the files
    vs2_file = list.files(paste0(path,"vs2"), recursive = T, pattern = paste0(i,"_final-viral-score.tsv"), full.names = T)
    genomad_file = list.files(paste0(path,"genomad"), recursive = T, pattern = paste0(i,"_virus_summary.tsv"), full.names = T)
    # dvf_files = list.files(paste0(path,"dvf"), recursive = T, pattern = "score.tsv", full.names = T)
    vibrant_file = list.files(paste0(path,"vibrant"), recursive = T, pattern = paste0(i,"_phages_combined.txt"), full.names = T)

    # Check if any files were found
    found_any_files <- length(vs2_file) > 0 || length(genomad_file) > 0 || length(vibrant_file) > 0

    # Combine the dataframes only if at least one type of file is found
    if (found_any_files) {
        # VS2
        if (length(vs2_file)) {
            vs2_df <- vroom(vs2_file) %>% 
                mutate(contig = str_remove(seqname, "\\|.*"), .before = 1) %>% 
                select(contig, max_score, max_score_group, hallmark, viral, cellular)
            } else {
            warning("VS2 file does not exist.")
            vs2_df <- NULL
            }

        # Genomad
        if (length(genomad_file)) {
            genomad_df <- vroom(genomad_file) %>% 
                            rename(contig = seq_name) %>%
                            select(contig, length, genetic_code, virus_score, n_hallmarks, marker_enrichment, taxonomy)
        } else {
            warning("Genomad file does not exist.")
            genomad_df <- NULL
            }

        # VIbrant
        if (length(vibrant_file)) {
            vibrant_df <- vroom(vibrant_file, delim = " ", col_names = FALSE) %>% 
                        rename(contig = X1) %>% 
                        mutate(vibrant = 1)
        } else {
            warning("Vibrant file does not exist.")
            vibrant_df <- NULL
            }

        # Combine
        # Combine
        dataframes <- list(vs2_df, genomad_df, vibrant_df)
        existing_dataframes <- Filter(Negate(is.null), dataframes)

        if (length(existing_dataframes) > 1) {
        # combine all the datasets
        combined_df <- Reduce(full_join, existing_dataframes)
        combined_df <- combined_df %>% mutate(vibrant = replace_na(vibrant, 0))
        vroom_write(combined_df, paste0(path, "combined/", i, "_VS2_GENOMAD_VIBRANT.txt"))
        } else if (length(existing_dataframes) == 1) {
        # Se apenas uma tabela existe, crie uma cópia dela como o "combined_df"
        combined_df <- existing_dataframes[[1]]
        vroom_write(combined_df, paste0(path, "combined/", i, "_VS2_GENOMAD_VIBRANT.txt"))
        } else {
        # Empty table
        warning("No files found. Cannot create combined file.")
        }

    } else {
    warning("No files found in any of the specified paths. Continuing with the next iteration.")
    }

}

