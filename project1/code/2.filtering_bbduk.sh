#!/usr/bin/bash

        # bbduk guide : https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/
       # make a directory
        mkdir 2.trimm 2.trimm/bads 2.clean_reads/

        NUM_THREADS=12 # $SLURM_NTASKS
        
        samples=/fs/project/PAS1117/ricardo/metaG/project1/samples.txt
        directory=/fs/project/PAS1117/ricardo/metaG/project1
        reference=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/hg19_main_mask_ribo_animal_allplant_allfungus.fa

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
                        refstats=/fs/project/PAS1117/ricardo/metaG/project1/2.trimm/${prefix}_adapterTrimming.stats statscolumns=5


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
                        refstats=/fs/project/PAS1117/ricardo/metaG/project1/2.trimm/${prefix}_PhiXFiltering.stats statscolumns=5 \

            echo "Filtering"
            # step 3: QC

            /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
                        -Xmx1G threads=$NUM_THREADS \
                        overwrite=t \
                        in1=${out1}_phix.fastq.gz in2=${out2}_phix.fastq.gz \
                        out1=${out1}_qc.fastq.gz out2=${out2}_qc.fastq.gz \
                        outm=${outm1}_qc_bad.fastq.gz outm2=${outm2}_qc_bad.fastq.gz \
                        minlength=30 qtrim=rl maq=20 maxns=0 trimq=14 qtrim=rl tpe tbo \
                        stats=/fs/project/PAS1117/ricardo/metaG/project1/2.trimm/${prefix}_QC.stats statscolumns=5


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

            mv 2.trimm/*clean.fastq.* 2.clean_reads/


            

        # print OUTFILE "/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh -Xmx1G threads=1 overwrite=t in=$R1_library in2=$R2_library ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 out=stdout.fq outm=$library_prefix\_adapterTrimmingMatched.fq.gz outs=$library_prefix\_adapterTrimmingSingletons.fq.gz refstats=$library_prefix\_adapterTrimming.stats statscolumns=5| ";
		# print OUTFILE "/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh -Xmx1G threads=1 interleaved=true overwrite=t in=stdin.fq ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/phix174_ill.ref.fa.gz out=stdout.fq outm=$library_prefix\_phixmatches.fq.gz outs=$library_prefix\_phixSingletons.fq.gz k=31 hdist=1 refstats=$library_prefix\_PhiXFiltering.stats statscolumns=5 | ";
		# print OUTFILE "/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh -Xmx1G threads=1 interleaved=true overwrite=t in=stdin.fq fastawrap=10000 out=$library_prefix\_interleaved_PAIRED.fq.gz outm=$library_prefix\_qc_failed.fq.gz outs=$library_prefix\_SINGLETONS.fq.gz minlength=30 qtrim=rl maq=20 maxns=0 overwrite=t stats=$library_prefix\_qualTrimming.stats statscolumns=5 trimq=14 qtrim=rl \n";
		# print OUTFILE "/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbmap.sh -Xmx70G threads=14 minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 overwrite=t ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/hg19_main_mask_ribo_animal_allplant_allfungus.fa in=$library_prefix\_interleaved_PAIRED.fq.gz outm=$library_prefix\_interleaved_PAIRED_human.fq.gz outu=$library_prefix\_interleaved_PAIRED_clean.fq.gz nodisk \n"; 
		# print OUTFILE "/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbmap.sh -Xmx70G threads=14 minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 overwrite=t ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/hg19_main_mask_ribo_animal_allplant_allfungus.fa in=$library_prefix\_SINGLETONS.fq.gz outm=$library_prefix\_SINGLETONS_human.fq.gz outu=$library_prefix\_SINGLETONS_clean.fq.gz nodisk \n"; 				

                        
            # bbduk.sh ref=${contaminants} ordered=t k=31 \
            # in1=$R1 in2=$R2 \
            # out1=$out1 out2=$out2 \
            # outm=$outm1 outm2=$outm2

        # move files to the rigth folder
       # mv *_trimmed.fq.gz trim/

       # ls trimm/

        done


