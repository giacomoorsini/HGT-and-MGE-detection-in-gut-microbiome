#!/bin/bash

#SBATCH --job-name=waafle_s
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --mem=2G
#SBATCH --time=08:00:00

#this script contains the waafle_search command and the instruction to send it as a job to slurm
SECONDS=0
source config.sh

SPLITDIR=$DATADIR"/splitted_input"

#waafle_search command
waafle_search --out $SEARCHFINAL"/search_$SLURM_ARRAY_TASK_ID.blastout" $SPLITDIR"/split$SLURM_ARRAY_TASK_ID.fa" $DBDIR
if [ $? -eq 0 ]; then
   echo "Job executed succesfully"
   #elapsed time
    duration=$SECONDS
    echo "Elapsed Time: $SECONDS seconds"
    echo "$(($duration / 3600)) hours and $((($duration % 3600)/60)) minutes elapsed."
    #echo "scale=2 ; $SECONDS / 3600" | bc
    echo "$((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
else
   echo "Job failed"
fi
