#!/bin/bash

#PBS -N recover
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l walltime=06:00:00
#PBS -q CIBIO_cpuQ
#PBS -o "/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/stdir/check_recover.out"
#PBS -e "/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/stdir/check_recover.err"

# Import paths from config file
source /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/src/config.sh

# number of files in the temporary directory (if the file is still there it means that the script didn't run succesfully)
num_files=$(ls $TMP -1 | wc -l)

# Checkpoint
if [ "$wc" -eq 0]; then
        echo "There are no files in data directory, all the analysis ran correctly. Finished."
        exit 0
fi

echo "In data directory there are $num_files contigs file that have not been analyzed correctly, calling waafle_run again..."

ls $TMP

# Go trough the files in the directory and send again the waafle job
for file in $TMP/*; do

        if [[ $file == *.bz2 ]]; then
                bzip2 -d $file
                if [ $? -eq 0 ]; then
                        echo "Unable to unzip the file"
                else
                        echo "unzipping the file"
                fi
        fi

        # Extract filename
        filename=$(basename $file)

        JOBID=$(echo "$filename" | awk -F "$SUFFIX" '{print $1}' | awk -F "-" '{print $2"-"$3}' )

        # Checkpoint
        if [ $? -eq 0 ]; then
                echo "Analyzing sample: $JOBID"
        else
                echo "Failed to retrieve the sample name from folder. Check $TMP. Aborting"
                exit 1
        fi

        # Send job to cluster
        qsub -N $JOBID -o $STDDIR/waafle_${JOBID}.out -e $STDDIR/waafle_${JOBID}.err -q $QUEUE $SRCDIR/waafle_run.sh

        # Checkpoint
        if [ $? -eq 1 ]; then
                echo -e "\t Unable to send job to the cluster. Aborting."
                exit 1
        else
                echo -e "\t Job sent."
        fi

        sleep 2

done

# Checkpoint
if [ $? -eq 0 ]; then
        echo "Gone trough all the files in the directory. Finished."
else
        echo "Failed to go trough the files in the directoryry. Aborting."
        exit 1
fi
else
        echo "Failed to go trough the files in the directoryry. Aborting."
        exit 1
fi
