# Lemon installation
To install lemon, you can install all the dependencies manually. Otherwise, you can try downloading and issuing the `lemon.yml` or `lemon_exported.yml` files with the `conda env create -f lemon.yml` command.
```
conda activate lemon

conda install -c bioconda samtools
conda install -c bioconda bedtools
conda install scikit-learn
conda install numpy
conda install scipy
conda install -c conda-forge lmfit
conda install git
pip install pysam
pip install ssw-py
pip install Lumpy
pip install gurobipy
```
If you don't succeed, try following the commands reported in the lemon installation page:

```
git clone --recursive https://github.com/lichen2018/hgt-detection.git
cd getAccBkp
make
export CPLUS_INCLUDE_PATH=/home/your_home_path/lib/htslib-1.9
```
