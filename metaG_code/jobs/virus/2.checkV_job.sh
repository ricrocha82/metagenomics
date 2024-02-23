#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=2.checkV.sh
#SBATCH --time=20:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --mem=140gb
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

source ~/miniconda3/bin/activate

conda activate checkv

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/checkv

scaffold_file="$directory"/virus/1.virus_detection/combined/batch1_putative_viral_contigs.fasta
out_directory="$directory"/virus/1.virus_detection/checkv

checkv end_to_end $scaffold_file $out_directory -t $NUM_THREADS -d ~/miniconda3/envs/checkv/checkv-db-v1.5

cat $out_director/proviruses.fna $out_director/viruses.fna > $out_director/combined.fna

echo "job is done"