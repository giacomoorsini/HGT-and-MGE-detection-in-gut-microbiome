#!/bin/bash

# Import PATHS from config file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0

if [ -d "$MAGS" ]; then
    file_count=$(find $MAGS -maxdepth 1 -type f | wc -l)
    echo "Retrieving taxonomy for $file_count files. Be patient."
else
    echo "Error: Directory does not exist."
    exit 1
fi

# Iterate trough all the MAGS in dataset folder
for file in "$MAGS"/*.bz2; do

        # Extract filename
        filename=$(basename "$file")

        # MAG name is equal to the filename without the extension .fa.bz2
        MAG_NAME=$(echo "$filename" | cut -d . -f 1,2)

        # From the file with corresponding SGB for each MAG extract the line of current MAG
        MAG=$(grep -w ${DATASET}__${MAG_NAME} "$MAGS_FILE")

        # If can't find the MAG in the file return root
        if [ -z "$MAG" ]; then
                echo -e "$MAG_NAME\tr__root"
                continue
        fi

        # From the line extract the SGB code
        SGB_CODE=$(echo "$MAG" | awk '{gsub("SGB", "", $4); print $4}')

        # In the file containing tax path for each SGB extract the exact code
        TAXONOMICAL_PATH=$(grep -Fw "$SGB_CODE" "$SGB_FILE" | awk '{print $2}')

        # Change the format for for metachip
        TAXONOMICAL_PATH=$(echo "$TAXONOMICAL_PATH" | sed 's/|/;/g')

        # If SGB is not in the file return root
        if [ -z "$TAXONOMICAL_PATH" ]; then
                TAXONOMICAL_PATH="r__root"
                echo -e "$MAG_NAME\t$TAXONOMICAL_PATH"
                continue
        fi

        #write MAG name and TAX PATH in tsv file
        echo -e "$MAG_NAME\t$TAXONOMICAL_PATH"

done > $METADATA/raw_taxonomy.tsv

if [ $? -eq 0 ]; then
   echo "Results stored in raw_taxonomy.tsv"
else
   echo "Error: unable to retrieve taxonomy. Aborting."
   exit 1
fi

#Exclude the last tax node (t_SGBxxxx) for metachip

echo "Correcting raw_taxonomy.tsv"

cut -d ";" -f 1,2,3,4,5,6,7 $METADATA/raw_taxonomy.tsv > $METADATA/${DATASET}_taxonomy.tsv

if [ $? -eq 0 ]; then
   echo "Taxonomy stored in $METADATA/${DATASET}_taxonomy.tsv"

   rm $METADATA/raw_taxonomy.tsv

   if [ $? -eq 0 ]; then
       echo "raw_taxonomy.tsv removed"
   else
       echo "Error: raw_taxonomy.tsv not removed"
   fi

   FAILED=$(grep -c "r__root" $METADATA/${DATASET}_taxonomy.tsv)
   echo "$FAILED MAGS don't have taxonomic path"

else
   echo "Error: results not outputted correctly"
   exit 1
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
