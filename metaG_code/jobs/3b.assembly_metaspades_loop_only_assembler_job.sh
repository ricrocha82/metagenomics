#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=3b.assembly_only_assembler.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=28
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate assembly  


NUM_THREADS=24

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

        # make a directory
mkdir "$directory"/3.assembly
mkdir "$directory"/3.assembly_output

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
      
                R1="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
                R2="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz

            metaspades.py -1 $R1 -2 $R2 \
            -o 3.assembly_output/${prefix} --threads $NUM_THREADS \
            -m 140 \
            --careful --only-assembler

        # rename files
           mv  "$directory"/3.assembly_output/${prefix}/contigs.fasta  "$directory"/3.assembly/${prefix}_spades_contigs.fasta
           mv  "$directory"/3.assembly_output/${prefix}/scaffolds.fasta  "$directory"/3.assembly/${prefix}_spades_scaffolds.fasta  &
        
        # parallel 
        N=6

        # allow to execute up to $N jobs in parallel
        if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        # now there are $N jobs already running, so wait here for any job
        # to be finished so there is a place to start next one.
        wait -n
        fi
        
        done

# no more jobs to be started but wait for pending jobs
# (all need to be finished)
wait

echo "job is done"

