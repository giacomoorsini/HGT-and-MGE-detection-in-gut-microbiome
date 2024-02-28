#!/bin/bash

#SBATCH --job-name=waafle_orgscorer
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --mem=2G
#SBATCH --time=08:00:00

SECONDS=0

source config.sh 

waafle_orgscorer --outdir $OSCORFINAL $INPUTFILE $SEARCHFINAL"/search.blastout" $GCALLFINAL"/genecall.gff" $TAXONOMY

#elapsed time
echo "Job executed"
duration=$SECONDS
echo "Elapsed Time: $SECONDS seconds"
echo "$(($duration / 3600)) hours and $((($duration % 3600)/60)) minutes elapsed."
#echo "scale=2 ; $SECONDS / 3600" | bc
echo "$((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
