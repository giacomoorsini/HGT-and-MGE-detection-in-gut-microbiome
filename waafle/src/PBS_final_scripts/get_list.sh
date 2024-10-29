#!/bin/bash

#PBS -N getlistr
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=06:00:00
#PBS -q short_cpuQ
#PBS -e /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/stdir/getlist.err
#PBS -o /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/stdir/getlist.out

# Import paths from config file
source /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/src/config.sh

# Checkpoint
if [ -f "$META/${DATASET}_list.txt" ]; then
        echo "A list of file already exist, removing it..."
        rm "$META/${DATASET}_list.txt"
        if [ $? -eq 1 ]; then
                echo -e "Unable to remove the list. Aborting."
                exit 1
        fi
fi

echo "Going through data directory to extract a list of files..."

# Go trough all the directories of the datadir and compute the name of the file to extract (spades)
for item in "$CONTIGSDIR"/*; do
        if [ -d "$item" ]; then
                # If the item is a directory, look for the correct files inside it
                dirname=$(basename "$item")
                filename="${dirname}${SUFFIX}.bz2"
                if [ $? -eq 1 ]; then
                        echo -e "Unable to extract the filename. Aborting"
                        exit 1
                fi

        elif [ -f "$item" ]; then
                # If the item is a .fasta.bz2 file directly in CONTIGSDIR
                filename=$(basename "$item")
                if [ $? -eq 1 ]; then
                        echo -e "Unable to extract the filename. Aborting"
                        exit 1
                fi

        else
                echo "Empty directory"
        fi

        # Write the name in the list
        echo "$filename" >> "$META/${DATASET}_list.txt"

        # Checkpoint
        if [ $? -eq 1 ]; then
                echo -e "Unable to write filename into the list. Aborting"
                exit 1
        fi
done

# Checkpoint
if [ $? -eq 0 ]; then

        # Count entries in list
        wc=$(wc "$META/${DATASET}_list.txt" | awk '{print $1}')

        # CHeckpoint
        if [ "$wc" -eq 0 ]; then
                echo -e "There are 0 files in the list. The script didn't run correctly. Aborting."
                rm "$META/${DATASET}_list.txt"

                if [ $? -eq 1 ]; then
                        echo "Unable to remove corrupted list."
                        exit 1
                else
                        exit 1
                fi
        fi

        echo "List created successfully. There are $wc files in the list."

else
        echo "Unable to go through the directory. Aborting."
        exit 1

fi
        echo "Unable to go through the directory. Aborting."
        exit 1

fi
