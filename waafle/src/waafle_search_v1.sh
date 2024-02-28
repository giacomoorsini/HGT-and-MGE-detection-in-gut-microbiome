#!/bin/bash

#SBATCH --job-name=waafle_search
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --mem=2G
#SBATCH --time=08:00:00

SECONDS=0

source config.sh

SPLITDIR=$DATADIR"/splitted_input"

waafle_search --out $SEARCHFINAL"/search_$SLURM_ARRAY_TASK_ID.blastout" $SPLITDIR"/split$SLURM_ARRAY_TASK_ID.fa" $DBDIR

#elapsed time
echo "Job executed"
duration=$SECONDS
echo "Elapsed Time: $SECONDS seconds"
echo "$(($duration / 3600)) hours and $((($duration % 3600)/60)) minutes elapsed."
#echo "scale=2 ; $SECONDS / 3600" | bc
echo "$((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
