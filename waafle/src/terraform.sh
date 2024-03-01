#!/bin/bash

#this script contains the instruction to create a set of directory to use the config.sh file for waafle
#you are supposed to have this script and all the scripts you will use for waafle in a directory called 
# .../waafle/src  
#you should also have in the /waafle/ directory a directory containing the waafle database and the taxonomy file.
#this script doesn't provide for those

if [ -d "../stdir" ]; then
    echo "stdir already exists"
else
    mkdir "../stdir"
    echo "stdir created"
fi

if [ -d "../stdir/search" ]; then
    echo "search directory already exists"
    if [ -d "../stdir/search/out" ]; then
        echo "search/out subdirectory already exists"
    else
        mkdir "../stdir/search/out"
        echo "out subdirectory created"
    fi
    if [ -d "../stdir/search/err" ]; then
        echo "search/err subdirectory already exists"
    else
        mkdir "../stdir/search/err"
        echo "err subdirectory created"
    fi
    if [ -d "../stdir/search/final_out" ]; then
        echo "search/final_out subdirectory already exists"
    else
        mkdir "../stdir/search/final_out"
        echo "final_out subdirectory created"
    fi
else
    mkdir "../stdir/search"
    mkdir "../stdir/search/out"
    mkdir "../stdir/search/err"
    mkdir "../stdir/search/final_out"
    echo "search directory and subdirectories out, err, final_out created"
fi

if [ -d "../stdir/genecall" ]; then
    echo "genecall directory already exists"
    if [ -d "../stdir/genecall/out" ]; then
        echo "genecall/out subdirectory already exists"
    else
        mkdir "../stdir/genecall/out"
        echo "out subdirectory created"
    fi
    if [ -d "../stdir/genecall/err" ]; then
        echo "genecall/err subdirectory already exists"
    else
        mkdir "../stdir/genecall/err"
        echo "err subdirectory created"
    fi
    if [ -d "../stdir/genecall/final_out" ]; then
        echo "genecall/final_out subdirectory already exists"
    else
        mkdir "../stdir/genecall/final_out"
        echo "final_out subdirectory created"
    fi
else
    mkdir "../stdir/genecall"
    mkdir "../stdir/genecall/out"
    mkdir "../stdir/genecall/err"
    mkdir "../stdir/genecall/final_out"
    echo "genecall directory and subdirectories out, err, final_out created"
fi

if [ -d "../stdir/orgscore" ]; then
    echo "orgscore directory already exists"
    if [ -d "../stdir/orgscore/out" ]; then
        echo "orgscore/out subdirectory already exists"
    else
        mkdir "../stdir/orgscore/out"
        echo "out subdirectory created"
    fi
    if [ -d "../stdir/orgscore/err" ]; then
        echo "orgscore/err subdirectory already exists"
    else
        mkdir "../stdir/orgscore/err"
        echo "err subdirectory created"
    fi
    if [ -d "../stdir/orgscore/final_out" ]; then
        echo "orgscore/final_out subdirectory already exists"
    else
        mkdir "../stdir/orgscore/final_out"
        echo "final_out subdirectory created"
    fi
else
    mkdir "../stdir/orgscore"
    mkdir "../stdir/orgscore/out"
    mkdir "../stdir/orgscore/err"
    mkdir "../stdir/orgscore/final_out"
    echo "orgscore directory and subdirectories out, err, final_out created"
fi
