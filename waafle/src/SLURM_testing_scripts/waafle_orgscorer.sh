#!/bin/bash

#SBATCH --job-name=waafle_orgscorer
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --mem=2G
#SBATCH --time=08:00:00

#this script contains the waafle_orgscorer command and the instruction to send it as a job to slurm
SECONDS=0
source config.sh 

#concatenate the results of waafle_search and waafle_genecaller and remove previous conctenation if present
if [ -f $GCALLFINAL"/genecall.gff" ]; then
    # Remove the file
    rm -f $GCALLFINAL"/genecall.gff"
    echo "Removed previous concatenation file"
fi 
if [ -f $SEARCHFINAL"/search.blastout" ]; then
    # Remove the file
    rm -f $SEARCHFINAL"/search.blastout"
    echo "Removed previous concatenation file"
fi
cat $GCALLFINAL/* > $GCALLFINAL"/genecall.gff"
cat $SEARCHFINAL/* > $SEARCHFINAL"/search.blastout"
if [ $? -eq 0 ]; then
   echo "Output files concatenated succesfully"
else
   echo "Unable to concatenate output files"
fi

#rm splitted inputs
rm -r $DATADIR"/splitted_input/" 
if [ $? -eq 0 ]; then
   echo "Split dir removed succesfully"
else
   echo "Unable to remove split dir"
fi
#waafle_orgscore command
waafle_orgscorer --outdir $OSCORFINAL $INPUTFILE $SEARCHFINAL"/search.blastout" $GCALLFINAL"/genecall.gff" $TAXONOMY
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
