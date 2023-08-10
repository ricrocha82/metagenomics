#!/bin/bash

# how many threads should each mapping task use?
mkdir 1.qc
mkdir 1.multiqc

samples=/fs/project/PAS1117/ricardo/metaG/training/data/samples.txt
NUM_THREADS=$SLURM_NTASKS

# step 1
# for prefix in `awk '{print $1}' samples.txt`
# do
#     echo "on sample: $prefix"

#     R1s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R1_001.fastq.gz
#     R2s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R2_001.fastq.gz
    directory=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/deinterleaved

# go to the directory and

# activate env
        
        #conda activate quality_control

        ## Run FASTQC
        # fastqc [-o output dir] [-t --threads] [--(no)extract] [-f fastq|bam|sam]
        fastqc -o 1.qc -t $NUM_THREADS  "$directory"/*.fastq.gz

        # run multiqc
        multiqc 1.qc/ --outdir 1.multiqc/

        #conda deactivate

# done