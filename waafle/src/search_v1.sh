#!/bin/bash

#start measuring the total time
echo "Executing the script..."

#import paths from configuartion file
source config.sh

#create a directoy for splitted files if it doesn't exist
SPLITDIR=$DATADIR"/splitted_input"

if [ -d $SPLITDIR ]; then
   echo splits dir already exists...
else
   echo making the splits dir...
   mkdir $SPLITDIR"/"
   
   #split the testing file with 124 lines
   echo "Splitting the contigs file..."
   lines_per_split=20000
   split -l $lines_per_split -d -a 2 --additional-suffix=".fa" $INPUTFILE $SPLITDIR"/split"
fi

num_files=$(ls $SPLITDIR | wc -l)
echo "$num_files split files created"

#correct file names and file number
echo "Correcting files..."
(( num_files -= 1 ))

for i in {0..9}; do
if [[ -f $SPLITDIR"/split0$i.fa" ]]; then
mv $SPLITDIR"/split0$i.fa" $SPLITDIR"/split$i.fa"
fi
done

#send to slurm the waafle_search job file in parallel
echo "Sending $num_files jobs to slurm"
sbatch --output=$SEARCHOUT"/search_%A_%a.out" --error=$SEARCHERR"/search_%A_%a.err" --array=0-$num_files waafle_search.sh

echo "Script executed succesfully"
