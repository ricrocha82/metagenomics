#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=2.filtering_bbduk_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 #SBATCH 
#SBATCH --ntasks-per-node=12
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out

# go to the folder where the files are
# cd /fs/ess/PAS1117/ricardo/metaG/metagenomics/project1

#source ~/miniconda3/bin/activate

NUM_THREADS=$SLURM_NTASKS

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1
reference=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/hg19_main_mask_ribo_animal_allplant_allfungus.fa

# make a directory
mkdir "$directory"/2.trimm "$directory"/2.trimm/bads "$directory"/2.clean_reads/

        # for loop
        for prefix in `awk '{print $1}' $samples`
        do
        if [ "$prefix" == "prefix" ]; then continue; fi

            echo "On sample: $prefix"
      
                R1="$directory"/data/${prefix}_R1.fastq.gz
                R2="$directory"/data/${prefix}_R2.fastq.gz

                out1="$directory"/2.trimm/${prefix}_R1
                out2="$directory"/2.trimm/${prefix}_R2

                outm1="$directory"/2.trimm/bads/${prefix}_R1
                outm2="$directory"/2.trimm/bads/${prefix}_R2

            echo "Removing adapters"

            # step 1: Remove Adapters and quality filtering *at the same time*
            /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
                        -Xmx1G threads=$NUM_THREADS \
                        overwrite=t \
                        in1=$R1 in2=$R2 \
                        out1=${out1}_adapters.fastq.gz out2=${out2}_adapters.fastq.gz \
                        outm=${outm1}_adapters_bad.fastq.gz outm2=${outm2}_adapters_bad.fastq.gz \
                        ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/adapters.fa \
                        ktrim=r k=23 mink=11 hdist=1 \
                        refstats="$directory"/2.trimm/${prefix}_adapterTrimming.stats statscolumns=5


             echo "Removing spikesin"
            # step 2: remove Illumina spikein

            /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
                        -Xmx1G threads=$NUM_THREADS \
                        overwrite=t \
                        in1=${out1}_adapters.fastq.gz in2=${out2}_adapters.fastq.gz \
                        out1=${out1}_phix.fastq.gz out2=${out2}_phix.fastq.gz \
                        outm=${outm1}_phix_bad.fastq.gz outm2=${outm2}_phix_bad.fastq.gz \
                        ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/adapters.fa \
                        ktrim=r k=23 mink=11 hdist=1 \
                        refstats="$directory"/2.trimm/${prefix}_PhiXFiltering.stats statscolumns=5 \

            echo "Filtering"
            # step 3: QC

            /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
                        -Xmx1G threads=$NUM_THREADS \
                        overwrite=t \
                        in1=${out1}_phix.fastq.gz in2=${out2}_phix.fastq.gz \
                        out1=${out1}_qc.fastq.gz out2=${out2}_qc.fastq.gz \
                        outm=${outm1}_qc_bad.fastq.gz outm2=${outm2}_qc_bad.fastq.gz \
                        minlength=30 qtrim=rl maq=20 maxns=0 trimq=14 qtrim=rl tpe tbo \
                        stats="$directory"/2.trimm/${prefix}_QC.stats statscolumns=5


            echo "Removing contaminants"
            # step 4: remove contaminants
            /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbmap.sh \
                        -Xmx70G threads=$NUM_THREADS \
                        minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 \
                        overwrite=t \
                        ref=$reference \
                        in1=${out1}_qc.fastq.gz in2=${out2}_qc.fastq.gz \
                        out1=${out1}_clean.fastq.gz out2=${out2}_clean.fastq.gz \
                        outm=${outm1}_human.fastq.gz outm2=${outm2}_human.fastq.gz \
                        nodisk


            # move the cleaned reads to another folder

            mv "$directory"/2.trimm/*clean.fastq.* "$directory"/2.clean_reads/

        done

echo "job is done"
