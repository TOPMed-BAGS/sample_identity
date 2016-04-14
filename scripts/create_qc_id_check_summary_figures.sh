#!/bin/bash


bash extract_genomes.sh \
     ../data/output/qc_samples_check.genome  \
     ../data/output/qc_samples_check_650_omni_pairs.genome \
     650_ omni_
bash extract_excl_genomes.sh ../data/output/qc_samples_check.genome \
     ../data/output/qc_samples_check_omni.genome \
     omni_ 650_
