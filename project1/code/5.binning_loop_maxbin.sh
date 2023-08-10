#!/bin/bash

# A simple loop to serially map all samples.
# referenced from within http://merenlab.org/tutorials/assembly_and_mapping/

# how many threads should each mapping task use?

       # make a directory
        mkdir 5.binning

        NUM_THREADS=24
        
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"

            echo "building index first"

            R1s=spades_error_corrected_reads/${prefix}_1_QCd_err_cor.fastq.gz
            R2s=spades_error_corrected_reads/${prefix}_2_QCd_err_cor.fastq.gz

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"

        # Wildcard to generate abundance table (function from MetBat2)
            jgi_summarize_bam_contig_depths --outputDepth 4.mapping/metabat_${prefix}.txt 4.mapping/${prefix}_sort.bam

        # run MaxBin2
        # need to use the abundance table from mmetabat2 function
            #less metabat.txt
            cut -f1,4,6,8,10 4.mapping/metabat_${prefix}.txt > 4.mapping/maxbin_${prefix}.txt
            run_MaxBin.pl -thread $NUM_THREADS -contig ${prefix}_megahit_contigs.fasta \
                            -min_contig_length 1500 \
                            -reads $R1s \
                            -reads2 $R2s \
                            -a ${directory}/4.mapping/maxbin.txt \
                            -out ${directory}/5.binning/${prefix} 

            echo "End for sample: $prefix"

        done

    # Creating contig/bin tables for DAS_tool
        for file in 5.mapping/*fasta

            bin_name=$(basename ${file} .fasta)
            grep ">" ${file} | sed 's/>//g' | sed "s/$/\t${bin_name}/g" >> 5.mapping/maxbin_associations_${file}.txt

        done
