#!/bin/bash

#this script removes all the waafle outputs and error files

source config.sh

rm $SEARCHERR/*
rm $SEARCHOUT/*
rm $SEARCHFINAL/*
rm $GCALLERR/*
rm $GCALLOUT/*
rm $GCALLFINAL/*
rm $OSCORERR/*
rm $OSCOROUT/*
rm $OSCORFINAL/*
