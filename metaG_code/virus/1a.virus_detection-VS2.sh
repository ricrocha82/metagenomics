#!/bin/bash

#conda activate assembly   

NUM_THREADS=24

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

# make a directory
mkdir "$directory"/virus
mkdir "$directory"/virus/1.virus_detection
mkdir "$directory"/virus/1.virus_detection/vs2

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
        out="$directory"/virus/1.virus_detection/vs2/vs2-${prefix}


    singularity run /fs/project/PAS1117/modules/singularity/VirSorter2-2.2.3.sif run --keep-original-seq -i $scaffold_file \
                                                                                                    -w $out \
                                                                                                    --include-groups dsDNAphage,ssDNA \
                                                                                                    --min-length 1000 --min-score 0.5 -j $NUM_THREADS all

    # moving files to another folder for filtering step
    mv $out/final-viral-score.tsv "$directory"/virus/1.virus_detection/vs2/${prefix}_final-viral-score.tsv
    mv $out/final-viral-boundary.tsv "$directory"/virus/1.virus_detection/vs2/${prefix}_final-viral-boundary.tsv
    mv $out/final-viral-combined.fa "$directory"/virus/1.virus_detection/vs2/${prefix}_final-viral-combined.fa &
        
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




done

