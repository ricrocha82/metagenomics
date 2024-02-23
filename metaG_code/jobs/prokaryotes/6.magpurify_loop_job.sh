#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=6.magpurify_loop_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=24
#SBATCH --error=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/project/PAS1117/ricardo/metaG/project1/code/jobs/%x_%j.out

source ~/miniconda3/bin/activate

conda activate mag_purify 

export MAGPURIFYDB=/fs/project/PAS1117/ricardo/mag_purify/MAGpurify-db-v1.0

       # make a directory
         mkdir 6.mag_purify 6.mag_purify/cleaned_bins/

          
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        
            echo "On sample: $prefix"

            # Calculate the number of bins
            num_bins=$(ls -1 "${directory}/5.binning/${prefix}"*.fa | wc -l)

            echo "You have $num_bins bins in the sample $prefix"
            
            # Iterate over the bins
            for ((i=1; i<=num_bins; i++))
            do
            
                    # Generate the input and output filenames for each iteration
                    bin="$directory"/5.binning/${prefix}.${i}.fa
                    output="$directory"/6.mag_purify/${prefix}.${i}_output

                    # run MAG Purify
                    magpurify phylo-markers $bin $output
                    magpurify clade-markers $bin $output
                    magpurify tetra-freq $bin $output 
                    magpurify gc-content $bin $output
                    magpurify known-contam $bin $output 
                    magpurify clean-bin $bin $output 6.mag_purify/cleaned_bins/${prefix}.${i}_cleaned.fasta 

            # magpurify phylo-markers 5.binning/HP01_ATR_MHB_SM_S14.1.fa 6.mag_purify/HP01_ATR_MHB_SM_S14_test
            # magpurify clean-bin 5.binning/HP01_ATR_MHB_SM_S14.1.fa 6.mag_purify/test 6.mag_purify/test_cleaned.fna

            done
        
        done

echo "job is done"


