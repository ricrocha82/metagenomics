# Metagenomic Analysis Pipeline for Viruses and Prokaryotes (under construction)

This repository contains a metagenomic pipeline to process fasta files that can implemented using bash or SLURM jobs.

- [Metagenomics analysis pipeline](https://github.com/ricrocha82/metagenomics/tree/main/metaG_code)
- Command line for each processing steps are described in below.


## Features

- **Support for Viral and Prokaryotic Analysis:** The pipeline supports the analysis of both viral and prokaryotic sequences, enabling comprehensive metagenomic studies.

- **Quality Control and Contamination Removal:** The pipeline includes quality control steps to filter low-quality reads and remove contaminants, ensuring the reliability of downstream analyses.

- **Assembly:** Metagenomic assembly is performed using SPAdes

- (...)

## Getting Started

### Install required software

**Install Dependencies:** Ensure that Nextflow is installed on your system. Additionally, install any required dependencies specified in the .yml files.

You can install all the tools at once (not recommended) 

You can also use mamba instead of conda
```
conda install -c conda-forge -c bioconda -c agbiome fastqc multiqc bbtools
```

or create conda environments for each step 

```
conda create -n quality_control -c conda-forge -c bioconda -c agbiome fastqc multiqc bbtools
```

or you can use the [.yml files](https://github.com/ricrocha82/metagenomics/tree/main/config_files) (recommended - version control)

```
conda env create -f quality_control.yaml # etc
```

To run the pipeline, follow these steps:

**Configure Input Data:** Prepare your input data by organizing raw sequencing reads in the appropriate directory structure.

**Run the Pipeline:** Execute the Nextflow command to run the pipeline:



### Contributions

Contributions to this pipeline are welcome! If you encounter any issues, have suggestions for improvements, or would like to add new features, please open an issue or submit a pull request.

### License
This project is licensed under the MIT License.
