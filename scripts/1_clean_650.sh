#!/bin/bash

mkdir ../data/working

#Create PLINK sample deletion file
while read line
do
     cut -f1,2 -d' ' ../data/input/650.fam | grep $line >> ../data/working/del_list.txt
done < ../data/output/650_delete.txt

#Create a clean output file
plink --bfile ../data/input/650 \
      --remove ../data/working/del_list.txt \
      --make-bed --out ../data/input/650_clean

#Capture the nr of input and output samples for the flow diagram
n_init_650=`wc -l ../data/input/650.fam | tr -s ' ' | cut -f2 -d' '`
n_650_del=`wc -l ../data/working/del_list.txt | tr -s ' ' | cut -f2 -d' '`
n_clean_650=`wc -l ../data/input/650_clean.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_650 $n_init_650" > ../data/output/flow_nrs.txt
echo "n_650_del $n_650_del" >> ../data/output/flow_nrs.txt
echo "n_clean_650 $n_clean_650" >> ../data/output/flow_nrs.txt

#Cleanup
rm -r ../data/working
