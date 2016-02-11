#!/bin/bash

#Check user parameters
if [ "$#" -eq  "0" ];
then
    echo "Usage: ${0##*/} <sample_map_file_name> <pedigree_file_name> <out_file_name> <barcode_del_file_name>"
    exit
fi

#Setup
sample_map_file_name=$1
pedigree_file_name=$2
out_file_name=$3
barcode_del_file_name=$4
mkdir ../data/working

#Get overlapping SNPs
cat get_overlap_snps.R | R --vanilla
#Retain only the overlapping SNPs in the 650 data
plink --bfile ../data/input/650_clean \
      --extract ../data/working/overlap_snps_650_omni.txt \
      --make-bed --out ../data/working/650_overlap
#Create a list of SNPs to filter out by LD, based on the 650 data
plink --bfile ../data/working/650_overlap \
      --indep-pairwise 100 25 0.1 \
      --out ../data/working/ld_650
cp ../data/working/ld_650.prune.in ../data/working/overlap_snps_650_omni.txt

#Delete barcode IDs if applicable
if [ -e "$barcode_del_file_name" ];
then
    plink --bfile ../data/input/omni_clean \
        --remove $barcode_del_file_name \
        --make-bed --out ../data/working/tmp_omni
else
    cp ../data/input/omni_clean.fam ../data/working/tmp_omni.fam
    cp ../data/input/omni_clean.bed ../data/working/tmp_omni.bed
    cp ../data/input/omni_clean.bim ../data/working/tmp_omni.bim
fi

#Map the Omni plate_well IDs
cat map_omni_barnes_id.R | R --vanilla --args ../data/working/tmp_omni.fam \
     ../data/working/omni_barnes_id.fam \
     $sample_map_file_name
cat map_fam.R | R --vanilla --args ../data/working/omni_barnes_id \
     ../data/working/omni_mapped omni \
     $pedigree_file_name

#Map the 650 pedigree structure
cat map_fam.R | R --vanilla --args  ../data/working/650_overlap \
     ../data/working/650_mapped 650 \
     $pedigree_file_name

#Extract the relevant SNPs from the omni and 650 files
mv  ../data/working/omni_mapped.fam ../data/working/tmp_omni.fam
sed 's/rs/RS/g' ../data/working/tmp_omni.bim > ../data/working/new_tmp_omni.bim
mv ../data/working/new_tmp_omni.bim ../data/working/tmp_omni.bim
plink --bfile ../data/working/tmp_omni \
      --extract ../data/working/overlap_snps_650_omni.txt \
      --make-bed --out ../data/working/omni
plink --bfile ../data/working/650_mapped \
      --extract ../data/working/overlap_snps_650_omni.txt \
      --make-bed --out ../data/working/650

#Merge the files
plink --bfile  ../data/working/650 \
      --bmerge ../data/working/omni.bed \
      ../data/working/omni.bim \
      ../data/working/omni.fam \
      --make-bed --out ../data/working/merged_650_omni
if [ -e "../data/working/merged_650_omni-merge.missnp" ];
then
    plink --bfile ../data/working/omni \
          --flip ../data/working/merged_650_omni-merge.missnp \
          --make-bed --out ../data/working/omni_flipped
    rm ../data/working/merged_650_omni-merge.missnp
    plink --bfile  ../data/working/650\
      --bmerge ../data/working/omni_flipped.bed \
      ../data/working/omni_flipped.bim \
      ../data/working/omni_flipped.fam \
      --make-bed --out ../data/working/merged_650_omni
    #If there is still mismatches this is due to something else than strand mismatches;
    #exlude these SNPs
    if [ -e "../data/working/merged_650_omni-merge.missnp" ];
    then
        plink --bfile  ../data/working/650 \
              --exclude ../data/working/merged_650_omni-merge.missnp \
              --make-bed --out ../data/working/650_fixed

        plink --bfile  ../data/working/omni_flipped \
              --exclude ../data/working/merged_650_omni-merge.missnp \
              --make-bed --out ../data/working/omni_fixed

        plink --bfile  ../data/working/650_fixed \
              --bmerge ../data/working/omni_fixed.bed ../data/working/omni_fixed.bim ../data/working/omni_fixed.fam \
              --make-bed --out ../data/working/merged_650_omni
    fi
fi

#Report the nr of overlapping samples
n_650_omni_overlap=`cut -f2 -d' ' ../data/working/merged_650_omni.fam |  sort | uniq -d | wc -l | tr -s ' '`
echo "n_650_omni_overlap $n_650_omni_overlap" >> ../data/output/flow_nrs.txt

#Run IBD
plink --bfile ../data/working/merged_650_omni --genome --out $out_file_name

#Clean
rm -r ../data/working
