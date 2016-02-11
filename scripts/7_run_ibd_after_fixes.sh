#!/bin/bash

#Create the barcode delete file
grep 650_omni_no_solution ../data/output/omni_delete.txt | cut -f1 > tmp_c.txt
grep pedigree ../data/output/omni_delete.txt | cut -f1 >> tmp_c.txt
paste tmp_c.txt tmp_c.txt > tmp_delete_ids.txt

#Run IBD between clean 650 and Omni data
bash run_ibd.sh ../data/output/fixed_sample_map.txt ../data/input/fixed_pedigrees.txt ../data/output/fixed tmp_delete_ids.txt

#Cleanup tmp files
rm tmp_*
