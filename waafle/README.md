# WAAFLE TUTORIAL
This is a brief tutorial on how to use the WAAFLE (a Workflow to Annotate Assemblies and Find LGT Events) tool. Information is taken from the WAAFLE main GitHub repository at https://github.com/biobakery/waafle/tree/main. 

## How to install WAAFLE
The WAAFLE GitHub page provides clear instructions on how to install the tool and the required dependencies. However, if you plan to use Conda to install it, you can use the following scripts. 
The conda environment stored in the `waafle.yml` contains all the dependencies needed. Once you download the file, you will just have to create the conda environment starting from it:
```
wget

conda env create -f waafle.yml
```
If Conda is unable to create the environment or the dependencies are not satisfied, you can try downloading and using the `waafle_exported.yml` file. If this also doesn't work, you should just create a semi-empty Conda environment and install each dependency manually.

WAAFLE also requires a gene database and a taxonomy file to work. You can download the default ones from the main GitHub page https://github.com/biobakery/waafle

## How does the tool work
Briefly, WAAFLE works by blasting the input contigs against a gene database, giving a homology score to all the matches. If the gene coordinates are not provided, the tool calculates them. Combining the input contigs, gene coordinates, `blastn` results and the taxonomy file, the tool is able to determine if a contig contains an HGT event or not: if all the genes of the contig belong to the same species, the contig doesn't contain events; if the contig contains genes from a pair of species, it is classified as a putative HGT event. More information at https://github.com/biobakery/waafle/blob/main/demo/docs/demo.md

In practice, the pipeline requires 2 mandatory commands and 3 optional ones

### Homology search: `waafle_search`
This script executes a custom BLAST search of a set of contigs against a WAAFLE-formatted database.

```
waafle_search input.fna path/waafledb
```

This command produces an output file `contigs.blastout`. The output columns match the requested columns from the BLAST command. 

### Gene calling: `waafle_genecaller` (OPTIONAL)
You can provide your own gene coordinates (GFF file). OPTIONALLY, WAAFLE can find the ORF from the BLAST output itself:

```
waafle_genecaller input_contigs.blastout
```
This produced a file in GFF format. The most important columns in the output file are 1, 4, and 5: they provide an index of the gene start and stop coordinates within each contig.

### Predict HGT events: `waafle_orgscorer`
It compares per-species BLAST hits with the contig's gene coordinates to try to find one- and two-species explanations for contigs. It also requires input contigs and the taxonomy file. 

```
waafle_orgscorer input_contigs.fna contigs.blastout contigs.gff input_taxonomy.tsv
```
This produces three output files:

- `contigs.lgt.tsv` contains a description of predicted LGT events.
- `contigs.no_lgt.tsv` contains descriptions of contigs explained by single species/clades.
- `contigs.unclassified.tsv` contains descriptions of contigs that could not be explained by either single species or pairs of species.

### Find genes junctions: `waafle_junctions` (OPTIONAL)
This is the first of a 2 step optional quality control check that removes low-quality predictions (potential false positives). To perform this step, you need reads data. This command maps the reads to contigs and quantifies support for individual gene-gene junctions. It uses bowtie2 and outputs a SAM file.
```
waafle_junctions contigs.fna contigs.gff --reads1 contigs_reads.1.fq reads2 contigs_reads.2.fq
```

### Remove low-quality reads: `waafle_qc` (OPTIONAL)
It uses the `waafle_junctions` output to remove contigs with weak read support at one or more junctions.
```
waafle_qc contigs.lgt.tsv contigs.junctions.tsv
```
