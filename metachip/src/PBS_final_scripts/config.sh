#!/bin/bash

# This file contains all the paths to directory and files that are necessary to run metachip on a whole dataset. The scripts used are: get_list.sh get_taxonomy.sh mchip_PI.sh get_data.sh PI.sh mchip_BP.sh BP.sh

# Dataset name SEPARATE BY "_"
#DATASET="CM_ghana"
DATASET="CM_ghanatanzania_animals"

# Path to metachip folder
MCHIP="/home/giacomo.orsini-1/metachip2"

# Path to out dir on cibio storage
OUTDIR="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/metachip/$DATASET"

# Path to map files
MAPFILES="$OUTDIR/metadata"

# File containing the corresponding SGB for each MAG
DATAMAP="$MCHIP/map_files/datamap.txt"

#MAGS_FILE="/shares/CIBIO-Storage/CM/scratch/users/davide.golzato/fucina/mireia_animals/CM_ghanatanzania_jan24.tsv"
MAGS_FILE="$MCHIP/map_files/sequences_jun23.txt"

# File containing thefull taxonomical path for each SGB
#SGB_FILE="/shares/CIBIO-Storage/CM/scratch/users/claudia.mengoni/HGT_mireia/waffle/tax_info.tsv"
SGB_FILE="$MCHIP/map_files/SGB.Jun23.txt"

# File containing the MAGS
MAGS_IN_DATASET="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghanatanzania_animals/hq_mq_mags"
#MAGS="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghana/mags"

# Script directory
SRC="$MCHIP/src"

# Path to analyzed dataset folder

# Directory in which to temporarly copy the MAGS
DATA="$OUTDIR/data"

# Final output directory
OUT="$OUTDIR/output"

# Stdout stderr directory
STDIR="$OUTDIR/stdir"

# Path to metadata information
METADATA="$OUTDIR/metadata"

# File containing the full taxonomy path for each MAG
TAX="$METADATA/${DATASET}_taxonomy.tsv"

# List of all the samples ids of a dataser
ID_LIST="$METADATA/${DATASET}_id_list.txt"

# Partition
PARTITION="CIBIO_cpuQ"
