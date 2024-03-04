# HGTector
## Installation
Download the yml file and create the environment with conda

## Tutorial
HGTector can work out-of-the-box. the program does not need a sequence aligner, or a local sequence database, or a taxonomy system, or any super computing hardware. 
It will take care of everything by calling a remote server (by default the NCBI BLAST server). 
It does not even need input data --- as long as you provide a list of sequence IDs which can be looked up from the remote database. Obviously it is not ment to be used like this.

### Aligner
HGTector should ideally work with a local database and a local program for sequence homology search. This is to ensure fast, controllable and repeatable bioinformatic analyses.
Two protein sequence aligners are supported: DIAMOND and BLAST. By default, HGTector first looks for diamond, then blastp, in the current environment.

### Database
A reference protein sequence database should ideally contain a significant breadth of known microbial diversity.
HGTector provides an automated workflow, database, for downloading non-redundant protein sequences from the NCBI server and compiling them into a DIAMOND or BLASTp database.
(https://github.com/qiyunlab/HGTector/blob/master/doc/database.md)

### Input data
The input data for HGTector should be one or more multi-Fasta files,
each of which represents the complete protein set of a genome, or a bin from a metagenome assembly, or any collection that you consider as an independent evolutionary unit. For testing, you can dowload  the whole protein set of a 
bacteria from the NCBI server.

### Search 
Perform batch homology search of the protein sequences against the database. For both BLAST and DIAMOND, the output hit table format is: qaccver saccver pident evalue bitscore qcovhsp staxids

Three common alignment metrics are present: E-value, % identity, and % coverage of query. You can specify thresholds for them, as well as multiple other metrics, in the search command.

Meanwhile, HGTector performs self-alignment for each input protein sequence to get a bit score, and appends it to the comment lines above each hit table. This score will serve as the baseline for hit score normalization.

### Analyze
With the search results you can proceed to predict HGTs using the analyze command. You may also provide multiple samples for a combined analysis.

#### Hit filtering 
The analyze command also has search threshold parameters such as --maxhits, --evalue, --identity and --coverage. Their meanings are the same as those in the search command. That's because these values can notably impact the prediction result (which is conceivable since they matter how "homology" is defined), and when you feel the need for tuning those parameters, 
you don't want to re-run the expensive search step. Therefore, it is recommended to do search using relatively relaxed thresholds, then do (several rounds of) analyze using more stringent thresholds.

#### Taxonomic inference
HGTector attempts to assign taxonomy to each input genome, based on a majority rule of the best hits of its member proteins.
The program implements an algorithm which progressively moves up the taxonomic hierarchy until one taxon meets the majority criterion. Argument --input-cov specifies the threshold for "majority". The default value is 75 (%).

For example, if only 72% best hits are from genus Escherichia (TaxID: 561), but at the same time 76% best hits are from family Enterobacteriaceae (TaxID: 543), 
the program will think that the input genome is Enterobacteriaceae. However, the auto-inferred taxonomic label may not accurately reflect the currently accepted classification of this genome. 
To resolve, you may lower the threshold, or you can provide a custom dictionary of sample ID to taxID using the --input-tax parameter. In many use cases of HGTector, the input data are metagenomic bins without pre-defined taxonomy. 
Letting the program infer taxonomy based on best hits is not a bad idea.

#### Taxonomic grouping
The HGTector method divides all taxa into three groups: "self", "close", and "distal". They are implicit representations of the phylogenetic (vertical evolution) relationships around the genome(s) of your interest:

The self group is considered the recipient, and always has to include the query genome(s), and, depending on analytical scale may also include its immediate sister organisms (e.g., different strains within the same species, or different species within the same genus).

The close group will include representatives of the putative vertical inheritance history of the group (e.g., other species of the same genus, or other genera of the same family which the query genome belongs to).

The distal group includes all other organisms, which are considered phylogenetically distant from the query genome (e.g., other families, orders, etc.). The method will then aim to identify genes that are likely derived from directional gene flow from groups of organisms within the distal group to members of the self group.

Definition of the three groups has strong impact on the prediction result. First, the program infers the "self" group. 
It starts from the lowest common ancestor (LCA) of all input genomes (there is only one here) in the taxonomy tree, and optionally lands on a designated taxonomic rank (controlled by argument --self-rank). If the LCA is already above this rank, the program will just use the LCA.

Next, the program infers the "close" group. It continues to move up in the taxonomy tree, to the next rank that allows for adequate taxon sampling in between 
the two ranks (defaults to 10, controlled by --close-size). The larger this group size is, the more statistical power it will deliver. But a too large "close" group will mask true HGTs that occurred among group members.
If you have alternative plans for grouping, you may manually specify them.

#### Group score calculation
The program then sums up the bit scores of all hits within each of the three groups per protein (gene) per genome, and divides that by the bit score of the query protein. This normalization makes all scores within the range of 0 to 1.
Now there is an intermediate file generated: scores.tsv. All steps below are based on this table. If you only want to optimize the steps discussed below, you can add switch --from-scores so that the program will not re-parse hit tables, but only starts with the existing score table.
You may also do manual statistics on this table using your favorite tool and approaches. As long as you know what you are doing, this will enable more flexibility comparing to the hard-coded steps below.

#### Gene filtering
ORFans are those proteins (genes) without any non-self hits. They should typically be removed from the statistical analysis. Outliers are not that deleterious in the default workflow. But they make the plot ugly; and they also potentially impact the subsequent analysis under certain settings. To be safe, let's remove them. 

#### Group score clustering
Here is the core step of the entire workflow. HGTector attempts to separate the distribution of scores of each group into at least two clusters, and considers the cluster at the low end as "atypical". Genes falling within the atypical cluster are those with fewer and less similar hits in the corresponding group





