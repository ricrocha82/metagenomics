#!/bin/bash

#conda activate assembly   

       # make a directory
        mkdir 3.assembly

        NUM_THREADS=24
        
        samples=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
      
                R1="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
                R2="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

            metaspades.py -1 $R1 -2 $R2 \
            -o 3.assembly_${prefix} --threads $NUM_THREADS \
            -m 140 \
            --careful --only-assembler

        # rename files
           mv 3.assembly_${prefix}/contigs.fasta 3.assembly/${prefix}_spades_contigs.fasta
           mv 3.assembly_${prefix}/scaffolds.fasta 3.assembly/${prefix}_spades_scaffolds.fasta 


        done