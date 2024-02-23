#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=8.mapping_minimap2_job.sh
#SBATCH --time=24:00:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=28
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/virus/%x_%j.out

source ~/miniconda3/bin/activate

conda activate mapping  

NUM_THREADS=$SLURM_NTASKS

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

# make a directory
mkdir "$directory"/virus/2.virus_mapping

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi

    echo "On sample: $prefix"

    # contigs
    R1s="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
    R2s="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

    scaffold_file="$directory"/virus/Batch1_final_vOTUs.fasta
    index="$directory"/virus/Batch1_final_vOTUs.mmi

    outbam="$directory"/virus/2.virus_mapping/${prefix}_vs_batch1vOTUs_sorted.bam

    echo "indexing"
    # indexing
    /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -d $index $scaffold_file
    echo "alignment"
    # alignment
    /fs/project/PAS1117/bioinformatic_tools/minimap2-2.24_x64-linux/minimap2 -t $NUM_THREADS -N 5 -ax sr $index $R1s $R2s | samtools sort -@ $NUM_THREADS -o $outbam
    # index
    echo "indexing"
    samtools index -@ $NUM_THREADS $outbam

    done

echo "job is done"
