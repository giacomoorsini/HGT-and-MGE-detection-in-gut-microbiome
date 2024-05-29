#!/bin/bash

#MAIN PATH
MAINDIR="/users/genomics/gorsini"

#DATA PATH
DATADIR=$MAINDIR"/giacomoAssembled/assembled_C16-20082-TZ"  
DBDIR=$MAINDIR"/tools/HGT/waafle/waafledb/waafledb"
TAXONOMY=$MAINDIR"/tools/HGT/waafle/waafledb_taxonomy.tsv"

#INPUT PATH
INPUTFILE=$DATADIR"/final.contigs.fa"
lines_per_split=10000

#TOOL PATH
TOOL=$MAINDIR"/tools/HGT/waafle"

#SCRIPT AND OUPUT PATH
SRCDIR=$TOOL"/src"
STDDIR=$TOOL"/stdir"

#STEP PATH
SEARCH=$STDDIR"/search"
GENECALL=$STDDIR"/genecall"
ORGOSCORE=$STDDIR"/orgscore"

#ERROR AND OUTPUT PATH
SEARCHOUT=$SEARCH"/out"
SEARCHERR=$SEARCH"/err"
SEARCHFINAL=$SEARCH"/final_out"

GCALLOUT=$GENECALL"/out"
GCALLERR=$GENECALL"/err"
GCALLFINAL=$GENECALL"/final_out"

OSCOROUT=$ORGOSCORE"/out"
OSCORERR=$ORGOSCORE"/err"
OSCORFINAL=$ORGOSCORE"/final_out"
