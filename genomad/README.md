# Genomad Tutorial
This is a brief tutorial on how to use the geNomad tool. Information is taken from the geNomad website at https://portal.nersc.gov/genomad/index.html
## Installation
To install the tool you can follow the easy installation step found at https://portal.nersc.gov/genomad/installation.html, otherwise you can dowload the `genomad_exported.yml` file and issue the `conda env create -f genomad_exported.yml` command.
## How does the tool work
Briefly, geNomad predicts the presence of plasmids and phages thanks to a neural netwrok classification and a marker based classification. It also gives information on the antibiotic resistance genes found in plasmids (thanks to AMRfinder https://www.ncbi.nlm.nih.gov/pathogens/hmm/) and the taxonomy of the viruses (thanks to the ICTV’s VMR number 19).
To make geNomad work, you have to download its markers database and gives as input contigs. Then, geNomad can be issued using only one command: `genomad end-to-end [OPTIONS] INPUT OUTPUT DATABASE`.
Genomad classification method works as following:
- The ORF in the input contigs are annotated and the genes are blasted against the marker database. Markers are either viral, plasmid, or chrmosomal.
- Pro-viruses are found by identifying viral regions flanked by chromosomal ones.
- The contigs are divided into k-mers and fed to a NN, that creates representation into an higher dimenision space in which similar sequences are nearer.
- The predictions are aggregated and scores combined

## Custom scripts and data analysis
In the `src` the custom scripts I made to use geNomad in an HPC cluster are stored. In the `data_analysis folder` the data analysis I carried out on the final output.
