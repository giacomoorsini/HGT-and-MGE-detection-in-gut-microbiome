# WAAFLE TUTORIAL
This is a brief tutorial to use waafle. All information are taken from the waafle github repository. 
## How to install
To install the tool, we made a conda enviroment which contain all the dependencies to make it work. The YAML file can be found in waafle.yml. You will just have to issue the command:
`conda env create -f waalfe.yml`
## How to use the tool
The pipeline requires the issue of 3 different commands: 
- `waafle_search` used to search the input contigs against the WAAFLE-formatted database
- `waafle_genecaller` to identify gene coordinates of interest directly from the BLAST output produced in the previous step 
- `waafle_orgscorer` identify contigs derived from a single clade or pair of clades
## waafle_search
This script executes a custom BLAST search of a set of contigs against a WAAFLE-formatted database. A sample call to `waafle_search` with input contigs `input.fna` and the WAAFLE database (or a costum database) located in a directory would be: 

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

