#!/bin/bash

#Set the numbers that are determined manually
n_clean_omni=`wc -l ../data/input/omni_clean.fam | tr -s ' ' | cut -f2 -d' '`
n_del_unresolved=1
n_fixed_omni="$(($n_clean_omni-$n_del_unresolved))"
n_ped_unresolved=2
n_sex_fixes=`wc -l ../data/output/pedigree_sex.txt | tr -s ' ' | cut -f2 -d' '`
n_ped_del=`grep pedigree ../data/output/omni_delete.txt | wc -l | tr -s ' '`
n_ped_fixed="$(($n_fixed_omni-$n_ped_del))"
echo "n_fixed_omni $n_fixed_omni" >> ../data/output/flow_nrs.txt
echo "n_parents_fixed_omni $n_fixed_omni" >> ../data/output/flow_nrs.txt
echo "n_del_unresolved $n_del_unresolved" >> ../data/output/flow_nrs.txt
echo "n_ped_unresolved $n_ped_unresolved" >> ../data/output/flow_nrs.txt
echo "n_ped_fixed $n_ped_fixed" >> ../data/output/flow_nrs.txt
echo "n_sex_fixes $n_sex_fixes" >> ../data/output/flow_nrs.txt

#Build the flow diagrams
bash ../../utility_scripts/build_flow.sh flow.dot flow.png ../data/output/flow_nrs.txt
