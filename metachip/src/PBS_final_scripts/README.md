# MetaCHIP PBS scripts tutorial
Hereby, the scripts I used to analyze my data with MetaCHIP in an HPC cluster using the PBS job manager are reported. The scripts are specific to the situation I had to deal with, as well as the storage structure and the data types.
Moreover, the scripts assume that you are working in a conda environment called `metachip`. The scripts are made to work together, but they are not sequential, so you will have to issue them one at a time. This was made so as to leave the possibility of checking the output of each command.

## Scripts
- `config.sh` : stores all the paths to the files and outputs, as well as the file basenames.
- `get_metadata.sh` :
- `manager.sh`: this script goes through the list created by the previous command and calls the full metaCHIP pipeline on the sample.
- `metachip.sh` : contains all the metaCHIP commands.

## How do they work
### - Setup the `config.sh` file
The config.sh file stores all the paths to the main directories, input file directories, output directories, cluster-related settings, and input file suffixes. Adapt it to your data structure. This file will be imported into each of the other scripts. To change paths and input files in the other scripts, you will have to modify the config file.
### - Retrieve a list of files with `get_metadata.sh`
The main script requires a list of sample IDs to work. This script creates the id list, the taxonomy file and a datamap. For how my files were stored, I had a text file with all the paths to the .fasta files of my samples. To create the datamap, the scripts just filter the lines of the text file to find the ones belonging to the dataset of interest. Then, starting from the datamap, it goes through the lines and extracts the sample name and the file name. From the other two files containing the taxonomic species associated with the genomes and the full taxonomic path associated with the species, the script is able to create a taxonomy file containing each genome and its the full taxonomic path.
### - Issue the `manager.sh` script
This script is the core of the method. It will issue the metachip.sh script that, in turn, will execute the full metachip pipeline on the input files. In particular, it goes through the sample ID list, and it sends a job to the cluster for each sample, with the ID as a name. Please be mindful that this step is necessary as the next script recognizes the sample name from the title of the job issued and may not be suited for your situation. 
### - Full metaCHIP pipeline in `metachip.sh`
This script first reads the sample name from the job name and extracts all the genomes belonging to that sample from the datamap. It then copies all these genomes to a temporary directory and unzips them. Finally, it calls the two metaCHIP commands.
