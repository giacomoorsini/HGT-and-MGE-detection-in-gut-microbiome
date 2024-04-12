#!/bin/bash

#PBS -N mchipPI
#PBS -l select=1:ncpus=10:mem=10gb
#PBS -l walltime=24:00:00
#PBS -q common_cpuQ
#PBS -o /home/giacomo.orsini-1/metachip2/stdir/mchip_PI.out
#PBS -e /home/giacomo.orsini-1/metachip2/stdir/mchip_PI.err

# Import all the paths to file
source /home/giacomo.orsini-1/metachip2/src/config.sh

# Initialize timer
SECONDS=0

echo "Executing the metachip PI script"

# Read all the ids in the id_list.txt and for each send a job to download and unzip the MAGS and a job to execute metachip PI
while IFS= read -r line; do

        # Sample id
        SAMPLE=$(echo $line)

        echo "Analyzing sample $SAMPLE"

        # Jobname will be the sample stripped of the prefix, for space reasons
        JOBNAME=$(echo $SAMPLE | awk -F - '{print $2"-"$3}')

        # Send job to download and unzip
        job0_id=$(qsub -N $JOBNAME -o $STDIR/get_$SAMPLE.out -e $STDIR/get_$SAMPLE.err -q $PARTITION $SRC/get_data.sh)

        if [ $? -eq 0 ]; then
                echo "Job 1 sent"
        else
                echo "Error: unable to send job. Aborting."
                exit 1
        fi

        # Send job to execute metachip PI command with dependency
        job1_id=$(qsub -N $JOBNAME -W depend=afterok:$job0_id -o $STDIR/PI_$SAMPLE.out -e $STDIR/PI_$SAMPLE.err -q $PARTITION $SRC/PI.sh)

        if [ $? -eq 0 ]; then
                echo "Job 2 sent"
        else
                echo "Error: unable to send job. Aborting."
                exit 1
        fi

        # Give time to send the job and to start it
        sleep 20

done < $ID_LIST

# Give some extra time
sleep 60

# Send the manager of the next batch of job with dependency on the last job1
job2_id=$(qsub -W depend=afterok:$job1_id -o $STDIR/mchip_BP.out -e $STDIR/mchip_BP.err -q $PARTITION $SRC/mchip_BP.sh)

if [ $? -eq 0 ]; then
                echo "Sending metachip BP manager job to queue"
                echo "PI script executed succesfully"
        else
                echo "Error: unable to send job. Aborting."
                exit 1
fi

# Timer
echo "Elapsed time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
