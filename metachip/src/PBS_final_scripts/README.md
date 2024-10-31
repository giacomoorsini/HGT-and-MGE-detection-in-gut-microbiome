# MetaCHIP PBS scripts tutorial
Hereby, the scripts I used to analyze my data with MetaCHIP in an HPC cluster using the PBS job manager are reported. The scripts are specific to the situation I had to deal with, the storage strcuture and the data types.
Moeover, the scripts assume that you ar eworking in a conda environment called `metachip`. The scripts are made to work together, but they are not sequential, so you will have to issue them one at a time. This was made so as to leave the possibility of checking the output of each command.

## Scripts
- `config.sh` : stores all the paths to the files and outputs, as well as the file basenames.
- `get_metadata.sh` :
- `manager.sh`: this script goes through the list created by the previous command and calls the full metaCHIP pipeline on the sample.
- `metachip.sh` : contains all the metaCHIP commands.

## How do they work
### - Setup the `config.sh` file
The config.sh file stores all the paths to the main directories, input file directories, output directories, cluster-related settings, and input file suffixes. Adapt it to your data structure. This file will be imported into each of the other scripts. To change paths and input files in the other scripts, you will have to modify the config file.
