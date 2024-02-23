#!/bin/bash

#conda activate assembly   

NUM_THREADS=24

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

module use /fs/project/PAS1117/modulefiles

module load VIBRANT/1.2.1

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/vibrant

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
        out="$directory"/virus/1.virus_detection/vibrant/vibrant-${prefix}


    # VIBRANT_run.py -i $scaffold_file -folder $out -t $NUM_THREADS


    # move outputs to a new folder for filtering step
    out_1=$out/VIBRANT_${prefix}_gt1.5kb_scaffolds/VIBRANT_phages_${prefix}_gt1.5kb_scaffolds
    cp $out_1/${prefix}_gt1.5kb_scaffolds.phages_combined.txt "$directory"/virus/1.virus_detection/vibrant/${prefix}_phages_combined.txt &
        
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


