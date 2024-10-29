# WAAFLE PBS scripts tutorial
Hereby the scripts I used to analyze my data with WAAFLE in an HPC cluster using the PBS job manager are reported. Some of the scripts are specific to how the data I used was stored. The scripts are made to work together, but they are not sequential, so you will have to issue them one at a time. This was made so as to leave the possibility of checking the output of each command. 

## Sripts
- `config.sh` stores all the paths to the files and outputs, as well as the file basenames.
- `get_list.sh`: this script takes as input a text file storing the path to the contigs. It outputs a list of all the files that will be used in the analysis.
- `manager.sh`: this script goes through the list created by the previous command and calls the full waafle pipeline on the sample.
- `waafle_run.sh`: this script calls all the waafle commands and performs a full analysis.
- `check_recover.sh`: this script checks if some samples were not analyzed.

### Version 1
The scripts work when the directory holding the files is in the form directory-directory-files
- `config.sh`: stores all the paths
- `get_list_r.sh`: this script takes as input a text file storing the path to the contigs. It outputs a list of all the contigs file that will then be used in the analysis
- `manager_r.sh`: this script goes trough the list created by the previous command and calls the full waafle pipeline on the sample
- `waafle_run_r.sh`: this script calls all the waafle commands and performs a full analysis
- `check_recover.sh`: this script checks if some samples were not analyzed
