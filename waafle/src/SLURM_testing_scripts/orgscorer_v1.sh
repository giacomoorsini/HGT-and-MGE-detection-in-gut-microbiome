#!/bin/bash

source config.sh 

cat $GCALLFINAL/* > $GCALLFINAL"/genecall.gff"
cat $SEARCHFINAL/* > $SEARCHFINAL"/search.blastout"

sbatch --output=$OSCOROUT"/orgscorer.out" --error=$OSCORERR"/orgscorer.err" waafle_orgscorer.sh
