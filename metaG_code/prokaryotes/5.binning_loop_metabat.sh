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

            assembly="$directory"/3.assembly/${prefix}_spades_contigs.fasta

        # Wildcard to generate abundance table for MetaBat2
            jgi_summarize_bam_contig_depths --outputDepth "$directory"/4.mapping/metabat_${prefix}.txt "$directory"/4.mapping/${prefix}_sort.bam

        # MetaBat2
            metabat2 -t 2 -m 1500 \
                        -i $assembly \
                        -a "$directory"/4.mapping/metabat_${prefix}.txt \
                        -o "$directory"/5.binning/${prefix}
            # runMetaBat.sh -m 1500 megahit_assembly/${prefix}_megahit_contigs.fasta MAPPING/${prefix}_sort.bam
            #                 mv final.contigs.fa.metabat-bins1500 metabat

 
            echo "End for sample: $prefix"

        done

    # Creating contig/bin tables for DAS_tool
        for file in "$directory"/5.mapping/*fa

            bin_name=$(basename ${file} .fa)
            grep ">" ${file} | sed 's/>//g' | sed "s/$/\t${bin_name}/g" >> 5.mapping/metabat_associations_${file}.txt

        done
