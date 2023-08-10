#!/bin/bash

#conda activate assembly   

       # make a directory
        mkdir 3.assembly_error_corrected_reads

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

                out1="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_trimmed.fastq.gz
                out2="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_trimmed.fastq.gz

            metaspades.py -1 $R1 -2 $R2 \
            -o /3.spades_assembly_${prefix} --threads $NUM_THREADS \
            --careful --only-assembler

        # rename files
           mv /spades_assembly_${prefix}/contigs.fasta ../spades_assembly/${prefix}_spades_contigs.fasta 


        done