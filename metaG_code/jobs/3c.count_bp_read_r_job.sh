#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=3c.count_bp_read_r_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out
     
cd /fs/project/PAS1117/ricardo/metaG/project1/2.clean_reads

source ~/miniconda3/bin/activate

conda activate r

Rscript /fs/project/PAS1117/ricardo/metaG/project1/code/3.count_reads_numb_bp.r