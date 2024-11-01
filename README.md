# HGT detection and MGE prediction tools
This repository contains information about tools for horizontal gene transfer detection and MGE prediction. In particular, for each tool, there is:
- a small tutorial
- installation instructions/ conda environments for installation
- scripts used

The tools WAAFLE (https://github.com/biobakery/waafle) and MetaCHIP (https://github.com/songweizhi/MetaCHIP) and a custom pipeline (custom_pipeline1) for HGT detection have been selected as the most promising and have been used in an HPC context. The tool geNomad (https://portal.nersc.gov/genomad/quickstart.html) for MGE prediction has been tested and used in an HPC context.

# Horizontal gene transfer
Horizontal gene transfer is defined as the non-sexual movement of genetic material between two unrelated organisms. In the context of the gut microbiome, HGT frequently occurs due to favourable conditions: high microbial diversity and density, stable conditions, and a constant supply of food. HGT plays a crucial role in bacteria evolution and adaptation, a role that has not yet been explored in its full potential. Moreover, in the context of antibiotic resistance genes (ARG) transmission, HGT represents an alarming path of spreading of these dangerous traits. HGT is carried out by the mobilization of mobile genetic elements (MGE), categories of selfish genetic material capable of reproducing and transmitting themselves independently from the host genome.

HGT prediction in a metagenomic context is not an easy task mainly because of two reasons: the difficulty of the task itself and the absence of a gold standard tool. Many tools have been implemented for identifying HGT genes in metagenomic datasets, mainly there exist 4 strategies:
- Reference-based approaches: rely on a reference database to map data.
- Compositional-based approaches rely mainly on the compositional differences (GC content) between the host genome and the horizontally transferred genes.
- Phylogenetic approaches: rely on phylogenetic distance to identify putative horizontally transmitted genes.
- Machine learning approaches: rely on machine learning models training.

During my study, I demonstrated that WAAFLE could be used as a gold-standard tool due to its efficacy and ease of use.

# Mobile genetic elements
Mobile genetic elements are vectors of HGT. These elements are mobilized through three different mechanisms: conjugation (transmission through a pilus), transduction (transmission through viral infection) and transformation (uptake from a dead cell). The mobilization of these elements is increased during stressful conditions. Predicting the amount of MGE gives a hint about the HGT rates, as the two are directly correlated. There exist many categories of MGEs, each with its genetic signatures that can be predicted:
- plasmids
- phages and integrated phage DNA
- Transposable elements
- Integrative Conjugative Elements (ICE)
- Integrative Mobilizable Elements (IME)
- Integrons
As for the HGT detection issues, a gold standard tool doesn't exist.
