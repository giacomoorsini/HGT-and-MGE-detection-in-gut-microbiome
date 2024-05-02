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
for dir in "$MAGS"/C16*; do
        dirname=$(basename "$dir")
        for file in "$dir"/*; do

                filename=$(basename "$file")
                MAG_NAME=$(echo "$filename" | cut -d . -f 1,2)

                MAG=$(grep -w $MAG_NAME "$MAGS_FILE")

                if [ -z "$MAG" ]; then
                        echo -e "$MAG_NAME\tmissing_MAG"
                        continue
                fi
                SGB_CODE=$(echo "$MAG" | awk '{gsub("SGB", "", $8); print $8}')
                echo $SGB_CODE
                TAXONOMICAL_PATH=$(grep -Fw "$SGB_CODE" "$SGB_FILE" | awk '{print $2}')
                TAXONOMICAL_PATH=$(echo "$TAXONOMICAL_PATH" | sed 's/|/;/g')
                        if [ -z "$TAXONOMICAL_PATH" ]; then
                                TAXONOMICAL_PATH="missing_SGB"
                                echo -e "$MAG_NAME\t$SGB_CODE\t$TAXONOMICAL_PATH"
                                continue
                        fi

                #write MAG name and TAX PATH in tsv file
                echo -e "$MAG_NAME\t$TAXONOMICAL_PATH"
        done >> $METADATA/raw_taxonomy.tsv
done

if [ $? -eq 0 ]; then
   echo "Results stored in raw_taxonomy.tsv"
else
   echo "Error: unable to retrieve taxonomy. Aborting."
   exit 1
fi

#Creating missing files
grep "missing_MAG" $METADATA/raw_taxonomy.tsv > $METADATA/${DATASET}_missing_MAGS.tsv
grep "missing_SGB" $METADATA/raw_taxonomy.tsv > $METADATA/${DATASET}_missing_SGBS.tsv

#Exclude the last tax node (t_SGBxxxx) for metachip

echo "Correcting raw_taxonomy.tsv"

grep -v "missing_MAG" $METADATA/raw_taxonomy.tsv | grep -v "missing_SGB" | cut -d ";" -f 1,2,3,4,5,6,7 > $METADATA/${DATASET}_taxonomy.tsv

if [ $? -eq 0 ]; then
   echo "Taxonomy stored in $METADATA/${DATASET}_taxonomy.tsv"

   rm $METADATA/raw_taxonomy.tsv

   if [ $? -eq 0 ]; then
       echo "raw_taxonomy.tsv removed"
   else
       echo "Error: raw_taxonomy.tsv not removed"
   fi

   FAILEDMAG=$(grep -c "missing" $METADATA/${DATASET}_missing_MAGS.tsv)
   FAILEDSGB=$(grep -c "missing" $METADATA/${DATASET}_missing_SGBS.tsv)
   echo "$FAILEDMAG MAGS are not annotated taxonomically"
   echo "$FAILEDSGB SGBS don't have a taxonomic path"

else
   echo "Error: results not outputted correctly"
   exit 1
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
