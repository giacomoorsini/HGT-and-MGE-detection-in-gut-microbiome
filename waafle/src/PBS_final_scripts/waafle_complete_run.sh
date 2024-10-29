#!/bin/bash

#PBS -l select=1:ncpus=30:mem=20gb
#PBS -l walltime=08:00:00

#importing paths from configuration file
source /shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/CM_ghana/src/config.sh

#activating conda env
source ~/miniconda3/bin/activate
conda activate waafle

#starting the times
SECONDS=0

# Extract the job id
job_id="$PBS_JOBID"

# Extract the job name from the job ID. Adding prefix to match sample name
SAMPLE=$(qstat -f "$job_id" | awk '/Job_Name/ {print "C16-"$3}')

# Checkpoint. Is the job id retrieved correctly?
if [ $? -eq 1 ]; then
        echo -e "Unable to retrieve sample name from job id. Aborting."
        exit 1
else
        echo -e "Executing waafle pipeline on sample: $SAMPLE"
fi

# Checkpoint. Has the contig file be copied and unzipped correctly?
if [ ! -f $TMP/${SAMPLE}${SUFFIX} ]; then
        echo -e "\t\t Unable to locate the contig file in directory ${TMP}. Aborting."
        exit 1
fi

#>------------------WAAFLE_SEARCH--------------------<
echo -e "\n\t Executing waafle_search..."

# Checkpoint. Does the waafle_search output exist?
if [ -f $SEARCH/"${SAMPLE}_search.blastout" ]; then
        echo -e "\t\tAn ouput for waafle_search already exist..."
        search_line_count=$(wc -l < "$SEARCH/"${SAMPLE}_search.blastout"")

        # Checkpoint. Is the file empty?
        if [ "$search_line_count" -lt 2 ]; then
                echo -e "\t\t ...but it's empty. Removing it..."
                rm $SEARCH/"${SAMPLE}_search.blastout"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi
        else
                echo -e "\t\t...skipping the waafle_search step."
        fi
else
        waafle_search --threads 64 --out $SEARCH/"${SAMPLE}_search.blastout" $TMP/${SAMPLE}${SUFFIX} $DB

        # Checkpoint. Did waafle_search run correctly?
        if [ $? -eq 0 ]; then

                # Checkpoint. Is the output there?
                if [ -f "$SEARCH/${SAMPLE}_search.blastout" ]; then
                        echo -e "\t\t waale_search executed succesfully. Output at: $SEARCH/${SAMPLE}_search.blastout"
                        echo -e "\t\t waafle_search running time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
                else
                        echo -e "\t\t Unable to locate the ${SAMPLE}_search.blastout file in directory ${SEARCH}. Aborting."
                        exit 1
        fi
        else
                echo -e "\t\t Unable to execute waafle_search correctly. Aborting."
                exit 1
        fi
fi

#>------------------WAAFLE_GENECALLER--------------------<
echo -e "\n\t Executing waafle_genecaller..."

# Checkpoint. Does the waafle_genecaller output already exist?
if [ -f $GENECALL/"${SAMPLE}_genecall.gff" ]; then
        echo -e "\t\tAn ouput for waafle_genecall already exist"
        genecall_line_count=$(wc -l < $GENECALL/"${SAMPLE}_genecall.gff")

        # Checkpoint. Is the file empty?
        if [ "$genecall_line_count" -lt 2 ]; then
                echo -e "\t\t ...but it's empty. Removing it..."
                rm $GENECALL/"${SAMPLE}_genecall.gff"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi
        else
                echo -e "\t\t...skipping the waafle_genecaller step."
        fi
else
        waafle_genecaller --gff $GENECALL/"${SAMPLE}_genecall.gff" $SEARCH/"${SAMPLE}_search.blastout"

        # Checkpoint. Did waafle_genecaller run correctly?
        if [ $? -eq 0 ]; then

                # Checkpoint. Is the output there?
                if [ -f "$GENECALL/${SAMPLE}_genecall.gff" ]; then
                        echo -e "\t\t waale_genecaller executed succesfully. Output at: $GENECALL/${SAMPLE}_genecall.gff"
                        echo -e "\t\t waafle_genecaller running time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
                else
                        echo -e "\t\t Unable to locate the ${SAMPLE}_genecall.gff file in directory ${GENECALL}. Aborting."
                        exit 1
        fi
        else
                echo -e "\t\t Unable to execute waafle_genecaller correctly. Aborting."
                exit 1
        fi
