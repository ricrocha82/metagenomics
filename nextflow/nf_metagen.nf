#!/usr/bin/env nextflow

// to run
// cd diretory where the sequences.csv table is
// nextflow run your/path/main.nf [parameters] -with-conda

// parameters

params.input_csv = "${launchDir}/files/sequences.csv" //The directory from where the script is launched
params.outdir = "${launchDir}/1.qc"
params.trim = "${launchDir}/2.trimm"
params.clean = "${launchDir}/2.clean"
params.assembly = "${launchDir}/3.assembly"


params.cpu = 28
params.threads = 4

log.info """\
    META G E N O M I C S - N F   P I P E L I N E
    ============================================
    reads        : ${params.input_csv}
    outdir       : ${params.outdir}
    """
    .stripIndent()

/**
 * Quality control fastq
 */

// Creating channels
samples_ch = Channel
                .fromPath(params.input_csv)
                .splitCsv(header:true)
                .map { row-> tuple(row.sample_id, file(row.read1), file(row.read2)) }


// Defining the process that is executed
process FASTQC {

    // conda "${launchDir}/config_files/quality_control_config.yml" 
    conda '/users/PAS1117/ricrocha82/miniconda3/envs/quality_control' // use -with-conda

    // print a message in the process
    tag "FASTQC on $sample_id" 
    // store the process results in a directory of your choice
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), file(read1), file(read2)

    output:
    path "fastqc_${sample_id}_logs"

    script:
    """
    mkdir -p fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -t $params.threads $read1 $read2

    """
}

