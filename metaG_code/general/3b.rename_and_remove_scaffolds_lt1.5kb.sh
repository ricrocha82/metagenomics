#!/usr/bin/bash

source ~/miniconda3/bin/activate

conda activate seqkit

# A loop to calculate and remove sequences containing < 1500 bp

        samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
        directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

        mkdir $directory/3.assembly_filtered

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
      
                scaffold="$directory"/3.assembly/${prefix}_spades_scaffolds.fasta
                out="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
                stat_file="$directory"/3.assembly/scaffold_stats_"$prefix".tsv

            # make a stat table
            seqkit fx2tab $scaffold -l -g -n -i -H > $stat_file
            # remove scaffolds < 1500bp and remove gaps
            seqkit seq -m 1500 -g $scaffold > $out
            # make a table with fasta stats before and after filtering
            seqkit stats $scaffold >> "$directory"/3.assembly_filtered/scaffold_stats_before_after.tsv
            seqkit stats  $out >> "$directory"/3.assembly_filtered/scaffold_stats_before_after.tsv

        done



# seqkit seq -m 1500 /fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/3.assembly/HP01_ATR_MHB_SM_S14_spades_scaffolds.fasta > /fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/3.assembly_filtered/gt1.5kb_scaffolds.fasta
