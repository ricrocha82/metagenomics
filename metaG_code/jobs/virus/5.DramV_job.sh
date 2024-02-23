#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=5.DramV_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=28
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

# create folders
# mkdir "$directory"/virus/dramv-annotate

vs2_pass2=$directory/virus/1.virus_detection/vs2_pass2
output_dir=$directory/virus/dramv-annotate
output_distill=$directory/virus/dramv-distill

# load DRAM-V
module use /fs/project/PAS1117/modulefiles
module load DRAM

# step1 - annotate
echo "annotation"
DRAM-v.py annotate -i $vs2_pass2/for-dramv/final-viral-combined-for-dramv.fa \
                    -v $vs2_pass2/for-dramv/viral-affi-contigs-for-dramv.tab \
                    -o $output_dir \
                    --skip_trnascan --threads $NUM_THREADS


# step 2 summarize anntotations
echo "summarize anotation"
DRAM-v.py distill -i $output_dir/annotations.tsv -o $output_distill

echo "job is done"