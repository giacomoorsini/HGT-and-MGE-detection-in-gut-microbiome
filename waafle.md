# WAAFLE TUTORIAL
This is a brief tutorial to use waafle. All information are taken from the waafle github repository https://github.com/biobakery/waafle/tree/main. 
## How to install
To install the tool, we made a conda enviroment which contain all the dependencies to make it work. The YAML file can be found in waafle.yml. You will just have to issue the command:
`conda env create -f waafle.yml`
## How to use the tool
The pipeline requires the issue of 3 different commands: 
- `waafle_search` used to search the input contigs against the WAAFLE-formatted database
- `waafle_genecaller` to identify gene coordinates of interest directly from the BLAST output produced in the previous step 
- `waafle_orgscorer` identify contigs derived from a single clade or pair of clades
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

- \b seqname \ - name of the chromosome or scaffold; chromosome names can be given with or without the 'chr' prefix. Important note: the seqname must be one used within Ensembl, i.e. a standard chromosome name or an Ensembl
- identifier such as a scaffold ID, without any additional content such as species or assembly. See the example GFF output below.
- source - name of the program that generated this feature, or the data source (database or project name)
- feature - feature type name, e.g. Gene, Variation, Similarity
- start - Start position* of the feature, with sequence numbering starting at 1.
- end - End position* of the feature, with sequence numbering starting at 1.
- score - A floating point value.
- strand - defined as + (forward) or - (reverse).
- frame - One of '0', '1' or '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on..
- attribute - A semicolon-separated list of tag-value pairs, providing additional information about each feature.

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

Tunable commands from the `--help` menu are:

`waafle_orgscorer.py [-h] [--outdir <path>] [--basename <str>]
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
                           contigs blastout gff taxonomy`
