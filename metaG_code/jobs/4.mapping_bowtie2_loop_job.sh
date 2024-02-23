#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=4.mapping_bowtie2_loop_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate mapping  

# how many threads should each mapping task use?

       # make a directory
        mkdir 4.mapping

        NUM_THREADS=$SLURM_NTASKS
        
        samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
        directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"

            echo "building index first"

            R1s="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
            R2s="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

            scaffold_file="$directory"/3.assembly_filtered/${prefix}_gt1.5kb_scaffolds.fasta

            outsam="$directory"/4.mapping/${prefix}.sam
            outbam="$directory"/4.mapping/${prefix}_sort.bam

        # step 2
            # create an index

            # on contigs
                # bowtie2-build "$directory"/3.assembly/${prefix}_spades_contigs.fasta "$directory"/3.assembly/bowtie2_assembly_${prefix}

            # on scaffolds
                bowtie2-build $scaffold_file "$directory"/3.assembly/bowtie2_assembly_${prefix}
    
            echo "running bowtie-2"
                
            # run bowtie (to map to the assembly)
                bowtie2 --threads $NUM_THREADS -x "$directory"/3.assembly/bowtie2_assembly_${prefix} \
                --sensitive --no-unal \
                -1 $R1s -2 $R2s \
                -S $outsam
            
            echo "converting sam to bam"
            # step 3   
                samtools sort -@ $NUM_THREADS -o $outbam $outsam
                rm $outsam #3.mapping/${sample}-RAW.bam

            done

            # mapping is done, and we no longer need bowtie2-build files
            rm "$directory"/4.mapping/*.bt2

echo "job is done"

