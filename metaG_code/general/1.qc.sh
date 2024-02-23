#!/bin/bash

# activate env
conda activate quality_control

# how many threads should each mapping task use?
NUM_THREADS=28

# step 1
# for prefix in `awk '{print $1}' samples.txt`
# do
#     echo "on sample: $prefix"

#     R1s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R1_001.fastq.gz
#     R2s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R2_001.fastq.gz


directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/
samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt

# create new folders
mkdir "$directory"/1.qc
mkdir "$directory"/1.multiqc

# go to the directory and

# activate env
        
        #conda activate quality_control

        ## Run FASTQC
        # fastqc [-o output dir] [-t --threads] [--(no)extract] [-f fastq|bam|sam]
        fastqc -o "$directory"/1.qc -t $NUM_THREADS  "$directory"/data/*.fastq.gz

        # run multiqc
        multiqc "$directory"/1.qc/ --outdir "$directory"/1.multiqc/

        #conda deactivate

# done