#!/usr/bin/bash

#  conda activate seqkit

samples=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/samples.txt
directory=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/virus/1.virus_detection
directory_scaffolds=/fs/ess/PAS1117/ricardo/metaG/metagenomics/project1/

# for loop
for prefix in `awk '{print $1}' $samples`
do
if [ "$prefix" == "prefix" ]; then continue; fi
    echo "On sample: $prefix"
    
    fasta_file="$directory"/combined/${prefix}_VS2_GENOMAD_VIBRANT.fasta
    summary_file="$directory"/combined/${prefix}_VS2_GENOMAD_VIBRANT.txt

    # add sample name to each sequence as a prefix
    awk -v var=${prefix} '/>/{sub(">","&" var "_")}1' $fasta_file > "$directory"/combined/${prefix}"_relabel.fasta" 
    awk -v var=${prefix} 'NR > 1 {print var "_" $0}' $summary_file > "$directory"/combined/${prefix}"_relabel.txt" 
    # awk -v var=${prefix} -F "," 'NR==1; NR > 1{print var "_" $0}' $summary_file > ${prefix}"_relabel.txt" 

    # replace the sequence name by another name
    # awk -v var=${prefix} '/^>/{print ">" var "_" ++i; next}{print}' $fasta_file > ${prefix}"_relabel.fa" 
    # Split fasta files based on header
    # awk '/^>/ { file=substr($1,2) ".fasta" } { print > file }' $fasta_file
done

cat "$directory"/combined/*_relabel.fasta > "$directory"/combined/batch1_putative_viral_contigs.fasta
cat "$directory"/combined/*_relabel.txt > "$directory"/combined/batch1_putative_viral_contigs.txt

# add column names
sed  -i '1i contig\tmax_score\tmax_score_group\thallmark\tviral\tcellular\tlength\tgenetic_code\tvirus_score\tn_hallmarks\tmarker_enrichment\ttaxonomy\tvibrant' "$directory"/combined/batch1_putative_viral_contigs.txt

# awk 'BEGIN {print "contig max_score max_score_group hallmark viral cellular length genetic_code virus_score n_hallmarks marker_enrichment vibrant" } {print $0}' "$directory"/combined/batch1_putative_viral_contigs.txt >> "$directory"/combined/batch1_putative_viral_contigs_test.txt


# awk -F " " 'BEGIN { OFS=FS; print "contig" "max_score" "max_score_group" "hallmark" "viral" "cellular" "length" "genetic_code" "virus_score" "n_hallmarks" "marker_enrichment" "vibrant"  } 
#                     { print $1, $2, $3, $4, $5, $6}' test1.txt > teste.csv