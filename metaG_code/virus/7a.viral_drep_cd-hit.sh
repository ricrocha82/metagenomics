#!/bin/bash

NUM_THREADS=24

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

# outputs
in_contigs=$directory/virus/Batch1_final_viral_contigs.fasta
out_fast=$directory/virus/Batch1_final_vOTUs.fasta

# cluter similar contigs (95% identity, 85% coverage)
/fs/project/PAS1117/bioinformatic_tools/cd-hit-v4.6.8-2017-0621/cd-hit-est -T $NUM_THREADS -M 60000 -i $in_contigs -c 0.95 -aS 0.85 -o $out_fast


