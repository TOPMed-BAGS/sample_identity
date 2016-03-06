#!/bin/bash

#Create working directory
mkdir ../data/working

#Run prest for 650
plink --bfile ../data/output/650 \
      --indiv-sort natural \
      --make-bed --out ../data/working/650_sorted
plink --bfile ../data/working/650_sorted \
      --recode12 --out ../data/working/650
./prest --file  ../data/working/650.ped --map  ../data/working/650.map --wped \
        --out ../data/working/650_prest_results

#Check relationships
cat prest_check.R | R --vanilla --args 650

#Run prest for omni
plink --bfile ../data/output/omni \
      --indiv-sort natural \
      --make-bed --out ../data/working/omni_sorted
plink --bfile ../data/working/omni_sorted \
      --recode12 --out ../data/working/omni
./prest --file  ../data/working/omni.ped --map  ../data/working/omni.map --wped \
        --out ../data/working/omni_prest_results

#Check relationships
cat prest_check.R | R --vanilla --args omni

#Cleanup
rm -r ../data/working
