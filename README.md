# Metagenomic Analysis Pipeline for Viruses and Prokaryotes (under construction)

This repository contains a comprehensive metagenomic analysis pipeline designed for the study of viruses and prokaryotes in environmental or human/animal samples. The pipeline is also implemented in Nextflow, making it scalable, reproducible, and easy to deploy on various computing environments.

- [Metagenomics analysis pipeline](https://github.com/ricrocha82/metagenomics/tree/main/metaG_code): (can be implemented using bash or SLURM jobs)
- [Nextflow pipeline](https://github.com/ricrocha82/metagenomics/tree/main/nextflow): pre-processing samples, R/Python for statistical analysis
- Command line for each processing steps are described in below.


## Features
- **Modular Design:** The pipeline is modularized for flexibility, allowing users to customize individual steps based on their specific requirements.

- **Support for Viral and Prokaryotic Analysis:** The pipeline supports the analysis of both viral and prokaryotic sequences, enabling comprehensive metagenomic studies.

- **Integration of Bioinformatics Tools:** Various bioinformatics tools such as bbmap, bbduk, and metaspades (...) are seamlessly integrated into the pipeline, providing a robust analytical framework.

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
conda install -c bioconda nextflow
```

or create conda environments for each step 

```
conda create -n quality_control -c conda-forge -c bioconda -c agbiome fastqc multiqc bbtools
conda create -n nextflow -c bioconda nextflow
```

or you can use the [.yml files](https://github.com/ricrocha82/metagenomics/tree/main/config_files) (recommended - version control)

```
conda env create -f quality_control.yaml
conda env create -f nextflow.yaml
```

To run the pipeline, follow these steps:

**Configure Input Data:** Prepare your input data by organizing raw sequencing reads in the appropriate directory structure.

**Run the Pipeline:** Execute the Nextflow command to run the pipeline:



### Contributions

Contributions to this pipeline are welcome! If you encounter any issues, have suggestions for improvements, or would like to add new features, please open an issue or submit a pull request.

### License
This project is licensed under the MIT License.