fi

#>------------------WAAFLE_ORGSCORE--------------------<
echo -e "\n\t Executing waafle_orgscore..."

# Checkpoint. Does the waafle_orgscore ouput already exist?
if [ -f $ORGSCORE/"${SAMPLE}.lgt.tsv" ] && [ -f $ORGSCORE/"${SAMPLE}.no_lgt.tsv" ] && [ -f $ORGSCORE/"${SAMPLE}.unclassified.tsv" ]; then
        echo -e "\t\tAn output for waafle_orgscorer already exist..."
        orgscore_line_count=$(wc -l < $ORGSCORE/"${SAMPLE}.no_lgt.tsv")

        # Checkpoint. Is the non lgt file empty?
        if [ "$orgscore_line_count" -lt 2 ]; then
                echo -e "\t\t ...but it's empty. Removing it..."
                rm $ORGSCORE/"${SAMPLE}.lgt.tsv"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi

                rm $ORGSCORE/"${SAMPLE}.no_lgt.tsv"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi

                rm $ORGSCORE/"${SAMPLE}.unclassified.tsv"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi

        else
                echo -e "\t\t...skipping the waafle_orgscorer step."
        fi
else
        waafle_orgscorer --outdir $ORGSCORE $TMP/${SAMPLE}${SUFFIX} $SEARCH/"${SAMPLE}_search.blastout" $GENECALL/"${SAMPLE}_genecall.gff" $TAX

        # Checkpoint. Did waafle_genecaller run correctly?
        if [ $? -eq 0 ]; then

                # Checkpoint. Is at least one of the outputs there?
                if [ -f $ORGSCORE/"${SAMPLE}.no_lgt.tsv" ]; then
                        echo -e "\t\t waale_orgscorer executed succesfully. Output at: $ORGSCORE"
                        echo -e "\t\t waafle_orgscorer running time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
                else
                        echo -e "\t\t Unable to locate the ${SAMPLE}.no_lgt.tsv file in directory ${ORGSCORE}. Aborting."
                        exit 1
        fi
        else
                echo -e "\t\t Unable to execute waafle_orgscorer correctly. Aborting."
                exit 1
        fi
fi

#>------------------WAAFLE_JUNCTIONS--------------------<
echo -e "\n\t Executing waafle_junctions..."

# Checkpoint. Does the waafle_genecaller output already exist?
if [ -f "$JUNCTIONS/${SAMPLE}.junctions.tsv" ]; then
        echo -e "\t\tAn ouput for waafle_junctions already exist..."
        junctions_line_count=$(wc -l < "$JUNCTIONS/${SAMPLE}.junctions.tsv")

        # Checkpoint. Is the file empty?
        if [ "$junctions_line_count" -lt 2 ]; then
                echo -e "\t\t ...but it's empty. Removing it..."
                rm "$JUNCTIONS/${SAMPLE}.junctions.tsv"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi
        else
                echo -e "\t\t...skipping the waafle_junctions step."
        fi
else
        if [ -f "${READSDIR}/${SAMPLE}/${SAMPLE}_R1.fastq.bz2" ] && [ -f "${READSDIR}/${SAMPLE}/${SAMPLE}_R2.fastq.bz2" ]; then

                waafle_junctions $TMP/${SAMPLE}${SUFFIX} $GENECALL/"${SAMPLE}_genecall.gff" --reads1 "${READSDIR}/${SAMPLE}/${SAMPLE}_R1.fastq.bz2" --reads2 "${READSDIR}/${SAMPLE}/${SAMPLE}_R2.fastq.bz2" --tmpdir $JUNCTIONS --outdir $JUNCTIONS --basename $SAMPLE --threads 96

        else
                echo -e "\t\t Unable to locate the reads file in directory ${READSDIR}. Aborting"
                exit 1
        fi

        # Checkpoint. Did waafle_junctions run correctly?
        if [ $? -eq 0 ]; then

                # Checkpoint. Is the output there?
                if [ -f "$JUNCTIONS/${SAMPLE}.junctions.tsv" ]; then
                        echo -e "\t\t waale_junctions executed succesfully. Output at: $JUNCTIONS/${SAMPLE}.junctions.tsv"
                        echo -e "\t\t waafle_junctions running time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
                else
                        echo -e "\t\t Unable to locate the ${SAMPLE}.junctions.tsv file in directory ${JUNCTIONS}. Aborting."
                        exit 1
        fi
        else
                echo -e "\t\t Unable to execute waafle_junctions correctly. Aborting."
                exit 1
        fi
