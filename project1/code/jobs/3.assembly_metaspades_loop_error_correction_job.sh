#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=assembly_project1
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate assembly  

       # make a directory
        mkdir 3.assembly_error_corrected_reads

        NUM_THREADS=$SLURM_NTASKS
        
      
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1/

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
     
                R1="$directory"/2.clean_reads/${prefix}_R1_clean.fastq.gz
                R2="$directory"/2.clean_reads/${prefix}_R2_clean.fastq.gz

                out1="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
                out2="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz


            metaspades.py -1 $R1 -2 $R2 \
            -o "$directory"/3.assembly_error_corrected_reads_${prefix} -t $NUM_THREADS -m 500 \
            --only-error-correction

        # change names
        mv "$directory"/3.assembly_error_corrected_reads_${prefix}/corrected/${prefix}_R1_*.fastq.gz \
			$out1

        mv "$directory"/3.assembly_error_corrected_reads_${prefix}/corrected/${prefix}_R2_*.fastq.gz \
			$out2
        

        done

echo "job is done"

