#!/bin/bash

#Apply the sample swaps
mkdir ../data/working
cd ../data/working
cp ../input/pedigrees.txt .

#Apply the pedigree merging
while read line
do
    in_id=`echo $line | cut -f1 -d' '`
    out_id=`echo $line | cut -f2 -d' '`
    sed "s/${in_id},/${out_id},/" pedigrees.txt > new_pedigrees.txt
    mv new_pedigrees.txt pedigrees.txt
done <  ../output/pedigree_merging.txt

#Apply the updated parent IDs
cat ../../scripts/fix_pedigree.R | R --vanilla

#Report the number of updates
n_merge_ped=`wc -l ../output/pedigree_merging.txt | tr -s ' ' | cut -f2 -d' '`
n_merge_ped="$(($n_merge_ped-1))"
n_update_fa=`grep Father pedigree_parents.txt | wc -l`
n_update_mo=`grep Mother pedigree_parents.txt | wc -l`
echo "n_merge_ped $n_merge_ped" >> ../output/flow_nrs.txt
echo "n_update_fa $n_update_fa" >> ../output/flow_nrs.txt
echo "n_update_mo $n_update_mo" >> ../output/flow_nrs.txt

#Cleanup
cd ../..
rm -r data/working
