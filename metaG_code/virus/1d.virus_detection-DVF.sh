#!/bin/bash

#conda activate  dvf  

NUM_THREADS=24

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

# make a directory
# mkdir "$directory"/virus
# mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/dvf

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
        out="$directory"/virus/1.virus_detection/dvf-${prefix}

        python ~/miniconda3/envs/dvf/bin/DeepVirFinder/dvf.py -i $scaffold_file -l 1500 -o $out -c $NUM_THREADS

        # moving files to another folder for filtering step
        mv $out/${prefix}_dvfpred.txt "$directory"/virus/1.virus_detection/dvf/${prefix}_dvfpred.txt &
        
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


