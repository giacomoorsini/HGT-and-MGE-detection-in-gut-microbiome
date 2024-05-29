#!/bin/bash

#PBS -N getmeta
#PBS -l select=2:ncpus=15:mem=15gb
#PBS -l walltime=24:00:00
#PBS -q common_cpuQ
#PBS -o /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/metachip/CM_tanzania2/stdir/get_metadata.out
#PBS -e /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/metachip/CM_tanzania2/stdir/get_metadata.err 

# Import PATHS from config file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0

# Initialize variables
RAW="$METADATA/raw_id_list.txt"
DATASETMAP="$MAPFILES/${DATASET}_datamap.tsv"
SGBS_MISS="$METADATA/${DATASET}_missing_SGBS.tsv"
remove_condition="True"
help_condition="False"

# Checkflags
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -h|--help)
        help_condition="True"
        shift # past argument
        shift # past value
        ;;
        -r|--remove)
        remove_condition="True"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        shift # past argument
        ;;
    esac
done

# Checkpoint
if [ "$help_condition" = "True" ]; then
        echo "Flags:                    -r | --remove : remove existing id list if present "$'\n'"                      -h | --help"
        exit 0
fi

# Checkpoint
if [ -f "$ID_LIST" ]; then
        echo "Id list already exists"
        if [ "$remove_condition" = "True" ]; then
                rm -f $ID_LIST
                if [ $? -eq 0 ]; then
                        echo "Id list removed, creating a new one..."
                else
                        echo "Unable to remove id list, proceeding with existing one"
                        exit 1
                fi
        else
                echo "Stopping the script, new id list not necessary"
                exit 0
        fi

fi

# Checkpoint
if [ -f "$TAX" ]; then
        echo "Taxonomy file already exists"
        if [ "$remove_condition" = "True" ]; then
                rm -f $TAX
                if [ $? -eq 0 ]; then
                        echo "Taxonomy file removed, creating a new one..."
                else
                        echo "Unable to remove taxonomy file, proceeding with existing one"
                        exit 1
                fi
        else
                echo "Stopping the script, new taxonomy file not necessary"
                exit 0
        fi

fi

# Checkpoint
if [ -f "$DATAMAP" ]; then
    echo "Datamap file exists"
    if [ -f "$DATASETMAP" ]; then
        echo "Datamap of dataset exists, starting analysis..."
        echo ""
    else
        echo "Datamap of dataset doesn't exist, creating it..."
        grep "${DATASET}__" $DATAMAP > $DATASETMAP
        if [ $? -eq 0 ]; then
                echo "$DATASETMAP created"
        else
                echo "Unable to create datamap for dataset. Aborting"
                exit 1
        fi
    fi
else
    echo "Datamap does not exist."
    exit 1
fi

# Iterate trough all the lines in the datamap file and extract the name of each MAG
while IFS= read -r line ; do
	
        #Extract MAG name and retain just the sample code
        SAMPLE_NAME=$(echo "$line" | cut -f 2 | awk -F "__bin" '{print $1}' | awk -F "__" '{print $2}')
	
	# Extract MAG name and code
        MAG_CODE=$(echo "$line" | cut -f 1 )
        MAG_NAME=$(echo "$line" | cut -f 2 | awk -F "__" '{print $2}')
	
        # Extract tax path and adapt it to metachip format
        TAX_PATH=$(grep -w "$MAG_CODE" "$SGB_FILE" | cut -f 10 | sed 's/|/;/g' | cut -d ";" -f 1,2,3,4,5,6,7)
	
	if [ $? -eq 1 ]; then
                echo "Unable to recover tax path"
		exit 1
        fi
	
	# Modify absent tax path
        if [ -z "$TAX_PATH" ]; then
                TAX_PATH="missing_SGB"
                echo -e "$MAG_NAME\t$TAX_PATH"
                continue
        fi

        # Write the mag name and its tax path into an intermediate file
        
	echo -e "$MAG_NAME\t$TAX_PATH" >> $TAX
	
	if [ $? -eq 1 ];then	
		echo "Unable to write into taxonomy file"
		exit 1
	fi

        #Echo the MAG name in an intermediate file
        echo -e "$SAMPLE_NAME" >> $RAW
	
	if [ $? -eq 1 ]; then
                echo "Unable to write into id list"
		exit 1
        fi

done < $DATASETMAP

# Checkpoint
if [ $? -eq 0 ]; then
    echo "Taxonomy results stored in $TAX"
    echo "Partial id list results stored in $RAW"
    echo "Correcting the id list..."
else
    echo "Unable to retrieve raw id list and taxonomy file. Check paths are correct. Aborting"
    exit 1
fi

# Collapse all mags of the same sample into one
uniq $RAW > $ID_LIST

# Checkpoint
if [ $? -eq 0 ]; then
    echo "All ids have been stored in $ID_LIST"
    rm $RAW
    if [ $? -eq 0 ]; then
        echo "$RAW removed"
    else
        echo "Unable to remove $RAW"
    fi
    echo "There are $(wc $ID_LIST | awk '{print $1}') samples"
    echo ""
else
    echo "Error: unable to correct ids"
fi

# Checkpoint
if [ -f "$SGBS_MISS" ]; then
        echo "Missing SGBS list already exist"
        if [ "$remove_condition" = "True" ]; then
                rm -f $SGBS_MISS
                if [ $? -eq 0 ]; then
                        echo "Missing SGBS list removed, creating a new one..."
                else
                        echo "Unable to remove missing SGBS list, proceeding with existing one"
                        exit 1
                fi
        else
                echo "Stopping the script, new list not necessary"
                exit 0
        fi

fi

# Creating missing SGBS file
echo "Checking for missing SGBS..."
grep "missing_SGB" $TAX > $SGBS_MISS

# Checkpoint
if [ $? -eq 0 ]; then
   FAILEDSGB=$(grep -c "missing" $SGBS_MISS)
   echo "$FAILEDSGB SGBS don't have a taxonomic path"
else
   failed_count=$(wc $SGBS_MISS | awk '{print $1}')
   if [ $? -eq 1 ]; then	
       echo "Unable to calculate missing SGBS. Check manually. Exiting the script"
       exit 1
   else
       echo "There are no missing SGBS"
       rm -f $SGBS_MISS
   fi
fi

#Checkpoint
if [ -d "$MAGS_IN_DATASET" ]; then
        echo "A folder containing mags has been located: $MAGS_IN_DATASET"
        mags_number_infile=$(wc $TAX | awk '{print $1}')
        mags_number_infolder=$(ls $MAGS_IN_DATASET -1 | wc -l )
        if [ $? -eq 0 ]; then
        	echo "There are $mags_number_infolder mags in the folder and $mags_number_infile mags in the file. If the numbers are significantly different (+1) consider understanding why."
	else
		echo "Check manually if the numbers are the same or some MAGS are missing."
	fi
	echo ""
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
