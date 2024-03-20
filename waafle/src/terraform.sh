#!/bin/bash

#this script contains the instruction to create a set of directory to make the custom waafle scripts work.
#you are supposed to have this script and all the scripts you will use for waafle in a directory called 
# .../waafle/src. You should also have in the /waafle/ directory a directory containing the waafle database and the taxonomy file.
#this script optionally provides for those, the dowload of these files may be slow so check carefully the script.
#This script download in the current directory all the waafle scripts from git.

#CHECK AND CREATE SRC DIRECTORY
dir="src"
current_dir=$(pwd)
current=$(basename "$current_dir")
echo $current

if [ "$current" = "$dir" ]; then
    echo "terraform is in src directory"
else
    echo "terraform is not in src"
    if [ -d "./src" ]; then
        echo "src already present, moving the script"
        mv ./terraform.sh ./src/
    else
        echo "creating src and moving the script"
        mkdir ./src
        mv ./terraform.sh ./src/
    fi
fi

#CHECK AND DOWLOAD ALL THE CUSTOM SCRIPTS
if [ -f "./waafle.sh" ]; then
    echo "waafle.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/main/waafle/src/waafle.sh
fi
if [ -f "./waafle_search.sh" ]; then
    echo "waafle_search.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/main/waafle/src/waafle_search.sh
fi
if [ -f "./waafle_genecaller.sh" ]; then
    echo "waafle_genecaller.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/main/waafle/src/waafle_genecaller.sh
fi
if [ -f "./waafle_orgscorer.sh" ]; then
    echo "waafle_orgscorer.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/main/waafle/src/waafle_orgscorer.sh
fi
if [ -f "./flush.sh" ]; then
    echo "flush.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/main/waafle/src/flush.sh
fi
if [ -f "./config.sh" ]; then
    echo "flush.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/main/waafle/src/config.sh
fi

#CHECK AND DOWLOAD WAAFLE DATABASES
# if [ -d "../waafledb" ]; then
#     echo "waafle database already present"
# else
#     echo "Download waafle database"
#     wget http://huttenhower.sph.harvard.edu/waafle_data/waafledb.tar.gz -P ../ 
# fi
# if [ -f "../waafledb_taxonomy.tsv" ]; then
#     echo "waafle taxonomy already present"
# else
#     echo "Download waafle taxonomy"
#     wget http://huttenhower.sph.harvard.edu/waafle_data/waafledb_taxonomy.tsv -P ../ 
# fi


#CHECK AND CREATE DIRECTORIES STRUCTURE
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
