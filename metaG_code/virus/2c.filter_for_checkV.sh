#!/usr/bin/bash

#  conda activate seqkit

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection
directory_scaffolds=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

        df_combined="$directory"/combined/${prefix}_VS2_GENOMAD_VIBRANT.txt
        out_df_filtered="$directory"/combined/${prefix}_contigs.txt
        to_filter="$directory_scaffolds"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta
        out="$directory"/combined/${prefix}_VS2_GENOMAD_VIBRANT.fasta

        # -F'\t' for TSV files
        awk '{ if (($2 >= 0.5) && ($12 == 1) && ($9 >= 0.7)) { print $1}}' $df_combined > $out_df_filtered

        seqkit grep -nrif $out_df_filtered $to_filter -o $out


done