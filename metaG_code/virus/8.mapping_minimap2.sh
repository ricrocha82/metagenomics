#!/bin/bash

# A simple loop to serially map all samples.
# referenced from http://merenlab.org/tutorials/assembly_and_mapping/

# how many threads should each mapping task use?

conda activate mapping  

NUM_THREADS=24

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

# make a directory
mkdir "$directory"/virus/2.virus_mapping

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

    # contigs
    R1s="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
    R2s="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

    scaffold_file="$directory"/virus/Batch1_final_vOTUs.fasta
    index="$directory"/virus/Batch1_final_vOTUs.mmi

    outbam="$directory"/2.virus_mapping/${prefix}_vs_batch1vOTUs_sorted.bam

    echo "indexing"
    # indexing
    /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -d $index $scaffold_file
    echo "alignment"
    # alignment
    /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -t 10 -N 5 -ax sr $index $R1s $R2s | samtools sort -@ $NUM_THREADS -o $outbam
    # index
    samtools index -@ $NUM_THREADS $outbam

    done

