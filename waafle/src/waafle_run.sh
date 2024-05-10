#!/bin/bash

#PBS -l select=1:ncpus=30:mem=20gb
#PBS -l walltime=08:00:00

#importing paths from configuration file
source /home/giacomo.orsini-1/waafle/test_anal/src/config.sh

#activating conda env
source ~/miniconda3/bin/activate
conda activate waafle

#starting the times
SECONDS=0

# Extract the job id
job_id="$PBS_JOBID"

# Extract the job name from the job ID. Adding prefix to match sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

# Checkpoint
if [ $? -eq 1 ]; then
        echo -e "Unable to retrieve sample name from job id. Aborting."
        exit 1
else
        echo -e "Executing waafle pipeline on sample: $SAMPLE"
fi

echo -e "\t Executing waafle_search..."

# Checkpoint
if [ ! -f $TMP/$SAMPLE"_filtered_contigs.fa" ]; then
        echo -e "\t\t Unable to locate the contig file in directory ${TMP}. Aborting."
        exit 1
fi

# Checkpoint
if [ -f $SEARCH/"${SAMPLE}_search.blastout" ]; then

        echo -e "\t\t An ouput for waafle_search already exist, removing it and creating a new one..."

        rm $SEARCH/"${SAMPLE}_search.blastout"

        if [ $? -eq 1 ]; then
                echo -e "\t\t Unable to remove $SEARCH/${SAMPLE}_search.blastout. Proceeding either way..."
        fi
fi

# Start waafle_search analysis
waafle_search --threads 64 --out $SEARCH/"${SAMPLE}_search.blastout" $TMP/$SAMPLE"_filtered_contigs.fa" $DB

# Checkpoint
if [ $? -eq 0 ]; then
        echo -e "\t\t waale_search executed succesfully. Output at: $SEARCH/${SAMPLE}_search.blastout"
        echo -e "\t\t waafle_search: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
else
        echo -e "\t\t Unable to execute waafle_search. Aborting."
        exit 1
fi

sleep 5

echo -e "\t Executing waafle_genecaller..."

# Checkpoint
if [ ! -f "$SEARCH/${SAMPLE}_search.blastout" ]; then
        echo -e "\t\t Unable to locate the search.blastout file in directory ${SEARCH}. Aborting."
        exit 1
fi

# Checkpoint
if [ -f $GENECALL/"${SAMPLE}_genecall.gff" ]; then

        echo -e "\t\t An ouput for waafle_genecall already exist, removing it and creating a new one..."

        rm $GENECALL/"${SAMPLE}_genecall.gff"

        if [ $? -eq 1 ]; then
                echo -e "\t\t Unable to remove $GENECALL/${SAMPLE}_genecall.gff. Proceeding either way..."
        fi
fi

# Start waafle_genecall analysis
waafle_genecaller --gff $GENECALL/"${SAMPLE}_genecall.gff" $SEARCH/"${SAMPLE}_search.blastout"

# Checkpoint
if [ $? -eq 0 ]; then
        echo -e "\t\t waale_genecaller executed succesfully. Output at: $GENECALL/${SAMPLE}_genecall.gff"
        echo -e "\t\t waafle_genecaller: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
else
        echo -e "\t\t Unable to execute waafle_genecaller. Aborting."
        exit 1
fi

# Give time
sleep 5

echo -e "\t Executing waafle_orgscorer..."

# Checkpoint
if [ ! -f $GENECALL/"${SAMPLE}_genecall.gff" ]; then
        echo -e "\t\t Unable to locate the genecaller.gff file in directory ${GENECALL}. Aborting."
        exit 1
fi

# Strat waafle_orgscore analysis
waafle_orgscorer --outdir $ORGSCORE $TMP/$SAMPLE"_filtered_contigs.fa" $SEARCH/"${SAMPLE}_search.blastout" $GENECALL/"${SAMPLE}_genecall.gff" $T
AX

# Checkpoint
if [ $? -eq 0 ]; then
        echo -e "\t\t waafle_orgscorer executed succesfully. Output in directory: $ORGSCORE"
        echo -e "\t\t waafle_orgscorer: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
else
        echo -e "\t\t Unable to execute waafle_orgscorer. Aborting."
        exit 1
fi

# Give time
sleep 5

echo -e "\t Removing the contigs from temporary directory, the waafle_search and waafle_genecaller outputs..."

# Remove waafle_search output
rm $SEARCH/"${SAMPLE}_search.blastout"

# Checkpoint
if [ $? -eq 1 ]; then
        echo -e "\t\t Unable to remove ${SAMPLE}_search.blastout"
fi

# Remove waafle_genecall output
rm $GENECALL/"${SAMPLE}_genecall.gff"

# Checkpoint
if [ $? -eq 1 ]; then
        echo -e "\t\t Unable to remove ${SAMPLE}_genecall.gff"
fi

# Remove waafle_orgscore output
rm $TMP/$SAMPLE"_filtered_contigs.fa"

# Checkpoint
if [ $? -eq 0 ]; then
        echo -e "Partial outputs removed.\nFinished!"
else
        echo -e "Unable to remove contigs.\nFinished!"
fi
