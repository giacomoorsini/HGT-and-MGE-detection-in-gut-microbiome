#!/bin/bash

#PBS -N manager
#PBS -l select=1:ncpus=10:mem=10gb
#PBS -l walltime=24:00:00
#PBS -q common_cpuQ
#PBS -o /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/metachip/CM_tanzania2/stdir/manager.out
#PBS -e /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/metachip/CM_tanzania2/stdir/manager.err

# Import all the paths to file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0

echo "Executing the metachip PI script"

# Checkpoint
if [ -f "$ID_LIST" ]; then
    echo "Id list exists. Proceeding..."
else
    echo "Id list does not exist. Aborting."
    exit 1
fi

# Read all the ids in the id_list.txt and for each send a job to download and unzip the MAGS and a job to execute metachip PI
while IFS= read -r line; do

	# Sample id
        SAMPLE=$(echo $line)

        echo "Analyzing sample $SAMPLE"

        # Jobname will be the sample stripped of the prefix, for space reasons
        JOBNAME=$(echo $SAMPLE | awk -F - '{print $2"-"$3}')

	# Send job to execute metachip PI command with dependency
        qsub -N $JOBNAME -o $STDIR/$SAMPLE.out -e $STDIR/$SAMPLE.err -q $PARTITION $SRC/metachip.sh

	if [ $? -eq 0 ]; then
                echo "Metachip sent as a job"
        else
                echo "Error: unable to send metachip PI job. Aborting."
                exit 1
        fi

	sleep 5

done < $ID_LIST

# Checkpoint
if [ $? -eq 0 ]; then
                echo "All the metachip analysis of samples present in the id list have been sent to the cluster. Proceeding... "
        else
                echo "Unable to iterate trough the id list. Aborting."
                exit 1
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
