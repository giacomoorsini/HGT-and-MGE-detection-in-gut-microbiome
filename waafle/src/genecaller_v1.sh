#!/bin/bash

source config.sh

num_search=$(ls $SEARCHFINAL | wc -l)
(( num_search -= 1 ))
echo "Sending $num_search jobs to slurm"

sbatch --output=$GCALLOUT"/genecall_%A_%a.out" --error=$GCALLERR"/genecall_%A_%a.err" --array=0-$num_search waafle_genecaller.sh  

#elapsed time
echo "Script executed"
