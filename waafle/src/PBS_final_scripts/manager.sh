#!/bin/bash

#PBS -N manager
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l walltime=06:00:00
#PBS -q CIBIO_cpuQ
#PBS -o "/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/stdir/manager.out"
#PBS -e "/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/stdir/manager.err"

# Import paths from config file
source /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/src/config.sh

# Checkpoint
if [ -f "$META/${DATASET}_list.txt" ]; then
        echo "List of files exists, activating the script..."
        echo -e "Going trough list...\n"
else
        echo "Unable to locate the list of files. Aborting."
        exit 1
fi

# Go through all the lines of the list
while IFS= read -r line; do

        # Specify file path with or without directory prefix
        if [[ "$line" == */* ]]; then
                # If the path includes a directory (directory/file.suffix.bz2)
                SAMPLE=$(echo "$line" | awk -F "/" '{print $2}' | awk -F "$SUFFIX" '{print $1}')
                FILE="$CONTIGSDIR/$line"
        else
                # If the path does not include a directory (file.suffix.bz2)
                SAMPLE=$(echo "$line" | awk -F "$SUFFIX" '{print $1}')
                FILE="$CONTIGSDIR/$line"
        fi

        # Extract job id (NNNNN-TZ)
        JOBID=$(echo "$SAMPLE" | awk -F "-" '{print $2"-"$3}')
        UNZPFILE="${SAMPLE}${SUFFIX}"

        # Checkpoint
        if [ $? -eq 0 ]; then
                echo "Analyzing sample: $SAMPLE"
        else
                echo "Failed to retrieve the sample name from the list. Check $META/${DATASET}_list.txt. Aborting"
                exit 1
        fi

        # Checkpoint
        if [ -f "$TMP/$UNZPFILE" ]; then
                echo -e "\t Contigs are already present in the temporary directory, proceeding..."

        else

                if [ -f "$TMP/${UNZPFILE}.bz2" ]; then
                        echo -e "\t Zipped contigs are already present in the temporary directory, proceeding..."

                        # Unzip file
                        bzip2 -d $TMP/${UNZPFILE}.bz2

                        # Checkpoint
                        if [ $? -eq 1 ]; then
                                echo -e "\t Unable to unzip the file in the directory. Aborting."
                                exit 1
                        fi

                        echo -e "\t File unzipped correctly, proceeding..."
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
                        bzip2 -d $TMP/${UNZPFILE}.bz2

                        # Checkpoint
                        if [ $? -eq 1 ]; then
                                echo -e "\t Unable to unzip the file in the directory. Aborting."
                                exit 1
                        fi

                        echo -e "\t File copied and unzipped correctly, proceeding..."
                fi
        fi

        # Send waafle pipeline to the cluster
        echo -e "\t\t Sending job to cluster..."
        qsub -N $JOBID -o $STDDIR/waafle_complete${JOBID}.out -e $STDDIR/waafle_complete${JOBID}.err -q $QUEUE $SRCDIR/waafle_complete_run.sh
        # Checkpoint
        if [ $? -eq 1 ]; then
                echo -e "\t\t Unable to send the job to the cluster. Aborting."
                exit 1
        else
                echo -e "\t\t Job sent.\n"
        fi
        
        sleep 2

done < $META/${DATASET}_list.txt

if [ $? -ne 0 ]; then
        echo -e "Something went wrong when reading the list, aborting"
        exit 1
else
        echo -e "Finished!\n"
fi
