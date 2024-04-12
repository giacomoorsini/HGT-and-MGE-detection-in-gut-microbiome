#!/bin/bash

#PBS -l select=2:ncpus=20:mem=20gb
#PBS -l walltime=24:00:00

# Import conda environment
source ~/miniconda3/bin/activate

# Initialize timer
SECONDS=0

# activate environment needed
conda activate metachip

# Import all the paths from config file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Extract the job id
job_id="$PBS_JOBID"

# Extract the job name from the job ID, add prefix to reconstruct sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

if [ -d "$OUT/$SAMPLE" ]; then
    echo "Analyzing $SAMPLE"
else
    echo "Error: Output directory does not exist."
    exit 1
fi

# Metachip BP command
MetaCHIP BP -p $SAMPLE -r pcofgs -t 60 -quiet -force -o $OUT/$SAMPLE

if [ $? -eq 0 ]; then
   echo "Metachip BP analysis completed"
else
   echo "Error: BP analysis failed"
fi

conda deactivate

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
