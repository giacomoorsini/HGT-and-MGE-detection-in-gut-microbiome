#!/bin/bash

#PBS -N manager
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l walltime=12:00:00
#PBS -q CIBIO_cpuQ
#PBS -o /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/genomad/stdir/manager.out
#PBS -e /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/genomad/stdir/manager.err

# Import paths from config file
source /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/mge/genomad/src/config.sh

DATASETS=("CM_ghana" "CM_ghana2" "CM_tanzania" "CM_tanzania2" "CM_ghanatanzania_animals")

for INDEX in {0..4}; do

        DATASET=${DATASETS[$INDEX]}

        LIST="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/${DATASET}/meta/${DATASET}_list.txt"

        # Go trough all the lines of the list
        while IFS= read -r line; do

                SAMPLE=$(echo "$line" | awk -F "." '{print $1}' | awk -F "_" '{print $1}')
                JOBID=$(echo "$SAMPLE" | awk -F "-" '{print $2"-"$3}')

                if [ "$DATASET" = "CM_ghana2" ]; then
                        qsub -N $JOBID -o $STDIR/${DATASET}_${JOBID}.out -e $STDIR/${DATASET}_${JOBID}.err -q $QUEUE $SRC/genomad_ghana2.sh
                        #echo $SAMPLE
                elif [ "$DATASET" = "CM_ghana" ];then
                        qsub -N $JOBID -o $STDIR/${DATASET}_${JOBID}.out -e $STDIR/${DATASET}_${JOBID}.err -q $QUEUE $SRC/genomad_ghana.sh
                        #echo $SAMPLE
                elif [ "$DATASET" = "CM_tanzania2" ];then
                        qsub -N $JOBID -o $STDIR/${DATASET}_${JOBID}.out -e $STDIR/${DATASET}_${JOBID}.err -q $QUEUE $SRC/genomad_tanzania2.sh
                        #echo $SAMPLE
                elif [ "$DATASET" = "CM_tanzania" ];then
                        qsub -N $JOBID -o $STDIR/${DATASET}_${JOBID}.out -e $STDIR/${DATASET}_${JOBID}.err -q $QUEUE $SRC/genomad_tanzania.sh
                        #echo $SAMPLE
                else
                        qsub -N $JOBID -o $STDIR/${DATASET}_${JOBID}.out -e $STDIR/${DATASET}_${JOBID}.err -q $QUEUE $SRC/genomad_animals.sh
                        #echo $SAMPLE
                fi

                sleep 30
        done < $LIST

        sleep 120
done
