#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=1c.virus_detection_job-genomad.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

source ~/miniconda3/bin/activate

conda activate genomad

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1
genomad_db=/fs/ess/PAS1117/ricardo/genomad_db

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/genomad


# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
        out="$directory"/virus/1.virus_detection/genomad/genomad-${prefix}

    genomad end-to-end --cleanup --splits 8 $scaffold_file $out $genomad_db

    # move outputs to a new folder for filtering step
    out_1=$out/${prefix}_gt1.5kb_scaffolds_summary/
    cp $out_1/${prefix}_gt1.5kb_scaffolds_virus_summary.tsv "$directory"/virus/1.virus_detection/genomad/${prefix}_virus_summary.tsv &
        
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