#!/bin/bash

#Run IBD between clean 650 and Omni data
bash run_ibd.sh ../data/input/sample_map.txt ../data/input/pedigrees.txt ../data/output/initial

#Cleanup
rm -r ../data/working/
