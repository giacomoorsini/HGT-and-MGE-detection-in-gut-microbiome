#!/bin/bash

#MAIN VARIABLES
DATASET="CM_ghana"
QUEUE="CIBIO_cpuQ"
SUFFIX=".spades.fasta"  #without zip extension

#HOME DIRECTORY PATH
HOMEDIR="/shares/CIBIO-Storage/CM/scratch/users/giacomo.orsini/waafle/${DATASET}"

#INPUT DATA PATHS
DATADIR="/shares/CIBIO-Storage/CM/scratch/data/meta/${DATASET}"
CONTIGSDIR="${DATADIR}/contigs"
READSDIR="${DATADIR}/reads"
TMP=$HOMEDIR"/data"
META=$HOMEDIR"/meta"

#WAAFLE DB AND TAX FILE PATHS
DB="/shares/CIBIO-Storage/CM/scratch/users/claudia.mengoni/HGT_mireia/waffle/u90_CM_ghanatanzania_animals.blastdb"
TAX="/home/giacomo.orsini-1/waafle/taxonomy/waafle_tax_ordered_straincode_groupedSGB.tsv"

#SCRIPTS AND ERROR LOGS DIRECTORIES PATHS
SRCDIR=$HOMEDIR"/src"
STDDIR=$HOMEDIR"/stdir"

#OUTPUT DIRECTORIES PATHS
SEARCH=$STDDIR"/search"
GENECALL=$STDDIR"/genecall"
ORGSCORE=$HOMEDIR"/orgscore"
JUNCTIONS=$STDDIR"/junctions"
QC=$ORGSCORE"/qc"
