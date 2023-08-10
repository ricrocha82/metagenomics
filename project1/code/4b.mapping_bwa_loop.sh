#!/bin/bash

# A simple loop to serially map all samples.
# referenced from within http://merenlab.org/tutorials/assembly_and_mapping/

# how many threads should each mapping task use?

       # make a directory
        mkdir 4.mapping

        NUM_THREADS=24
        
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"

            R1s="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
            R2s="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

        # step 2

             echo "building index first"
            # create an index

            # on contigs
                bwa index "$directory"/3.assembly/${prefix}_spades_contigs.fasta

            # on scaffolds
                # bwa index "$directory"/3.assembly/${prefix}_spades_scaffolds.fasta
    
            echo "running bwa"
                
            # run bowtie (to map to the assembly)
                bwa mem \
                -t $NUM_THREADS \
                "$directory"/3.assembly/ \
                $R1s $R2s > "$directory"/4.mapping/${prefix}.sam\
                
            # step 3   
                samtools sort -@ $NUM_THREADS -o "$directory"/4.mapping/${prefix}_sort.bam "$directory"/4.mapping/${prefix}.sam
                rm "$directory"/4.mapping/${prefix}.sam #3.mapping/${sample}-RAW.bam

            done

