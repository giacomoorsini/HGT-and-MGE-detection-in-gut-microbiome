#!/bin/bash

#This script is used to run the waafle tool on your data
echo "Executing the script..."

#import paths from configuartion file
source config.sh

#create a directoy for splitted files if it doesn't exist
SPLITDIR=$DATADIR"/splitted_input"
if [ -d $SPLITDIR ]; then
   echo Splits dir already exists, proceeding with available files...
   num_files=$(ls $SPLITDIR | wc -l)
   echo "$num_files split files available"
   if [ $? -eq 0 ]; then
      echo "Done"
   else
      echo "Error: wrong command or path. Aborting."
      exit 1
   fi
else
   echo Making the splits dir...
   mkdir $SPLITDIR"/"
   echo "Splitting the input file..."
   split -l $lines_per_split -d -a 2 --additional-suffix=".fa" $INPUTFILE $SPLITDIR"/split"
   if [ $? -eq 0 ]; then
      num_files=$(ls $SPLITDIR | wc -l)
      echo "Done: $num_files split files created"
   else
      echo "Error: wrong command or path. Removing splitdir. Aborting."
      rmdir $SPLITDIR
      exit 1
   fi
fi


#correct file names and file number
echo "Correcting file names..."
for i in {0..9}; do
if [[ -f $SPLITDIR"/split0$i.fa" ]]; then
mv $SPLITDIR"/split0$i.fa" $SPLITDIR"/split$i.fa"
fi
done
if [ $? -eq 0 ]; then
   echo "Done"
else
   echo "Error: wrong command or path. Aborting."
   exit 1
fi
#send to slurm the waafle_search job files in parallel
(( num_files -= 1 ))
job1_array_id=$(sbatch --output=$SEARCHOUT"/search_%A_%a.out" --error=$SEARCHERR"/search_%A_%a.err" --array=0-$num_files waafle_search.sh | awk '{print $4}')
(( num_files += 1 ))
if [ $? -eq 0 ]; then
   echo "Sending $num_files jobs to slurm with ID: $job1_array_id"
else
   echo "Error: wrong command. Aborting."
   exit 1
fi

#send to slurm the waafle_genecaller job files in parallel
(( num_files -= 1 ))
job2_array_id=$(sbatch --dependency=afterany:$job1_array_id --output=$GCALLOUT"/genecall_%A_%a.out" --error=$GCALLERR"/genecall_%A_%a.err" --array=0-$num_files waafle_genecaller.sh | awk '{print $4}')  
(( num_files += 1 ))
if [ $? -eq 0 ]; then
   echo "Sending $num_files jobs to slurm queue with ID: $job2_array_id"
else
   echo "Error: wrong command. Aborting."
   exit 1
fi

#send to slurm the waafle_orgscorer job file
job3_id=$(sbatch --dependency=afterany:$job2_array_id --output=$OSCOROUT"/orgscorer.out" --error=$OSCORERR"/orgscorer.err" waafle_orgscorer.sh | awk '{print $4}') 
if [ $? -eq 0 ]; then
   echo "Sending 1 job to slurm queue with ID: $job3_id"
else
   echo "Error: wrong command. Aborting."
   exit 1
fi
echo "Script executed."
