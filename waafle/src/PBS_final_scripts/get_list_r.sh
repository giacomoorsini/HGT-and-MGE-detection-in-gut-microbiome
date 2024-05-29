#!/bin/bash

#PBS -N getlistr
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=06:00:00
#PBS -q short_cpuQ
#PBS -e /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_tanzania/stdir/getlistr.err
#PBS -o /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_tanzania/stdir/getlistr.out

# Import paths from config file
source /home/giacomo.orsini-1/waafle/test_anal/src/config.sh

# Checkpoint
if [ -f "$META/${DATASET}_list.txt" ]; then
        echo "A list of file already exist, removing it..."
        rm "$META/${DATASET}_list.txt"
        if [ $? -eq 1 ]; then
                echo -e "Unable to remove the list. Aborting."
                exit 1
        fi
fi

echo  "Going trough data directory to extract list of files..."

# Go trough all the directories of the datadir and compute the name of the file to extract (spades)
for dir in $DATADIR/*; do

        dirname=$(basename $dir)

        filename="${dirname}.spades.fasta.bz2"

        # Checkpoint
        if [ $? -eq 1 ]; then
                echo -e "Unable to extract filename. Aborting"
                exit 1
        fi

        # Write the name in the list
        echo "$filename" >> "$META/${DATASET}_list.txt"

        # Checkpoint
        if [ $? -eq 1 ]; then
                echo -e "Unable to write filename into list. Aborting"
                exit 1
        fi
done

# Checkpoint
if [ $? -eq 0 ]; then

        # Count entries in list
        wc=$(wc "$META/${DATASET}_list.txt" | awk '{print $1}')

        # CHeckpoint
        if [ "$wc" -eq 0 ]; then
                echo -e "There are 0 files in the list, the script didn't run correctly. Aborting."
                rm "$META/${DATASET}_list.txt"

                if [ $? -eq 1 ]; then
                        echo "Unable to remove corrupted list."
                        exit 1
                else
                        exit 1
                fi
        fi

        echo "List created succesfully. There are $wc files in the list."

else
        echo "Unable to go trough the directory. Aborting."
        exit 1

fi
