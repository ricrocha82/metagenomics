#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=deinterleave_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out

# new dir on the Working directory
cd /fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot
mkdir /fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/deinterleaved

# Deinterleave each compressed file and save to output directory
for file in /fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/raw_reads/*
do
        echo $file
        out1=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/deinterleaved/$(basename ${file%.fastq.gz})_R1.fastq.gz
        out2=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/deinterleaved/$(basename ${file%.fastq.gz})_R2.fastq.gz
        pigz --best --processes $SLURM_NTASKS -dc $file | bash /fs/project/PAS1117/ricardo/metaG/code/deinterleave_fastq.sh $out1 $out2 compress
done