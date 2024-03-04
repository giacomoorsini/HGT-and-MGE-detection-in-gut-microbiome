# WAAFLE TUTORIAL
This is a brief tutorial to use waafle. All information are taken from the waafle github repository https://github.com/biobakery/waafle/tree/main. 
## How to install
To install the tool, we made a conda enviroment which contain all the dependencies to make it work. The YAML file can be found in waafle.yml. Once you download the file, you will just have to issue the command:
`conda env create -f waafle.yml`

For the rest of the installation, you can dowload the file `src/terraform.sh` and place it in a directory structure of type `waafle/src/terraform.sh`. Read carefully the script before issuing it as it creates default directories.
```
bash terraform.sh
```

## How to use the tool
The pipeline requires the issue of 3 different commands: 
- `waafle_search` used to search the input contigs against the WAAFLE-formatted database
- `waafle_genecaller` to identify gene coordinates of interest directly from the BLAST output produced in the previous step 
- `waafle_orgscorer` identify contigs derived from a single clade or pair of clades

  ![image](https://github.com/giacomoorsini/HGT-tools/assets/133371083/24f66c8c-4487-41de-b17b-fda0898fdb76)

## waafle_search
This script executes a custom BLAST search of a set of contigs against a WAAFLE-formatted database.

```
waafle_search input.fna path/waafledb
```

The waafle database is in the format of three files (.nhr .nsq .nsl) so, if you decide to modify the names, make so that you can call them with the same command (like waafledb.*, so you can just put path/waafledb).

Other commands from the `--help` menu are:

`waafle_search [-h] [--blastn <path>] [--threads <int>] [--out <path>] query db`

```
  --blastn <path>  path to blastn binary   [default: $PATH]
  --threads <int>  number of CPU cores to use in blastn search   [default: 1]
  --out <path>     path for blast output file   [default: <derived from input>] 
```
By default, the flags for the blast command are: `-out ./demo_contigs.blastout -max_target_seqs 10000 -num_threads 1 -outfmt '6 qseqid sseqid qlen slen length qstart qend sstart send pident positive gaps evalue bitscore sstrand'`
This command produces an output file `contigs.blastout` in the same location as the input contigs. The columns of the output match the requested columns from the BLAST command.  Most critically, the first and second columns provide a mapping from the input contigs to genes in the demo database (subject sequences). The ouput columns are:

- `qseqid` query or source (gene) sequence id
- `sseqid` subject or target (reference genome) sequence id
- `qlen`query sequence length
- `slen` subject sequence length
- `length` alignment length (sequence overlap)
- `qstart` start of alignment in query
- `qend` end of alignment in query
- `sstart` start of alignment in subject
- `send` end of alignment in subject
- `pident` percentage of identical positions
- `positive`  Number of positive-scoring matches
- `gaps` Total number of gaps
- `evalue` expect value
- `bitscore` bit score
- `mismatch` number of mismatches
- `gapopen` number of gap openings
- `sstrand` Subject Strand

More info at https://www.metagenomics.wiki/tools/blast/blastn-output-format-6

## waafle_genecaller

In order to classify the contigs, WAAFLE compares the BLAST hits generated above to a set of predicted protein-coding loci within the contigs, as defined by a GFF file. WAAFLE includes a utility to call genes within contigs based on the BLAST output itself by clustering the start and stop coordinates of hits along the length of the contig. OPTIONALLY, supply your own GFF file.

```
waafle_genecaller input_contigs.blastout
```
This produced a file in GFF format. Columns 1, 4, and 5 are the most important: they provide an index of the gene start and stop coordinates within each contig.
The columns of the .gff file are the following:

- **seqname** - name of the chromosome or scaffold; chromosome names can be given with or without the 'chr' prefix. Important note: the seqname must be one used within Ensembl, i.e. a standard chromosome name or an Ensembl
- **identifier** such as a scaffold ID, without any additional content such as species or assembly. See the example GFF output below.
- **feature** - feature type name, e.g. Gene, Variation, Similarity
- **start** - Start position* of the feature, with sequence numbering starting at 1.
- **end** - End position* of the feature, with sequence numbering starting at 1.
- **score** - A floating point value.
- **strand** - defined as + (forward) or - (reverse).
- **frame** - One of '0', '1' or '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on..
- **attribute** - A semicolon-separated list of tag-value pairs, providing additional information about each feature.

Other commands from the `--help` menu are:

`waafle_genecaller [-h] [--gff <path>] [--min-overlap <float>] [--min-gene-length <int>] [--min-scov <float>] [--stranded] blastout`

```
  --gff <path>   path for (output) waafle gene calls (.gff) [default: <derived from input>]
  --min-overlap <float>  if a large hit covers this fraction of a smaller hit, consider them part of the same gene group [default: 0.1]
  --min-gene-length <int>   minimum allowed gene length [default: 200]
  --min-scov <float>   (modified) scoverage filter for hits to gene catalog [default: 0.75]
  --stranded    only merge hits into hits/genes of the same strandedness [default: off]
```

## waafle_orgscorer
Compares per-species BLAST hits with the contig's gene coordinates (loci) to try to find one- and two-species explanations for contigs. This utility has many tunable parameters, most of which are devoted to filtering and formatting the outputs. It has 4 required parameters: `contigs blastout gff taxonomy`.

```
waafle_orgscorer input_contigs.fna contigs.blastout contigs.gff input_taxonomy.tsv
```
This produces three output files:

- `demo_contigs.lgt.tsv` contains a description of predicted LGT events.
- `demo_contigs.no_lgt.tsv` contains descriptions of contigs explained by single species/clades.
- `demo_contigs.unclassified.tsv` contains descriptions of contigs that could not be explained by either single species or pairs of species.

Tunable commands from the `--help` menu are:

```
waafle_orgscorer.py [-h] [--outdir <path>] [--basename <str>]
                           [--write-details] [--quiet] [-k1 <0.0-1.0>]
                           [-k2 <0.0-1.0>]
                           [--disambiguate-one <report-best/meld>]
                           [--disambiguate-two <report-best/jump/meld>]
                           [--range <float>] [--jump-taxonomy <1-N>]
                           [--allow-lca] [--ambiguous-fraction <0.0-1.0>]
                           [--clade-genes <1-N>] [--clade-leaves <1-N>]
                           [--sister-penalty <0.0-1.0>]
                           [--weak-loci <ignore/penalize/assign-unknown>]
                           [--transfer-annotations <lenient/strict/very-strict>]
                           [--min-overlap <0.0-1.0>] [--min-gene-length <int>]
                           [--min-scov <float>] [--stranded]
                           contigs blastout gff taxonomy
```
                           
-  `--outdir <path>`       directory for writing output files [default: .]
-  `--basename <str> `     basename for output files [default: derived from contigs file]
-  `--write-details `      make an additional output file with per-gene clade scores [default: off]
-  `--quiet`               don't show running progress [default: off]

main parameters:
-  `-k1 <0.0-1.0>, --one-clade-threshold <0.0-1.0>` minimum per-gene score for explaining a contig with a single clade [default: 0.5]
-  `-k2 <0.0-1.0>, --two-clade-threshold <0.0-1.0>` minimum per-gene score for explaining a contig with a pair of clades (putative LGT) [default: 0.8]
-  `--disambiguate-one <report-best/meld>` what to do when other one-clade explanations fall within <--range> of the best explanation [default: meld]
-  `--disambiguate-two <report-best/jump/meld>` what to do when other two-clade explanations fall within <--range> of the best explanation [default: meld]
-  `--range <float>`       when disambiguating, consider explanations within <--range> of the best explanation [default: 0.05]
-  `--jump-taxonomy <1-N>` before starting, perform 1+ 'jumps' up the taxonomy (e.g. species->genus) [default: off]

post-detection LGT filters:
-  `--allow-lca`           when melding LGT clades, allow the LGT LCA to occur as a melded clade [default: off]
-  `--ambiguous-fraction <0.0-1.0>` allowed fraction of ambiguous (A OR B) gene length in a putative A+B contig [default: 0.1]
-  `--ambiguous-threshold <off/lenient/strict>` homology threshold for defining an ambiguous (A OR B) gene [default: lenient]
-  `--sister-penalty <off/lenient/strict>` penalize homologs of missing genes in sisters of LGT clades (or just recipient if known) [default: strict]
-  `--clade-genes <1-N>`   required minimum genes assigned to each LGT clade [default: off]
-  `--clade-leaves <1-N>`  required minimum leaf count supporting each LGT clade (or just recipient if known) [default: off]

gene-hit merge parameters:
 - `--weak-loci <ignore/penalize/assign-unknown>` method for handling loci that are never assigned to known clades [default: ignore]
 - `--annotation-threshold <off/lenient/strict>`  stringency of gene annotation transfer to loci [default: lenient]
 - `--min-overlap <0.0-1.0>` only merge hits into genes if the longer of the two covers this portion of the shorter [default: 0.1]
 - `--min-gene-length <int>` minimum allowed gene length [default: 200]
 - `--min-scov <float>`    (modified) scoverage filter for hits to gene catalog [default: 0.75]
 - `--stranded `           only merge hits into hits/genes of the same strandedness [default: off]

### Examining no-HGT contigs 

Most contigs are assigned to the `no_lgt` bin. They sugget to inspect it with:

```
cut -f1,4-7 contigs.no_lgt.tsv | less
```
Other columns include taxonomy, contig length and melded.

Example:
```
CONTIG_NAME  MIN_SCORE  AVG_SCORE  SYNTENY    CLADE
14237        0.983      0.989      AAAA       s__Faecalibacterium_prausnitzii
14258        0.950      0.994      AAAAAAAAA  s__Eubacterium_rectale
```

In the case of the first contig, 14237, these fields tell us that the contig was best explained by Faecalibacterium prausnitzii. The contig had four genes (evident from the AAAA synteny). F. prausnitzii had a minimum score over these genes of 0.983 (much greater than the threshold of 0.5), and its average score was similarly high at 0.989. We are very confident that this contig represents a fragment of F. prausnitzii genome.

### Examining HGT contigs 
These contigs are better explained by two clades, so they are putative LGT transfers. 

```
cut -f1,4-10 input_contigs.lgt.tsv
```
Other columns include taxonomy, contig length, melded, taxonomy, loci and uniprot annotation.

Example:
```
CONTIG_NAME  MIN_MAX_SCORE  AVG_MAX_SCORE  SYNTENY       DIRECTION  CLADE_A                     CLADE_B                          LCA
12571        0.856          0.965          AABAAAA       B>A        s__Ruminococcus_bromii      s__Faecalibacterium_prausnitzii  f__Ruminococcaceae
```
In the case of the first contig, 12571, these fields tell us that the contig was best explained by a putative LGT between Ruminococcus bromii and Faecalibacterium prausnitzii: two species that are related at the family level [according to the lowest common ancestor (LCA) field]. The synteny pattern AABAAAA suggests that a single F. prausnitzii gene (B) inserted into the R. bromii genome.
The min-max score entry indicates that, across the seven loci of this contig, one of these species always scored at least 0.856 (this exceeded the default k2 value of 0.8, allowing the LGT to be called).
