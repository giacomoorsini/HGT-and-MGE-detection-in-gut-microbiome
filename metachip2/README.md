# MetaCHIP Tutorial
All informations have been taken from MetaCHIP main repository: https://github.com/songweizhi/MetaCHIP/tree/master?tab=readme-ov-file. MetaCHIP has a newer version, MetaCHIP2, that I'haven't been able to use, but I managed to create the conda environment metachip2_exported.yaml that I won't remove as it may be useful for whoever wants to try the tool.
To install metaCHIP, you can either use the metachip.yaml file or install the dependencies manually; in case neither of the two methods are working, try using the metachip_exported.yaml file.
```
conda create -n metachip -c conda-forge -c bioconda r-base=4.3.2
conda activate metachip

#try one by one if it doesn't work
conda install -c bioconda blast diamond mmseqs2 mafft hmmer fasttree

#some of these may be already installed, check with conda list -n metachip
conda install scipy numpy 
conda install -c conda-forge biopython matplotlib
conda install etetoolkit::ete3

conda install -c conda-forge r-optparse r-ape r-circlize

pip install --upgrade MetaCHIP
```
