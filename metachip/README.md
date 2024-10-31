# MetaCHIP Tutorial
All information has been taken from the MetaCHIP main repository: https://github.com/songweizhi/MetaCHIP/tree/master?tab=readme-ov-file. MetaCHIP also has a newer version, MetaCHIP2.

## How to install MetaCHIP
To install metaCHIP, you can either use the metachip.yml file or install the dependencies manually; in case neither of the two methods is working, try using the metachip_exported.yml file.
```
wget
conda env create -f
```
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
## How does the tool work
MetaCHIP uses both best-match and phylogenetic approaches for HGT detection. Briefly: open reading frames (ORFs) are predicted from input genomes with Prodigal, and an all-against-all BLASTN search is performed among all predicted ORFs. If the identity match of the ORF has a lower score than a match with another ORF, the gene is considered a putative HGT event. For each pair of genes, which were identified as putative HGT by the best-match approach, a gene tree and a species tree are generated and reconciliated. More info at https://github.com/songweizhi/MetaCHIP/blob/master/manual/file_backup/MetaCHIP_User_Manual_v1.1.10.docx and https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-019-0649-y

The software requires as input:
- a folder that holds the sequence files of all query genomes, in particular genomes/metagenome assembled genomes
- a text file providing taxonomic classification of input genomes

The commands are simple and are just: 
```
MetaCHIP PI -p test -r pcofg -t 6 -i bin_folder -x fasta -taxon GTDB_classifications.tsv
MetaCHIP BP -p test -r pcofg -t 6
```
where -p is the name of the output files, -r are the combination of taxonomic levels, -t is the number of threads, -i input folder, -x format file, -taxon is the taxonomic file

## Custom scripts
in the `src` folder the custom scripts I made to use metaCHIP in a cluster context are stored.


