#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=mapping_project1
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate mapping  

# how many threads should each mapping task use?

       # make a directory
        mkdir 4.mapping

        NUM_THREADS=$SLURM_NTASKS
        
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1

         # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"

            R1s="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
            R2s="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

            index_file="$directory"/3.assembly/${prefix}_spades_contigs.fasta
            #index_file="$directory"/3.assembly/${prefix}_spades_scaffolds.fasta

        # step 2

             echo "building index first"
            # create an index

            # on contigs
            #    bwa index $index_file

            # on scaffolds
                # bwa index $index_file
    
            echo "running bwa and samtool"
                
            # run wa and samtool (to map to the assembly)
                bwa mem \
                -t $NUM_THREADS \
                "$directory"/3.assembly/${prefix}_spades_contigs.fasta \
                $R1s $R2s | samtools sort -@ $NUM_THREADS -o "$directory"/4.mapping/${prefix}_bwa_sort.bam

                rm "$directory"/4.mapping/${prefix}.sam #3.mapping/${sample}-RAW.bam

            done


echo "job is done"

