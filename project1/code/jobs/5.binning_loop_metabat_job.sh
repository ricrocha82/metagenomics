#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=binning_project1
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate binning  


       # make a directory
        mkdir 5.binning

       
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
        for file in "$directory"/5.binning/*fa
        do
            bin_name=$(basename ${file} .fa)
            sample=$(echo "$bin_name" | awk '{sub(/\.[0-9]+$/, "")} 1')
            grep ">" ${file} | sed 's/>//g' | sed "s/$/\t${bin_name}/g" >> 5.binning/metabat_associations_${sample}.txt

        done


echo "job is done"

name="HP01_ATR_MHB_SM_S14.36"
newname=$(echo "$name" | awk '{sub(/\.[0-9]+$/, "")} 1')
echo "$newname"