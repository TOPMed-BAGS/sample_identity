#!/bin/bash

bash manual_omni_fixes.sh

cat fix_omni_sample_map.R | R --vanilla

n_ped_del=`grep pedigree ../data/output/omni_delete.txt | wc -l | tr -s ' '`
n_ped_swap=`grep pedigree ../data/output/omni_swaps.txt | wc -l | tr -s ' '`
n_ped_errors="$(($n_ped_del+$n_ped_swap))"
n_ped_fixed=`wc -l ../data/output/fixed_sample_map.txt | tr -s ' ' | cut -f2 -d' '`
n_ped_fixed="$(($n_ped_fixed-1))"
n_no_rhq=`grep no_rhq ../data/output/omni_delete.txt | wc -l | tr -s ' '`
n_with_rhq="$(($n_ped_fixed-$n_no_rhq))"
echo "n_ped_del $n_ped_del" >> ../data/output/flow_nrs.txt
echo "n_ped_swap $n_ped_swap" >> ../data/output/flow_nrs.txt
echo "n_ped_errors $n_ped_errors" >> ../data/output/flow_nrs.txt
echo "n_ped_fixed $n_ped_fixed" >> ../data/output/flow_nrs.txt
echo "n_no_rhq $n_no_rhq" >> ../data/output/flow_nrs.txt
echo "n_with_rhq $n_with_rhq" >> ../data/output/flow_nrs.txt
