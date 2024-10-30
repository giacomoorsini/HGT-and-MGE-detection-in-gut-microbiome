#!/bin/bash

#this script contains the instruction to create a set of directory to make the custom waafle scripts work.
#you are supposed to have this script and all the scripts you will use for waafle in a directory called 
# .../waafle/src. You should also have a directory containing the waafle database and the taxonomy file.
#this script optionally provides for those, the dowload of these files may be slow so check carefully the script.
#This script downloads in the current directory all the waafle scripts from git.

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
if [ -f "./waafle_complete_run.sh" ]; then
    echo "waafle_complete_run.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/refs/heads/main/waafle/src/PBS_final_scripts/waafle_complete_run.sh
fi
if [ -f "./manager.sh" ]; then
    echo "manager.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/refs/heads/main/waafle/src/PBS_final_scripts/manager.sh
fi
if [ -f "./get_list.sh" ]; then
    echo "get_list.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/refs/heads/main/waafle/src/PBS_final_scripts/get_list.sh
fi
if [ -f "./check_recover.sh" ]; then
    echo "check_recover.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/refs/heads/main/waafle/src/PBS_final_scripts/check_recover.sh
fi
if [ -f "./config.sh" ]; then
    echo "config.sh already present"
else
    wget https://raw.githubusercontent.com/giacomoorsini/HGT-tools/refs/heads/main/waafle/src/PBS_final_scripts/config.sh
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
else
    mkdir "../stdir/search"
    echo "search directory created"
fi
if [ -d "../stdir/genecall" ]; then
    echo "genecall directory already exists"
else
    mkdir "../stdir/genecall"
    echo "genecall directory created"
fi
if [ -d "../stdir/junctions" ]; then
    echo "junctions directory already exists"
else
    mkdir "../stdir/junctions"
    echo "junctions directory created"
fi

if [ -d "../meta" ]; then
    echo "meta directory already exists"
else
    mkdir "../meta"
    echo "meta directory created"
fi

if [ -d "../data" ]; then
    echo "data directory already exists"
else
    mkdir "../meta"
    echo "data directory created"
fi

if [ -d "../orgscore" ]; then
    echo "orgscore directory already exists"
else
    mkdir "../orgscore"
    echo "orgscore directory created"
fi
if [ -d "../orgscore/qc" ]; then
    echo "qc directory already exists"
else
    mkdir "../orgscore/qc"
    echo "qc directory created"
fi
