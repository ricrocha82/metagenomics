#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=7a.viral_drep_cd-hit_job.sh
#SBATCH --time=24:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=12
#SBATCH --mem=60gb
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

# outputs
in_contigs=$directory/virus/Batch1_final_viral_contigs.fasta
out_fast=$directory/virus/Batch1_final_vOTUs.fasta

# cluter similar contigs (95% identity, 85% coverage)
/fs/project/PAS1117/bioinformatic_tools/cd-hit-v4.6.8-2017-0621/cd-hit-est -T $NUM_THREADS -M 60000 -i $in_contigs -c 0.95 -aS 0.85 -o $out_fast

echo "job is done"
