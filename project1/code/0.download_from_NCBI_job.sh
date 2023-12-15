#!/bin/bash

#SBATCH --account=PAS1117
#SBATCH --job-name=0.download_NCBI_v3v4
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=28
#SBATCH --error=/fs/project/PAS1117/ricardo/16S_vag/meta_analysis/jobs/%x_%j.err
#SBATCH --output=/fs/project/PAS1117/ricardo/16S_vag/meta_analysis/jobs/%x_%j.out

# new dir on the Working directory
    source ~/miniconda3/bin/activate

    conda activate sra_tools

    cd /fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/

    # create directories
    mkdir project_runs
    cd project_runs

    cd /fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/project_runs/

    study_list=/fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/studies_preg.txt

    for project in `awk '{print $1}' $study_list`
    do

    #Create Directory
    mkdir $project
    cd $project

    # get hte run list from NCBI
    esearch -db sra -query $project | efetch -format runinfo | cut -d ',' -f 1 | grep SRR | head -1 > /fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/project_runs/$project/${project}_runs.txt

   #03. Begin Data Download
    #Download the data
        cat /fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/project_runs/$project/${project}_runs.txt  | parallel -j0 prefetch {}
    #Move all .sra files out of their folders and into the working directory
        find . -name '*.sra' -print0 | xargs -0 mv -t .
    #Delete all empty folders in the working directory
        find . -type d -empty -delete
   #04. Convert all .sra files into fastq files
	# --split-files flag for pair-ended sequences
		ls *.sra | parallel -j0 fastq-dump --split-files --origfmt {}
	
	# Compress all fastq files
		gzip *.fastq
		
    #Move .fastq and .sra file types into their own folders
        mkdir fastq
        mv *.fastq.gz fastq
        mkdir sra
        mv *.sra sra
        
        # rename fastq file
        cd /fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/project_runs/$project/fastq
        for file in *.fastq*; do
        if [ -f "$file" ]; then
        mv "$file" "${project}_${file}"
        echo "Renamed: $file -> ${project}_${file}"
        fi
        done

        cd /fs/project/PAS1117/ricardo/16S_vag/meta_analysis/code/dada2/v3v4/data/project_runs/
done

echo "job is done"