fi

#>------------------WAAFLE_QC--------------------<
echo -e "\n\t Executing waafle_qc..."

# Checkpoint. Does the waafle_genecaller output already exist?
if [ -f "${QC}/${SAMPLE}.qc.lgt.tsv" ]; then
        echo -e "\t\tAn ouput for waafle_qc already exist..."
        qc_line_count=$(wc -l < "${QC}/${SAMPLE}.qc.lgt.tsv")

        # Checkpoint. Is the file empty?
        if [ "$qc_line_count" -lt 2 ]; then
                echo -e "\t\t ...but it's empty. Removing it..."
                rm "${QC}/${SAMPLE}.qc.lgt.tsv"

                # Checkpoint. Removed correctly?
                if [ $? -eq 0 ]; then
                        echo -e "\t\t...done."
                else
                        echo -e "\t\t...can't remove the file."
                fi
        else
                echo -e "\t\t...skipping the qc_junctions step."
        fi
else

        waafle_qc "${ORGSCORE}/${SAMPLE}.lgt.tsv" "$JUNCTIONS/${SAMPLE}.junctions.tsv" --outfile "${QC}/${SAMPLE}.qc.lgt.tsv"

        # Checkpoint. Did waafle_qc run correctly?
        if [ $? -eq 0 ]; then

                # Checkpoint. Is the output there?
                if [ -f "${QC}/${SAMPLE}.qc.lgt.tsv" ]; then
                        echo -e "\t\t waafle_qc executed succesfully. Output at: ${QC}/${SAMPLE}.qc.lgt.tsv"
                        echo -e "\t\t waafle_qc running time: $((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
                else
                        echo -e "\t\t Unable to locate the ${SAMPLE}.qc.lgt.tsv file in directory ${QC}. Aborting."
                        exit 1
        fi
        else
                echo -e "\t\t Unable to execute waafle_qc correctly. Aborting."
                exit 1
        fi
fi

echo -e "\n\t Removing the partial outputs..."

# Remove waafle_search output
rm $SEARCH/"${SAMPLE}_search.blastout"

# Checkpoint. Removed correctly?
if [ $? -eq 1 ]; then
        echo -e "\t\t Unable to remove ${SAMPLE}_search.blastout"
else
        echo -e "\t\t ${SAMPLE}_search.blastout removed."
fi

# Remove waafle_genecall output
rm $GENECALL/"${SAMPLE}_genecall.gff"

# Checkpoint. Removed correctly?
if [ $? -eq 1 ]; then
        echo -e "\t\t Unable to remove ${SAMPLE}_genecall.gff"
else
        echo -e "\t\t ${SAMPLE}_genecall.gff removed."
fi

# Remove waafle_junctions output
rm "$JUNCTIONS/${SAMPLE}.junctions.tsv"

# Checkpoint. Removed correctly?
if [ $? -eq 1 ]; then
        echo -e "\t\t Unable to remove ${SAMPLE}.junctions.tsv"
else
        echo -e "\t\t ${SAMPLE}.junctions.tsv removed."
fi

echo -e "\n\t Removing the contigs in temporary directory..."

# Remove contigs
rm $TMP/${SAMPLE}${SUFFIX}

# Checkpoint
if [ $? -eq 1 ]; then
        echo -e "\t\t Unable to remove $TMP/${SAMPLE}${SUFFIX}"
else
        echo -e "\t\t Contigs removed correctly"
fi

echo "Finished!"
