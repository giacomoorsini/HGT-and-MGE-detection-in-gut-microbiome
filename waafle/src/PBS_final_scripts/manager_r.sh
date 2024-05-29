#!/bin/bash

#PBS -N manager
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l walltime=06:00:00
#PBS -q CIBIO_cpuQ
#PBS -o "/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_tanzania/stdir/manager.out"
#PBS -e "/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_tanzania/stdir/manager.err"

# Import paths from config file
source /home/giacomo.orsini-1/waafle/test_anal/src/config.sh

# Checkpoint
if [ -f "$META/${DATASET}_list.txt" ]; then
        echo "List of file exists, activating the script..."
        echo -e "Going trough list...\n"
else
        echo "Unable to locate the list of files. Aborting."
        exit 1
fi

# Go trough all the lines of the list
while IFS= read -r line; do

        # Extract sample name
        SAMPLE=$(echo "$line" | awk -F "." '{print $1}')

        # Compute file path
        FILE=$DATADIR/$SAMPLE/$line

        # Extract sample name
        JOBID=$(echo "$SAMPLE" | awk -F "-" '{print $2"-"$3}')
        UNZPFILE=$(echo "$line" | awk -F ".bz2" '{print $1}')

        # Checkpoint
        if [ $? -eq 0 ]; then
                echo "Analyzing sample: $SAMPLE"
        else
                echo "Failed to retrieve the sample name from list. Check $META/${DATASET}_list.txt. Aborting"
                exit 1
        fi

        # Checkpoint
        if [ -f "$TMP/$UNZPFILE" ]; then
                echo -e "\tContigs are already present in temporary directory, proceeding..."
        fi

        if [ -f "$TMP/$line" ]; then
                echo -e "\tContigs are already present in temporary directory, proceeding..."
        else
                echo -e "\t Retrieving the contigs..."

                # Copy file
                cp $FILE $TMP

                # Checkpoint
                if [ $? -eq 1 ]; then
                        echo -e "\t Unable to copy file into directory. Aborting."
                        exit 1
                fi

                # Unzip file
                bzip2 -d $TMP/$line

                # Checkpoint
                if [ $? -eq 1 ]; then
                        echo -e "\t Unable to unzip file in directory. Aborting."
                        exit 1
                fi

                echo -e "\t File copied and unizpped correctly, proceeding..."
        fi
        
        # Send waafle pipeline to the cluster
        echo -e "\t\t Sending job to cluster..."
        qsub -N $JOBID -o $STDDIR/waafle_${JOBID}.out -e $STDDIR/waafle_${JOBID}.err -q $QUEUE $SRCDIR/waafle_run_recursive.sh

        # Checkpoint
        if [ $? -eq 1 ]; then
                echo -e "\t\t Unable to send job to the cluster. Aborting."
                exit 1
        else
                echo -e "\t\t Job sent."
        fi

        sleep 2

done < $META/${DATASET}_list.txt

echo -e "\n Finished succesfully."
