#!/bin/bash

DATASETS=("CM_ghana" "CM_ghana2" "CM_tanzania" "CM_tanzania2" "CM_ghanatanzania_animals")

HOMEDIR="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/mge/genomad"
DB="${HOMEDIR}/genomad_db"
STDIR="${HOMEDIR}/stdir"
SRC="${HOMEDIR}/src"
QUEUE="CIBIO_cpuQ"

GH_TH_animals_DIR="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghanatanzania_animals/assemblies"
GH_DIR="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghana/contigs"
GH2_DIR="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_ghana2/contigs"
TZ_DIR="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_tanzania/contigs"
TZ2_DIR="/shares/CIBIO-Storage/CM/scratch/data/meta/CM_tanzania2/contigs"
