#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=4b.virus_detection_job-genomad_run2.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

source ~/miniconda3/bin/activate

conda activate genomad

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1
genomad_db=/fs/ess/PAS1117/ricardo/genomad_db

# make a directory
mkdir "$directory"/virus/1.virus_detection/genomad-pass2

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
directory_checkv="$directory"/virus/1.virus_detection/checkv
out="$directory"/virus/1.virus_detection/genomad-pass2


genomad end-to-end --cleanup --splits 8 $directory_checkv/combined.fna $out $genomad_db


echo "job is done"