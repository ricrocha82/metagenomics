#!/usr/bin/sh

for sample in $(cat samples)
do

    echo "On sample: $sample"
    
    cutadapt -a TTCCGGTTGATCCYGCCGGA...AGCMGCCGCGGTAATWC \
    -A GWATTACCGCGGCKGCT...TCCGGCRGGATCAACCGGAA \
    --discard-untrimmed \
    -m 10\
    -o ${sample}_R1_trimmed.fq.gz -p ${sample}_R2_trimmed.fq.gz \
    ${sample}_L001_R1_001.fastq.gz ${sample}_L001_R2_001.fastq.gz \
    >> cutadapt_primer_trimming_stats.txt 2>&1

done


# check if is excutable
# ls -lth ~/R/storm_bay/code/dada2/
# if it's not, type:
# chmod +x ~/R/storm_bay/code/dada2/for_loop_trimming_cutadapt.bash

# run 
# bash ~/R/storm_bay/code/dada2/for_loop_trimming_cutadapt.bash