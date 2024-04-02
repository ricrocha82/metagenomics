#!/usr/bin/bash

source ~/miniconda3/bin/activate
conda activate seqkit

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

# outputs
filt_contigs=$directory/virus/final_viral_contigs.txt
out_fast=$directory/virus/Batch1_final_viral_contigs.fasta
to_filter=$directory/virus/1.virus_detection/combined/batch1_putative_viral_contigs.fasta

# filtering 
seqkit grep -nrif $filt_contigs $to_filter -o $out_fast
