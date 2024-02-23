#!/bin/bash

# A simple loop to serially map all samples.
# referenced from http://merenlab.org/tutorials/assembly_and_mapping/

# how many threads should each mapping task use?

       # make a directory
        mkdir 4.mapping

        NUM_THREADS=24
        
        samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
        directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"

            R1s="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
            R2s="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

            scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta

            outsam="$directory"/4.mapping/${prefix}.sam
            outbam="$directory"/4.mapping/${prefix}_sort.bam

            # indexing
            /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -d $prefix\.mmi $scaffold_file
            # alignment
            /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -t 10 -N 5 -ax sr $prefix\.mmi $R1s $R2s | samtools view -\@10 -Sb - > $outsam


            done

