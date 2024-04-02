#!/usr/bin/bash

source ~/miniconda3/bin/activate
conda activate seqkit

NUM_THREADS=24

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

length=10000

votus_fasta=$directory/virus/Batch1_final_vOTUs.fasta
fasta_out=$directory/virus/Batch1_final_vOTUs_gt10kb.fna

seqkit seq -m $length $votus_fasta > $fasta_out
