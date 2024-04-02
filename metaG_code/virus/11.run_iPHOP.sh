#!/bin/bash
#SBATCH --job-name=iPHoP_CONGO
#SBATCH --account=PAA0034

#SBATCH --nodes=2
#SBATCH --ntasks=28
#SBATCH --time=24:0:0

#SBATCH --output=/fs/project/PAS1117/CONGO_PROJECT/Vaginal_Swabs/Shotgun_MetaG/VIRAL_PREDICTIONS/0_iPHoP.out 
#SBATCH --error=/fs/project/PAS1117/CONGO_PROJECT/Vaginal_Swabs/Shotgun_MetaG/VIRAL_PREDICTIONS/0_iPHoP.err 

NUM_THREADS=28

samples='/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt'
directory="/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/"

mkdir "$directory"/virus/4.iphop

module use /fs/project/PAS1117/modulefiles
module load iPHoP/1.3.2

# to install iphop DB (Sept_2021_pub_rw)
# go to scratch
# mkdir /fs/scratch/Sullivan_Lab/Ricardo/iphop_db
# iphop download --db_dir iphop_db/

DB=/fs/project/PAS1117/modules/sequence_dbs/iPHoP/Sept_2021_pub_rw
votus_fasta=$directory/virus/Batch1_final_vOTUs.fasta
iphop_out=$directory/virus/4.iphop/

iphop predict --fa_file $votus_fasta --out_dir $iphop_out --num_threads $NUM_THREADS --db_dir $DB




