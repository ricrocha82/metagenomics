#1/usr/bin/bash

fastq_path=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/2.clean_reads

cd $fastq_path

# for file in *.fastq.gz; do
#     zcat "$file" | awk 'NR % 4 == 2 { bases += length($1); read_count++ } END { sub(/_R1(_R2)?\.fastq\.gz$/, "", FILENAME); print "Sequence_name", FILENAME, "sample_name", FILENAME, "read_count", read_count, "bp_count", bases }'
# done | column -t > summary.tsv

# parallel "echo {} && gunzip -c {} | wc -l  | awk '{d=\$1; print d/4;}'" ::: *.gz

# gunzip -c HP01_FF_MHB_SM_S22_R2_clean.fastq.gz | awk 'BEGIN{sum=0;}{if(NR%4==2){bases += length($0); read_count++;}} END {print FILENAME, bases, read_count;}'  

parallel 'zcat {} | awk "BEGIN { bases=0; read_count=0; } NR % 4 == 2 { bases += length(\$1); read_count++ } END { sub(/_R1(_R2)?\.fastq\.gz$/, \"\", filename); sample_name = filename; sub(/_R[1,2]_clean\.fastq\.gz$/, \"\", sample_name); print filename, sample_name, read_count, bases }" filename="{}"' ::: *.fastq.gz > summary.txt

# add column names
sed  -i '1i Sequence_name\tsample_name\tread_count\tbp_count' summary.txt


