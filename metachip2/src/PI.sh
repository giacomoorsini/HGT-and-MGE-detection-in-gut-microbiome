#!/bin/bash

#PBS -l select=2:ncpus=20:mem=20gb
#PBS -l walltime=24:00:00

# activate local miniconda installation
source ~/miniconda3/bin/activate

# Initialize timer
SECONDS=0

# activate environment needed
conda activate metachip

# Import all paths from config file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Extract the job id
job_id="$PBS_JOBID"

# Extract the job name from the job ID. Adding prefix to match sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

# Specify directory containing the data
SAMPLE_DIR="$DATA/$SAMPLE"

if [ -d "$SAMPLE_DIR" ]; then
    echo "Directory exists."
else
    echo "Error: Sample directory does not exist. Aborting"
    exit 1
fi

echo "Analyzing sample $SAMPLE"

# Metachip PI command
MetaCHIP PI -p $SAMPLE -r pcofgs -i $SAMPLE_DIR -x fa -taxon $TAX -t 60 -quiet -force -o $OUT/$SAMPLE

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

conda deactivate

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
