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
