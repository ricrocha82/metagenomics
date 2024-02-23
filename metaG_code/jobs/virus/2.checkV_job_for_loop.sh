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

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        scaffold_file="$directory"/virus/1.virus_detection/combined/${prefix}_VS2_GENOMAD_VIBRANT.fasta
        out_directory="$directory"/virus/1.virus_detection/checkv/${prefix}

        checkv end_to_end $scaffold_file $out_directory -t $NUM_THREADS -d ~/miniconda3/envs/checkv/checkv-db-v1.5

        # moving files to another folder for filtering step
        mv $out/viruses.fna $out/${prefix}-viruses.fna &
        
    # parallel 
    N=6

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
    # now there are $N jobs already running, so wait here for any job
    # to be finished so there is a place to start next one.
    wait -n
    fi
        
done

# no more jobs to be started but wait for pending jobs
# (all need to be finished)
wait


echo "job is done"