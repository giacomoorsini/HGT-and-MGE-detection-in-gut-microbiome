
#!/bin/bash

# This file contains all the paths to directory and files that are necessary to run metachip on a whole dataset. The scripts used are: get_list.sh get_taxonomy.sh mchip_PI.sh get_data.sh PI.sh mchip_BP.sh BP.sh

# File containing the corresponding SGB for each MAG
MAGS_FILE="/shares/CIBIO-Storage/CM/scratch/users/davide.golzato/fucina/mireia_animals/CM_ghanatanzania_jan24.tsv"

# File containing thefull taxonomical path for each SGB
SGB_FILE="/shares/CIBIO-Storage/CM/scratch/users/claudia.mengoni/HGT_mireia/waffle/tax_info.tsv"

# File containing the MAGS
MAGS="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghanatanzania_animals/hq_mq_mags"

# Directory in which to temporarly copy the MAGS
DATA="/home/giacomo.orsini-1/metachip2/data"

# Final output directory
OUT="/home/giacomo.orsini-1/metachip2/analysis"

# Path to metadata information
METADATA="/home/giacomo.orsini-1/metachip2/metadata"

# File containing the full taxonomy path for each MAG
TAX="$METADATA/GZ_animals_taxonomy_mchp.tsv"

# List of all the samples ids of a dataser
ID_LIST="$METADATA/id_list.txt"

# Script directory
SRC="/home/giacomo.orsini-1/metachip2/src"

# Stdout stderr directory
STDIR="/home/giacomo.orsini-1/metachip2/stdir"

# Dataset name SEPARATE BY "_"
DATASET="CM_ghanatanzania_animals"

# Partition
PARTITION="CIBIO_cpuQ"
