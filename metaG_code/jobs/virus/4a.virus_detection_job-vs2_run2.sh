#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=4a.virus_detection_job-vs2_run2.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=28
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
# mkdir "$directory"/virus/1.virus_detection/vs2


directory_checkv="$directory"/virus/1.virus_detection/checkv
out="$directory"/virus/1.virus_detection/vs2_pass2


singularity run /fs/project/PAS1117/modules/singularity/VirSorter2-2.2.3.sif run --seqname-suffix-off --viral-gene-enrich-off --provirus-off --prep-for-dramv -i $directory_checkv/combined.fna \
                                                                                        -w $out \
                                                                                        --include-groups dsDNAphage,ssDNA \
                                                                                        --min-length 5000 \
                                                                                        --min-score 0.5 \
                                                                                        -j $NUM_THREADS all

# # moving files to another folder for filtering step
# mv $out/final-viral-score.tsv "$directory"/virus/1.virus_detection/vs2/${prefix}_final-viral-score.tsv
# mv $out/final-viral-boundary.tsv "$directory"/virus/1.virus_detection/vs2/${prefix}_final-viral-boundary.tsv
# mv $out/final-viral-combined.fa "$directory"/virus/1.virus_detection/vs2/${prefix}_final-viral-combined.fa

echo "job is done"