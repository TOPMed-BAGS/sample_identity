#!/bin/bash

#Create a clean omni file but without removing samples that failed QC
#This code was copied moslty from 2_clean_omni.sh, but a dummy qc_autosome file was created, withouth removing
#samples that failed QC
mkdir ../data/working
cd ../data/working
#Remove non-autosomal SNPs
grep "^0\t" ../input/omni.bim | cut -f2 > non_autosome_snps.txt
grep "^23\t" ../input/omni.bim | cut -f2 >> non_autosome_snps.txt
grep "^24\t" ../input/omni.bim | cut -f2 >> non_autosome_snps.txt
grep "^26\t" ../input/omni.bim | cut -f2 >> non_autosome_snps.txt
plink --bfile ../input/omni --exclude non_autosome_snps.txt --make-bed --out autosome
#Remove NHLBI control samples
echo "LP6008052-DNA_D01 LP6008052-DNA_D01" > del.txt
echo "LP6008052-DNA_E01 LP6008052-DNA_E01" >> del.txt
echo "LP6008052-DNA_E02 LP6008052-DNA_E02" >> del.txt
echo "LP6008079-DNA_A01 LP6008079-DNA_A01" >> del.txt
plink --bfile autosome --remove del.txt --make-bed --out qc_autosome
#Replace illumina kgp ids with rs ids
cat ../../scripts/fix_snp_ids.R | R --vanilla --args qc_autosome.bim new_qc_autosome.bim
mv qc_autosome.bim old_qc_autosome.bim
mv new_qc_autosome.bim qc_autosome.bim
#Try and remap the remaining kgp IDs using dbSNP
python ../../scripts/fix_snp_ids_with_db_snp.py qc_autosome.bim new_qc_autosome.bim
#Capitalize SNPs
mv qc_autosome.bim old_qc_autosome.bim
sed 's/rs/RS/' new_qc_autosome.bim > qc_autosome.bim
#Do a basic SNP QC
plink --bfile qc_autosome --geno 0.05 --hwe 0.0001 --hwe-all --make-bed --out qc_autosome_snps
#Remove duplicate samples
grep duplicates ../output/omni_delete.txt | cut -f1 > del.txt
n_omni_dupl_del=`wc -l del.txt | tr -s ' ' | cut -f2 -d' '`
paste del.txt del.txt > excl_plate_well_ids.txt
plink --bfile qc_autosome_snps --remove excl_plate_well_ids.txt --make-bed --out ../input/omni_qc_check_clean
cd ..
rm -r working
cd ../scripts

#Create the barcode delete file
cut -f1 ../data/input/omni_qc_sample_check_delete.txt > tmp_c.txt
paste tmp_c.txt tmp_c.txt > tmp_delete_ids.txt

#Run IBD between clean 650 and Omni data
bash run_ibd.sh ../data/output/qc_identity_check_sample_map.txt ../data/input/fixed_pedigrees.txt ../data/output/qc_samples_check tmp_delete_ids.txt ../data/input/omni_qc_check_clean omni_qc_check

#Cleanup tmp files
rm tmp_*
