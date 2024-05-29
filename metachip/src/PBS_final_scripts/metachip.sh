#!/bin/bash

#PBS -l select=2:ncpus=15:mem=20gb
#PBS -l walltime=24:00:00

source /home/giacomo.orsini-1/metachip2/src/config.sh

source ~/miniconda3/bin/activate

# Initialize timer
SECONDS=0

# Initialize variables
job_id="$PBS_JOBID"

# Extract the job name from the job ID and add the prefix to reconstruct sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

# Create datamap of sample
SAMPLE_MAP="$MAPFILES/${DATASET}_${SAMPLE}.tsv"

# Checkpoint
if [ -f "$SAMPLE_MAP" ]; then
    echo "$SAMPLE datamap already exists. Proceeding..."
else
    grep "$SAMPLE" $DATAMAP > $SAMPLE_MAP
    if [ $? -eq 0 ]; then
        echo "$SAMPLE datamap created"
    else
        echo "Unable to locate or create $SAMPLE datamap. Aborting."
        exit 1
    fi
fi

echo "Taking bins of sample $SAMPLE"

# Create temporary directory for the sample
SAMPLE_DIR="$DATA/$SAMPLE"

# Checkpoint
if [ -d "$SAMPLE_DIR" ]; then
    #rm $SAMPLE_DIR/*
    echo "$SAMPLE directory already exists. Proceeding..."
else
    mkdir $SAMPLE_DIR
    if [ $? -eq 0 ]; then
        echo "$SAMPLE directory created"
    else
        echo "Unable to locate or create $SAMPLE directory. Aborting."
        exit 1
    fi
fi

# Go trough all the lines of the datamap and extract magname and path. Copy all the bins of the sample into the sample directory
echo "Copying the bins to $SAMPLE_DIR"

#For the animals dataset
cp /shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghanatanzania_animals/hq_mq_mags/${SAMPLE}* $SAMPLE_DIR

#For the other datasets
#while IFS= read -r line; do
#
#        MAG_NAME=$(echo "$line" | cut -f 2 | awk -F "CM_" '{print $2}')
#        FILEPATH=$(echo "$line" | cut -f 5)

#        cp $FILEPATH $SAMPLE_DIR/${MAG_NAME}.fa.bz2

#done < $SAMPLE_MAP

# Checkpoint
if [ $? -eq 0 ]; then
   echo "All mags copied to $SAMPLE_DIR"
else
   echo "Wrong command or path. Aborting."
   exit 1
fi

# Unzip all the files
echo "Unzipping the files"
bzip2 -d $SAMPLE_DIR/*

# Checkpoint
if [ $? -eq 0 ]; then
   echo "All files unzipped. Removing $SAMPLE datamap..."
   rm $SAMPLE_MAP
   if [ $? -eq 0 ]; then
       echo "Finished."
   else
       echo "Unable to remove $SAMPLE datamap. Finished."
   fi
else
   echo "Unable to unzip the files. Aborting."
   exit 1
fi
# activate environment needed
conda activate metachip

# Metachip PI command
MetaCHIP PI -p $SAMPLE -r pcofgs -i $SAMPLE_DIR -x fa -taxon $TAX -t 60 -force -o $OUT/$SAMPLE

# Checkpoint
if [ $? -eq 0 ]; then
   echo "Metachip PI analysis completed"
   if [ -d "$OUT/$SAMPLE" ]; then
       echo "Results in folder $OUT/$SAMPLE"
   else
       echo "Ouput directory does not exist"
   fi
else
   echo "Error: analysis failed. Aborting."
   exit 1
fi

# Remove the sample directory to save space
rm -r $SAMPLE_DIR

if [ $? -eq 0 ]; then
   echo "Sample directory removed"
else
   echo "Error: unable to remove sample dir"
fi

# Metachip BP command
MetaCHIP BP -p $SAMPLE -r pcofgs -t 60 -force -o $OUT/$SAMPLE

# Checkpoint
if [ $? -eq 0 ]; then
   echo "Metachip BP analysis completed"
else
   echo "Error: BP analysis failed"
fi

conda deactivate

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
