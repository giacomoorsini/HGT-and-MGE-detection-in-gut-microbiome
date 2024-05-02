#!/bin/bash

#PBS -l select=1:ncpus=10:mem=10gb
#PBS -l walltime=24:00:00

source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0
# Retrieve the job ID from the environment variable
job_id="$PBS_JOBID"

# Extract the job name from the job ID and add the prefix to reconstruct sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

echo "Taking bins of sample $SAMPLE"

# Create temporary directory for the sample
SAMPLE_DIR="$DATA/$SAMPLE"

if [ -d "$SAMPLE_DIR" ]; then
    echo "Directory already exists."
else
    mkdir $SAMPLE_DIR
    if [ $? -eq 0 ]; then
        echo "Folder created"
    else
        echo "Error: wrong path. Aborting."
        exit 1
    fi
fi

# Copy all the bins of the sample into the sample directory

echo "Copying the bins to $SAMPLE_DIR"

cp "$MAGS/$SAMPLE/"* $SAMPLE_DIR

if [ $? -eq 0 ]; then
   echo "Files copied"
else
   echo "Error: wrong command or path. Aborting."
   exit 1
fi

# Unzip the files

echo "Unzipping the files"
bzip2 -d $SAMPLE_DIR/*

if [ $? -eq 0 ]; then
   echo "Files unzipped"
   echo "Proceed"
else
   echo "Error: wrong command or path. Aborting."
   exit 1
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