process MULTIQC {

    conda '/users/PAS1117/ricrocha82/miniconda3/envs/quality_control'

    tag "MULTIQC" 

    publishDir params.outdir, mode:'copy'
    
    input:
    path '*'

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc *

    """
}

process TRIMMING {
   tag "bbduk - Removing adapters on $sample_id"

  publishDir params.trim, mode:'copy', pattern: "*_adapters.fastq.gz"

  input:
    tuple val(sample_id), file(read1), file(read2)
  output:
    tuple val(sample_id), path("${sample_id}_R{1,2}_adapters.fastq.gz"), emit: reads_adapter
    tuple val(sample_id), path("${sample_id}_singletons_adapters.fastq.gz"), emit: sing_adapter

  script:
    out1= sample_id + '_R1_adapters.fastq.gz' 
    out2= sample_id + '_R2_adapters.fastq.gz' 
    outm= sample_id + '_R1_adapters_bad.fastq.gz' 
    outm2= sample_id + '_R2_adapters_bad.fastq.gz' 
    outs= sample_id + '_singletons_adapters.fastq.gz'
  """
  /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
                        -Xmx1G threads=1 \
                        overwrite=t \
                        in1=${read1} in2=${read2} \
                        out1=$out1 \
                        out2=$out2 \
                        outm=$outm outm2=$outm2 \
                        outs=$outs \
                        ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/adapters.fa \
                        ktrim=r k=23 mink=11 hdist=1 \
                        refstats=${sample_id}_adapterTrimming.stats statscolumns=5

  """
}

process CONTAMINANTS {
  tag "bbduk - Removing spikesin on $sample_id"

  publishDir params.trim, mode:'copy', pattern: "*_phix.fastq.gz"

  input:
    tuple val(sample_id), path(reads_adapter)

  output:
    tuple val(sample_id), path("${sample_id}_R{1,2}_phix.fastq.gz"), emit : reads_phix
    tuple val(sample_id), path("${sample_id}_singletons_phix.fastq.gz"), emit: sing_phix

  script:
    def (r1, r2) = reads_adapter
    out1= sample_id + '_R1_phix.fastq.gz' 
    out2= sample_id + '_R2_phix.fastq.gz' 
    outm= sample_id + '_R1_phix_bad.fastq.gz' 
    outm2= sample_id + 'R2_phix_bad.fastq.gz' 
    outs= sample_id + '_singletons_phix.fastq.gz'
  """
  /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
            -Xmx1G threads=1 \
            overwrite=t \
            in1=${r1} \
            in2=${r2} \
            ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/phix174_ill.ref.fa.gz \
            out1=$out1 \
            out2=$out2 \
            outm=$outm outm2=$outm2 \
            outs=$outs \
            ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/adapters.fa \
            ktrim=r k=23 mink=11 hdist=1 \
            refstats=${sample_id}_PhiXFiltering.stats statscolumns=5

  """
}

// process CONTAMINANTS_SING {
//   tag "bbduk - Removing spikesin on $sample_id"

//   publishDir params.trim, mode:'copy', pattern: "*_phix.fastq.gz"

//   input:
//     tuple val(sample_id), path(reads_adapter)

//   output:
//     tuple val(sample_id), path("${sample_id}_R{1,2}_phix.fastq.gz"), emit : reads_phix

//   script:
//     def (r1, r2) = reads_adapter
//     out1= sample_id + '_R1_phix.fastq.gz' 
//     out2= sample_id + '_R2_phix.fastq.gz' 
//     outm= sample_id + '_R1_phix_bad.fastq.gz' 
//     outm2= sample_id + '_phix_bad.fastq.gz' 
//     outs= sample_id + '_singletons_phix.fastq.gz'
//   """
//   /fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
//             -Xmx1G threads=1 \
//             overwrite=t \
//             in1=${r1} \
//             in2=${r2} \
//             ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/phix174_ill.ref.fa.gz \
//             out1=$out1 \
//             out2=$out2 \
//             outm=$outm outm2=$outm2 \
//             outs=$outs \
//             ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/adapters.fa \
//             ktrim=r k=23 mink=11 hdist=1 \
//             refstats=${sample_id}_PhiXFiltering.stats statscolumns=5

//   """
// }


process FILTERING {
  tag "bbduk - Filtering on $sample_id"

  publishDir params.trim, mode:'copy', pattern: "*_qc.fastq.gz"

  input:
    tuple val(sample_id), path(reads_phix)

  output:
    tuple val(sample_id), path("${sample_id}_R{1,2}_qc.fastq.gz"), emit : reads_qc
    tuple val(sample_id), path("${sample_id}_singletons_qc.fastq.gz"), emit: sing_qc


  script:
    def (r1, r2) = reads_phix
    out1= sample_id + '_R1_qc.fastq.gz' 
    out2= sample_id + '_R2_qc.fastq.gz' 
    outm= sample_id + '_R1_qc_failed.fastq.gz' 
    outm2= sample_id + '_R2_qc_failed.fastq.gz' 
    outs= sample_id + '_singletons_qc.fastq.gz'
  """
/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbduk.sh \
            -Xmx1G threads=1 \
            overwrite=t \
            in1=${r1} \
            in2=${r2} \
            out1=$out1 \
            out2=$out2 \
            outm=$outm \
            outm2=$outm2 \
            outs=$outs \
            stats=${sample_id}_QC.stats statscolumns=5 \
            minlength=30 qtrim=rl maq=20 maxns=0 trimq=14 qtrim=rl


  """
}

process REMOVE {
  tag "bbduk - Removing contaminants on $sample_id"

  publishDir params.clean, mode:'copy', pattern: "*_clean.fastq.gz"

  input:
    tuple val(sample_id), path(reads_qc)

  output:
    tuple val(sample_id), path("${sample_id}_R{1,2}_clean.fastq.gz"), emit : reads_clean

  script:
    def (r1, r2) = reads_qc
    out1= sample_id + '_R1_clean.fastq.gz' 
    out2= sample_id + '_R2_clean.fastq.gz' 
    outm= sample_id + '_R1_human.fastq.gz' 
    outm2= sample_id + '_R2_human.fastq.gz' 
  """
/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbmap.sh \
            -Xmx70G threads=14 minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 overwrite=t \
            ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/hg19_main_mask_ribo_animal_allplant_allfungus.fa \
            in1=${r1} \
            in2=${r2} \
            outm=$outm \
            outm2=$outm2 \
            out1=$out1 \
            out2=$out2 \
            nodisk

  """
}


process REMOVE_SING {
  tag "bbduk - Removing contaminants (singletons) on $sample_id"

  publishDir params.clean, mode:'copy', pattern: "*_singletons_clean.fastq.gz"

  input:
    tuple val(sample_id), path(sing_qc)

  output:
    tuple val(sample_id), path("${sample_id}_singletons_clean.fastq.gz"), emit: sing_clean


  script:
    def (r1) = sing_qc
    outu= sample_id + '_singletons_clean.fastq.gz' 
    outm= sample_id + '_singletons_human.fastq.gz' 
  """
/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/bbmap.sh \
            -Xmx70G threads=14 minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 overwrite=t \
            ref=/fs/project/PAS1117/bioinformatic_tools/bbmap_38.51/resources/hg19_main_mask_ribo_animal_allplant_allfungus.fa \
            in=${r1} \
            outm=$outm \
            outu=$outu \
            nodisk
  """
}


process ASSEMBLY {

  conda '/users/PAS1117/ricrocha82/miniconda3/envs/assembly'

  tag "Assembly on $sample_id"

  publishDir (
        path: params.assembly,
        mode: "copy",
        pattern: "${sample_id}/*.fasta",
        saveAs: { fn ->
            if (fn.endsWith("contigs.fasta")) { "${sample_id}_contigs.fasta" }
            else { "${sample_id}_scaffolds.fasta" }
        }
    )

  // publishDir params.assembly, mode:'copy', pattern: "${sample_id}/contigs.fasta", saveAs: { filename -> "contigs_$filename.fasta" }
  // publishDir params.assembly, mode:'copy', pattern: "${sample_id}/scaffolds.fasta"

  input:
    tuple val(sample_id), path(reads_clean), path(sing_clean)

  output:
    tuple val(sample_id), path("${sample_id}/contigs.fasta") , emit: assembly_contigs
    tuple val(sample_id), path("${sample_id}/scaffolds.fasta") , emit: assembly_scaffolds

  script:
    def (r1, r2) = reads_clean
    def (sing_read) = sing_clean
  """
metaspades.py -1 ${r1} -2 ${r2} -s ${sing_read} \
        -o ${sample_id} --threads 28 \
         -m 140 

  """
}







// process mapping {
//   tag "STAR - genome mapping"
//   publishDir "$baseDir", mode:'copy', pattern:'*_Aligned.sortedByCoord.out.bam'
//   publishDir "$baseDir", mode:'copy', pattern:'*_Aligned.sortedByCoord.out.bam.bai'
//   publishDir "$baseDir", mode:'copy', pattern:'*_Log.final.out'

//   input:
//     tuple val(sample_id), file(reads)
//   output:
//     file("*_Aligned.sortedByCoord.out.bam")

//   script:
//   """
//   STAR --runThreadN ${task.cpus} --genomeDir $params.staridx --readFilesCommand gunzip -c --readFilesIn ${reads} --outFileNamePrefix ${sample_id}_ --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate
//   samtools index -@ ${task.cpus} ${sample_id}_Aligned.sortedByCoord.out.bam
//   """
// }

// process counting {
//   tag "featureCount - gene counting"
//   publishDir "$baseDir", mode:'copy', pattern:"*"

//   input:
//     file(bam)
//   output:
//     file('*')

//   script:
//   """
//   featureCounts -T ${task.cpus} -s 1 -t exon -g gene_id -a $params.gtf -o gene_featureCounts_output.txt ${bam}
//   """
// }


workflow {
      samples_ch
        FASTQC(samples_ch)
        MULTIQC(FASTQC.out.collect())

      samples_ch
        TRIMMING(samples_ch)
        CONTAMINANTS(TRIMMING.out.reads_adapter)
        // CONTAMINANTS_SING(TRIMMING.out.sing_adapter)
        FILTERING(CONTAMINANTS.out.reads_phix)
      
      remove_ch = REMOVE(FILTERING.out.reads_qc)
      remove_sing_ch = REMOVE_SING(FILTERING.out.sing_qc)

        // Combine channels from REMOVE and REMOVE_SING
        assembly_input = remove_ch.combine(remove_sing_ch, by: 0)

        assembly_ch = ASSEMBLY(assembly_input)
        // ASSEMBLY(REMOVE.out.reads_clean, REMOVE_SING.out.sing_clean)

      
      // counting(mapping.out.collect())

    // TRIMMING.out.view()
    // CONTAMINANTS.out.view()
}

// print a confirmation message when the script completes
workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
