# localHGT tutorial
## Installation
```
git clone https://github.com/deepomicslab/LocalHGT.git --depth 1
cd LocalHGT/
conda env create --name localhgt -f environment.yml
conda activate localhgt
make

python scripts/main.py -h  # detect HGT breakpoints
python scripts/infer_HGT_event.py -h # detect complete HGT events

#test
cd test/
sh run_BKP_detection.sh
sh run_event_detection.sh
#See output/test_sample.acc.csv for breakpoint results, and see test_event_output.csv for event results.
```

LocalHGT identifies HGT breakpoint candidates using approximate k-mer match instead of reads alignment and then maps reads to the reference segments around the candidates to obtain precise HGT boundaries.
