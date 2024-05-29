#!/bin/bash

#PBS -N mchipBP
#PBS -l select=1:ncpus=10:mem=10gb
#PBS -l walltime=24:00:00

# Import all paths from cofig file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0

# Give extra time for metachip PI jobs to finish
sleep 60

#reset the id_list.txt to read it again from the beginning
dd if="$ID_LIST" of=/dev/null bs=1 seek=0

if [ $? -eq 0 ]; then
    echo "Reset reader for $ID_LIST"
else
    echo "Error: unable to reset the reader. Aborting."
    exit 1
fi

# Loop to iterate again trough all the ids of the id_list.txt and analyze current sample
while IFS= read -r line; do

        # Extract current sample
        SAMPLE=$(echo $line)

        echo "Analyzing sample $SAMPLE"

        # Jobname will be the sample stripped of the prefix, for space reasons
        JOBNAME=$(echo $SAMPLE | awk -F - '{print $2"-"$3}')

        # Send job to execute metachip BP
        job3_id=$(qsub -N $JOBNAME -o $STDIR/BP_$SAMPLE.out -e $STDIR/BP_$SAMPLE.err -q $PARTITION $SRC/BP.sh)

        if [ $? -eq 0 ]; then
                echo "Job sent"
        else
                echo "Error: unable to send job. Aborting."
                exit 1
        fi

        # Give time for the job to be sent
        sleep 20

done < $ID_LIST

if [ $? -eq 0 ]; then
        echo "BP script executed succesfully"
else
        echo "Error. BP not executed"
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
