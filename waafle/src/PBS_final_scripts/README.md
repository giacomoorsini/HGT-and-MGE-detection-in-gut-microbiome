# WAAFLE PBS scripts tutorial
Hereby, the scripts I used to analyze my data with WAAFLE in an HPC cluster using the PBS job manager are reported. Some of the scripts are specific to how the data I used was stored; in particular, data were stored in two different structures:  
```
main_directory|
              |__sample1
              |__sample2
                ...
OR
main_directory|
              |__directory1/sample1
              |__directory2/sample2
                ...
```
and had the suffix `.filtered_contigs.fa` or `_filtered_contigs.fa` or `.spades.fasta`.
Moreover, these scripts assume that you are working in a Conda environment called `waafle`. The scripts are made to work together, but they are not sequential, so you will have to issue them one at a time. This was made so as to leave the possibility of checking the output of each command. 

## Sripts
- `config.sh` stores all the paths to the files and outputs, as well as the file basenames.
- `get_list.sh`: this script takes as input a text file storing the path to the contigs. It outputs a list of all the files that will be used in the analysis.
- `manager.sh`: this script goes through the list created by the previous command and calls the full waafle pipeline on the sample.
- `waafle_complete_run.sh`: this script calls all the waafle commands and performs a full analysis.
- `check_recover.sh`: this script checks if some samples were not analyzed.

### How do they work

#### - Setting up all the paths in the `config.sh` file

The `config.sh` file stores all the paths to the main directories, input file directories, output directories, cluster-related settings, and input file suffixes. Adapt it to your data structure.
This file will be imported into each of the other scripts. To change paths and input files in the other scripts, you will have to modify the `config` file.

#### - Create a list of input files with the `get_list.sh` script

The main script requires a list of input files in order to work. The list can be manually computed or created automatically with this script. The list will have to be in the form:
```
file1.suffix
file2.suffix
file3.suffix

OR

directory/file1.suffix
directory/file2.suffix
directory/file3.suffix
...
```
The script essentially goes through the data directory and extracts the basename of each file's path. Please be mindful that the script works for the structure I had to deal with.

#### - Issue the `manager.sh` script
This script is the core of the method. It will call all the waafle commands stored in the `waafle_complete_run.sh` script for each file of the list given as input.
In particular, it first copies the contigs file into a local directory (considering a situation in which original files are stored in the cluster and can't be modified) and unzip them (considering files are zipped due to their large size). It then calls the next script, giving the sample name as the title of the job. Please be mindful that this step is absolutely necessary as the next script recognizes the sample name from the title of the job issued and may not be suited for your situation. The contigs files will be eliminated after the analysis is completed

#### - Waafle commands in `waafle_complete_run.sh`
This script simply issues all the waafle commands in order on the input data. The config file places all the partial and final outputs in the correct directories.

#### - Check if all samples were analyzed correctly with `check_recover.sh`
This optional script checks if some files in the temporary data directory (the initial input contigs file) have not been eliminated. There is a high probability that these files were not analyzed correctly. It tells you which samples had this problem so you can further check the error log, and it automatically tries to send the jobs to the cluster again.
