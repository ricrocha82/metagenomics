#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=1.qc_job.sh
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=12
#SBATCH --error=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.err
#SBATCH --output=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/code/jobs/%x_%j.out

# go to the folder where the files are
#cd /fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot

source ~/miniconda3/bin/activate

# activate env
conda activate quality_control

# how many threads should each mapping task use?
NUM_THREADS=$SLURM_NTASKS

# step 1
# for prefix in `awk '{print $1}' samples.txt`
# do
#     echo "on sample: $prefix"

#     R1s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R1_001.fastq.gz
#     R2s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R2_001.fastq.gz


directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/
samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt

# create new folders
mkdir "$directory"/1.qc
mkdir "$directory"/1.multiqc



# step 1
# for prefix in `awk '{print $1}' samples.txt`
# do
#     echo "on sample: $prefix"

#     R1s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R1_001.fastq.gz
#     R2s=/fs/project/PAS1117/kimma/HIV_fecal_pilot/03092022KimNdlovu/fastq/${prefix}_R2_001.fastq.gz
   # directory=/fs/project/PAS1117/ricardo/metaG/hiv_fecal_pilot/deinterleaved

# go to the directory and


        
        ## Run FASTQC
        # fastqc [-o output dir] [-t --threads] [--(no)extract] [-f fastq|bam|sam]
        fastqc -o "$directory"/1.qc -t $NUM_THREADS  "$directory"/data/*.fastq.gz

        # run multiqc
        multiqc "$directory"/1.qc/ --outdir "$directory"/1.multiqc/
        
conda deactivate

# done