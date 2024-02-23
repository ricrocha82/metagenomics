#!/bin/bash

#conda activate checkv  

NUM_THREADS=24

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/checkv

out_directory="$directory"/virus/1.virus_detection/checkv

scaffold_file="$directory"/virus/1.virus_detection/combined/batch1_putative_viral_contigs.fasta
out="$directory"/virus/1.virus_detection/chech-v/checkv/

checkv end_to_end $scaffold_file $out_directory -t 28 -d ~/miniconda3/envs/checkv/checkv-db-v1.5

cat $out_director/proviruses.fna $out_director/viruses.fna > $out_director/combined.fna 
