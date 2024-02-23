# Lemon tutorial

To install lemon, I wasn't able to use just a single yml file. Probably, the conflicting software would be Lumpy, that instead of being installed from conda needs to be installed from pip. If I have time I will try it
but for now, I'll report how i was able to create a working environment:

```
conda env create -f partial_lemon.yml
conda activate lemon

conda install -c bioconda samtools
conda install -c bioconda bedtools
conda install scikit-learn
conda install numpy
conda install scipy
conda install -c conda-forge lmfit
pip install pysam
pip install ssw-py
pip install Lumpy
pip install gurobipy
```
In the end I managed to create the environmet from a single yml file. It can be found in this repository
