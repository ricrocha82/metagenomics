#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=3.assembly_metaspades_loop_error_correction_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=28
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate assembly  

NUM_THREADS=$SLURM_NTASKS


samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

# make a directory
mkdir "$directory"/3.assembly_error_corrected_reads
mkdir "$directory"/3.assembly_error_corrected_reads_output

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
            -o "$directory"/3.assembly_error_corrected_reads_output/${prefix} -t $NUM_THREADS -m 500 \
            --only-error-correction

        # change names
        mv "$directory"/3.assembly_error_corrected_reads_output/${prefix}/corrected/${prefix}_R1_*.fastq.gz \
			$out1

        mv "$directory"/3.assembly_error_corrected_reads_output/${prefix}/corrected/${prefix}_R2_*.fastq.gz \
			$out2 &
            
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

