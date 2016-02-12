#!/bin/bash

mkdir ../data/working

bash extract_genomes.sh \
     ../data/output/initial.genome  \
     ../data/working/initial_650_omni_pairs.genome \
     650_ omni_
bash extract_excl_genomes.sh ../data/output/initial.genome \
     ../data/working/initial_omni.genome \
     omni_ 650_
bash extract_excl_genomes.sh ../data/output/initial.genome \
     ../data/working/initial_650.genome \
     650_ omni_

bash extract_genomes.sh \
     ../data/output/fixed.genome  \
     ../data/working/fixed_650_omni_pairs.genome \
     650_ omni_
bash extract_excl_genomes.sh ../data/output/fixed.genome \
     ../data/working/fixed_omni.genome \
     omni_ 650_
bash extract_excl_genomes.sh ../data/output/fixed.genome \
     ../data/working/fixed_650.genome \
     650_ omni_

rm -r ../data/output/figures
mkdir ../data/output/figures
cat create_summary_figures.R | R --vanilla

rm -r ../data/working
