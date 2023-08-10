#!/bin/bash

        cd /fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot
        mkdir 4.mapping

        NUM_THREADS=24
        
        samples=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/samples_test.txt
        directory=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
      
                R1="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
                R2="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz


# step 1
    # create an index
    bwa index -a bwtsw reference/transcripts.fasta
    bowtie2-build megahit_assembly/${prefix}_megahit_contigs.fasta megahit_assembly/bw_megahit_${prefix}
    
    echo "running bowtie-2"

    # run bowtie
    bowtie2 --threads $NUM_THREADS -x megahit_assembly/bw_megahit_${prefix} \
     --sensitive --no-unal \
     -1 $R1s -2 $R2s \
     -S MAPPING/${prefix}.sam
    
# step 3   
    samtools sort -@ $NUM_THREADS -o MAPPING/${prefix}_sort.bam MAPPING/${prefix}.sam
    rm MAPPING/${prefix}.sam #MAPPING/${sample}-RAW.bam

done

# mapping is done, and we no longer need bowtie2-build files
rm megahit_assembly/*.bt2
