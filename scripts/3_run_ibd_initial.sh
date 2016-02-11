#!/bin/bash

#Run IBD between clean 650 and Omni data
bash run_ibd.sh ../data/input/sample_map.txt ../data/input/pedigrees.txt

#Perform automated swapping (update Omni sample ID with 650 sample ID where required)
mkdir ../data/working/
bash extract_genomes.sh \
     ../data/output/initial.genome  \
     ../data/working/ibd_650_omni_pairs.genome \
     650_ omni_

cat 650_auto_swaps.R | R --vanilla

#Cleanup
rm -r ../data/working/
