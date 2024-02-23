#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=4.mapping_minimap2_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out


NUM_THREADS=$SLURM_NTASKS

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
            /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -t 10 -N 5 -ax sr $prefix\.mmi $R1s $R2s | samtools view -\@10 -Sb - > $outbam


        done

echo "job is done"