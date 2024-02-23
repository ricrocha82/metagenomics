#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=1d.virus_detection_job-dvf.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

source ~/miniconda3/bin/activate

conda activate dvf

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/dvf

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1


# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
        out="$directory"/virus/1.virus_detection/dvf-${prefix}

        python ~/miniconda3/envs/dvf/bin/DeepVirFinder/dvf.py -i $scaffold_file -l 1500 -o $out -c $NUM_THREADS

        # moving files to another folder for filtering step
        mv $out/${prefix}_dvfpred.txt "$directory"/virus/1.virus_detection/dvf/${prefix}_dvfpred.txt

done

echo "job is done"