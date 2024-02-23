#!/bin/bash

       # make a directory
        mkdir 9.annotation_taxonomy

          
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        
            echo "On sample: $prefix"

            # Calculate the number of bins
            num_bins=$(ls -1 "${directory}/6.mag_purify/cleaned_bins/${prefix}"*_cleaned.fasta | wc -l)

            echo "You have $num_bins bins in the sample $prefix"
            
            # Iterate over the bins
            for ((i=1; i<=num_bins; i++))
            do
            
                    # Generate the input and output filenames for each iteration
                    bin="$directory"/6.mag_purify/cleaned_bins/${prefix}.${i}_cleaned.fasta
                    output="$directory"/8.annotation_gene/${prefix}.${i}
                    prefix_prokka=$(basename $output)

                    # run PROKKA
                    
                    prokka --outdir $directory/8.annotation_gene --prefix $prefix_prokka --kingdom Bacteria --metagenome --cpus 12 $bin

                    # output Uniprot IDs of the .gff file
                    grep -o 'UniProt.*' $output/${prefix_prokka}.gff | awk -F'[:;=]' '{print $2 "\t" $6}' > $directory/8.annotation_gene/lits_uniprot_IDs/list_uniprotIDs_${prefix_prokka}.tsv

            done
        
        done