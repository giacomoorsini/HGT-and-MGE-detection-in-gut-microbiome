# MetaChip2 Tutorial
To install this tool I couldn't manage to create a yaml file, rather I followed the instructions on the metachip2 GitHub page, creating first the conda environment and then installing the softwares manually. The commands where:
```
conda create -n metachip2 -c conda-forge -c bioconda gtdbtk=2.3.2
conda activate metachip2env

conda install -c bioconda blast
conda install -c bioconda diamond
conda install -c bioconda mmseqs2
conda install -c conda-forge r-base
conda install -c bioconda mafft

#you can also combine evrything in one command
conda install -c bioconda blast diamond mmseqs2 mafft
conda install -c conda-forge r-base

#at this point, check with conda list -n metachip2 if the following softwares are already installed, I skip the installation of the ones that were already installed in my case
conda install scipy 
conda install -c conda-forge biopython
conda install -c conda-forge matplotlib

pip install MetaCHIP2
```

Dependecies: 
- Python libraries: BioPython, Numpy, SciPy, Matplotlib and ETE3.

- Third-party software: GTDBTk, BLAST+, MMseqs2(optional), MAFFT, Ranger-DTL 2.0 (part of MetaCHIP, no need to install) and FastTree.
