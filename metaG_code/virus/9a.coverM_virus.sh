#!/bin/bash

conda activate mapping  

NUM_THREADS=24

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

module load samtools/1.10 

# make a directory
mkdir "$directory"/virus/3.virus_coverm

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

    bam_file="$directory"/virus/2.virus_mapping/${prefix}_vs_batch1vOTUs_sorted.bam
    out_coverm="$directory"/virus/3.virus_coverm/${prefix}_vOTUs_coverM_0.7_results.txt

    echo "CoverM"

    /fs/project/PAS1117/bioinformatic_tools/coverm-x86_64-unknown-linux-musl-0.6.1/coverm contig \
                                                                                        -t $NUM_THREADS \
                                                                                        --bam-files $bam_file \
                                                                                        --min-read-percent-identity 0.95 \
                                                                                        --methods trimmed_mean \
                                                                                        --min-covered-fraction 0.7 > $out_coverm &

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

