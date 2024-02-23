#---------------------------------
# cut all primers off (16S)
#---------------------------------

cd data\sequences_fasta_16S

mkdir cutadapt

# get the names of the samples
ls *_1.fastq | cut -f1 -d "_" > samples

# check
cat samples


cutadapt -a CCAGCASCYGCGGTAATTCC...TCATYRATCAAGAACGAAAGT \
-A ACTTTCGTTCTTGATYRATGA...GGAATTACCGCRGSTGCTGG \
-m 10 --discard-untrimmed \
-o ${sample}_1_trimmed.fq.gz -p ${sample}_2_trimmed.fq.gz \
${sample}_1.fastq ${sample}_2.fastq

head -n 2 ${sample}_1.fastq
head -n 2 ${sample}_1_trimmed.fq.gz

# for loop
for sample in $(cat samples)
do

    echo "On sample: $sample"
    
    cutadapt -a CCAGCASCYGCGGTAATTCC...TCATYRATCAAGAACGAAAGT \
    -A ACTTTCGTTCTTGATYRATGA...GGAATTACCGCRGSTGCTGG \
    -m 10 --discard-untrimmed \
    -o ${sample}_1_trimmed.fq.gz -p ${sample}_2_trimmed.fq.gz \
    ${sample}_1.fastq ${sample}_2.fastq \
    >> cutadapt_primer_trimming_stats.txt 2>&1

done


# move files to the rigth folder
mv *_trimmed.fq.gz cutadapt/

ls cutadapt/


