#!/bin/bash

#conda activate genomad   

NUM_THREADS=24

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1
genomad_db=/fs/ess/PAS1117/ricardo/genomad_db

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/genomad-pass2

directory_checkv="$directory"/virus/1.virus_detection/checkv
out="$directory"/virus/1.virus_detection/genomad-pass2


genomad end-to-end --cleanup --splits 8 $directory_checkv/combined.fna $out $genomad_db
