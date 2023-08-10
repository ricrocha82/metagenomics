#!/bin/bash

#conda activate assembly   

       # make a directory
        mkdir 3.assembly_error_corrected_reads

        NUM_THREADS=24
        
        samples=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
      
                R1="$directory"/2.trimm/${prefix}_R1_trimmed.fastq.gz
                R2="$directory"/2.trimm/${prefix}_R2_trimmed.fastq.gz

                out1="$directory"/3.assembly_error_corrected_reads/${prefix}_R1_QC_err.fastq.gz
                out2="$directory"/3.assembly_error_corrected_reads/${prefix}_R2_QC_err.fastq.gz


            metaspades.py -1 $R1 -2 $R2 \
            -o "$directory"/3.assembly_error_corrected_reads_${prefix} -t $NUM_THREADS -m 500 \
            --only-error-correction

        # change names
        mv "$directory"/3.assembly_error_corrected_reads_${prefix}/corrected/${prefix}_1_paired_trimmed.fq.00.0_0.cor.fastq.gz \
			$out1

        mv "$directory"/3.assembly_error_corrected_reads_${prefix}/corrected/${prefix}_2_paired_trimmed.fq.00.0_0.cor.fastq.gz \
			$out2
        

        done

#conda deactivate