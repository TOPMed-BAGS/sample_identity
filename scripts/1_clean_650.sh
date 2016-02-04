#!/bin/bash

mkdir ../data/working

#Create PLINK sample deletion file
while read line
do
     cut -f1,2 -d' ' ../data/input/650.fam | grep $line >> ../data/working/del_list.txt
done < ../data/output/650_delete.txt

plink --bfile ../data/input/650 \
      --remove ../data/working/del_list.txt \
      --make-bed --out ../data/input/650_clean


rm -r ../data/working
