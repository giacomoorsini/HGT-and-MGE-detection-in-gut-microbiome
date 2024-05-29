#!/bin/bash

# Import PATHS from config file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0

if [ -d "$MAGS" ]; then
    file_count=$(find $MAGS -maxdepth 1 -type f | wc -l)
    echo "Retrieving sample ids for $file_count files. Be patient."
else
    echo "Error: MAGS directory does not exist."
    exit 1
fi

# Iterate trough all the MAGS in folder and extract their name
for file in "$MAGS"/*.bz2; do

        filename=$(basename "$file")

        MAG_NAME=$(echo "$filename" | cut -d _ -f 1)

        echo -e "$MAG_NAME"

done > $METADATA/raw_id_list.txt

if [ $? -eq 0 ]; then
    echo "Results stored in $METADATA/raw_id_list.txt"
    echo "Correcting the id list"
else
    echo "Error: unable to retrieve taxonomy. Check paths are correct. Aborting"
    exit 1
fi

# Collapse all mags of the same sample
uniq $METADATA/raw_id_list.txt > $ID_LIST

if [ $? -eq 0 ]; then
    echo "All ids have been stored in $ID_LIST"
    echo "There are $(wc $ID_LIST | awk '{print $1}') samples"
    rm $METADATA/raw_id_list.txt
    echo "$METADATA/raw_id_list.txt removed"
else
    echo "Error: unable to correct ids"
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
