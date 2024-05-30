#!/bin/bash

DATASET="CM_tanzania2"
QUEUE="common_cpuQ"

#MAIN PATH
HOMEDIR="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/src"
OUTDIR="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/benchmarking_set"

#DATA PATH
DATADIR="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/benchmarking_set/data"
DB="/shares/CIBIO-Storage/CM/scratch/users/claudia.mengoni/HGT_mireia/waffle/u90_CM_ghanatanzania_animals.blastdb"
TAX="/shares/CIBIO-Storage/CM/scratch/users/claudia.mengoni/HGT_mireia/waffle/tax_info.tsv"

#INPUT PATH
TMP=$OUTDIR"/data"
META=$OUTDIR"/meta"

#SCRIPT AND OUPUT PATH
SRCDIR=$HOMEDIR"/src"
STDDIR=$OUTDIR"/stdir"

#STEP PATH
SEARCH=$STDDIR"/search"
GENECALL=$STDDIR"/genecall"
ORGSCORE=$OUTDIR"/orgscore""
