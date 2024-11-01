#!/bin/bash

#PBS -N manager
#PBS -l select=1:ncpus=1:mem=10gb
#PBS -l walltime=12:00:00

#importing paths from configuration file
source /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/mge/genomad/src/config.sh

#activating conda env
source ~/miniconda3/bin/activate
conda activate genomad

#starting the times
SECONDS=0

# Extract the job id
job_id="$PBS_JOBID"

OUT="${HOMEDIR}/output/CM_ghanatanzania_animals"

# Extract the job name from the job ID. Adding prefix to match sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

# Checkpoint
if [ $? -eq 1 ]; then
        echo -e "Unable to retrieve sample name from job id. Aborting."
        exit 1
else
        echo -e "Executing genomad pipeline on sample: $SAMPLE"
fi

# Checkpoint
if [ ! -f "${GH_TH_animals_DIR}/${SAMPLE}_filtered_contigs.fa.bz2" ]; then
        echo -e "\t\t Unable to locate the contig file in original directory. Aborting."
        exit 1
fi

# Start waafle_search analysis
genomad end-to-end --cleanup --splits 8 "${GH_TH_animals_DIR}/${SAMPLE}_filtered_contigs.fa.bz2" $OUT $DB

# Checkpoint
if [ $? -eq 0 ]; then
        echo -e "Finished!"
else
        echo -e "Failed"
        exit 1
fi
