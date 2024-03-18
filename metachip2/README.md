# MetaCHIP Tutorial
All informations have been taken from MetaCHIP main repository: https://github.com/songweizhi/MetaCHIP/tree/master?tab=readme-ov-file. MetaCHIP has a newer version, MetaCHIP2, that I'haven't been able to use, but I managed to create the conda environment metachip2_exported.yaml that I won't remove as it may be useful for whoever wants to try the tool.
To install metaCHIP, you can either use the metachip.yaml file or install the dependencies manually; in case neither of the two methods are working, try using the metachip_exported.yaml file.
```
conda create -n metachip -c conda-forge -c bioconda r-base=4.3.2
conda activate metachip

conda install -c bioconda blast diamond mmseqs2 mafft hmmer fasttree #try one by one if it doesn't work

conda install scipy numpy      #some of these may be already installed, check with conda list -n metachip
conda install -c conda-forge biopython matplotlib
conda install etetoolkit::ete3
conda install -c conda-forge r-optparse r-ape r-circlize

pip install --upgrade MetaCHIP
```
## How to use the tool
The software requires as input:
- a folder that holds the sequence files of all query genomes, in particular, bins of MAGs
- a text file providing taxonomic classification of input genomes

The commands are simple and are just: 
```
MetaCHIP PI -p test -r pcofg -t 6 -i bin_folder -x fasta -taxon GTDB_classifications.tsv
MetaCHIP BP -p test -r pcofg -t 6
```
where -p is the name of the output files, -r are the combination of taxonomic levels, -t is the number of threads, -i input folder, -x format file, -taxon is the taxonomic file

The ouput is a Tab delimited text file containing all identified HGTs. Filename format: [prefix]_[taxon_ranks]_detected_HGTs.txt
![image](https://github.com/giacomoorsini/HGT-tools/assets/133371083/1dcbdc12-6fdd-4bc5-bd61-608e73c2a554)

## Tool pipeline
MetaCHIP uses both best-match and phylogenetic approaches for HGT detection. Open reading frames (ORFs) are predicted from input genomes with Prodigal and an all-against-all BLASTN search is performed among all predicted ORFs. The BLASTN results are filtered: essentially the genome is alligned with itself and with other genomes, if the identity match (itself) has higher score than the other matches than it's no LGT, if another match is higher than identity it's a putative LGT.

To further corroborate the predicted HGT candidates, their flanking sequences within user-defined length (e.g. 10 kbp) are extracted from the annotation files. A pairwise BLASTN is performed between each pair of flanking regions. Plots for the genomic regions are generated with GenomeDiagram and provided for visual inspection.

A phylogenetic approach is used to further corroborate the results given by the best-match approach and to provide information on the direction of gene flow. For each pair of genes, which were identified as putative HGT by the best-match approach, a protein tree is generated using the genes used for the HGT analysis in the best-match approach and all orthologs from the two groups, from which the paired genes came from.
A protein tree is then constructed using FastTree v2.1.10 with default parameters. A “species” tree is then generated to compare to the gene tree. As the 16S rRNA gene, which is the most commonly used phylogenetic and taxonomic marker of bacterial and archaeal organisms, is often missing in genome bins, we build a phylogenetic tree for all input genomes using the protein sequences of 43 universal single-copy genes (SCGs) used by CheckM.
Protein sequences for each hmm profile are then individually aligned using HMMER and concatenated into a multiple sequence alignment (MSA). Columns represented by < 50% of genomes and/or with an amino acid consensus < 25% are removed, and a phylogenetic tree is built using FastTree. A subtree, which includes only the genomes relevant to the particular genes analysed is extracted with preserved branch length using ETE v3.1.1. The reconciliation between each pair of protein tree and “species” subtree is performed using Ranger-DTL v2.0 with dated mode. Briefly, Ranger-DTL predicts HGTs by performing a duplication-transfer-loss (DTL) reconciliation between a protein family phylogeny and its corresponding organismal phylogeny.

![image](https://github.com/giacomoorsini/HGT-tools/assets/133371083/541f8c7a-1853-48cd-a09e-d772176beac4)

