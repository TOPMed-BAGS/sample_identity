#!/bin/bash

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
plink --bfile autosome --remove del.txt --make-bed --out autosome_bags

#Remove samples that has been identified previously to have failed QC
cp ../input/omni_qc_fail.txt  ../output/omni_delete.txt
grep qc ../output/omni_delete.txt | cut -f1 > del.txt
n_omni_qc_del=`wc -l del.txt | tr -s ' ' | cut -f2 -d' '`
paste del.txt del.txt > excl_plate_well_ids.txt
plink --bfile autosome_bags --remove excl_plate_well_ids.txt --make-bed --out qc_autosome

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

#Extract SNPs that are not in LD
plink --bfile qc_autosome_snps --indep-pairwise 100 25 0.025
plink --bfile qc_autosome_snps --extract plink.prune.in --make-bed --out qc_autosome_snps_le

#Run IBD so as to identify duplicate samples
plink --bfile qc_autosome_snps_le --genome

#Run missingnes statistics so we can decide which duplicate samples to remove, based on call rate
plink --bfile qc_autosome_snps --missing --out miss

#Get a list of duplicate samples that should be removed
cat ../../scripts/get_omni_duplicate_ids.R | R --vanilla

#Remove duplicate samples
grep duplicates ../output/omni_delete.txt | cut -f1 > del.txt
n_omni_dupl_del=`wc -l del.txt | tr -s ' ' | cut -f2 -d' '`
paste del.txt del.txt > excl_plate_well_ids.txt
plink --bfile qc_autosome_snps --remove excl_plate_well_ids.txt --make-bed --out ../input/omni_clean

#Record nrs for flow diagram
n_init_omni=`wc -l ../input/omni.fam | tr -s ' ' | cut -f2 -d' '`
n_omni_del="$(($n_omni_qc_del+$n_omni_dupl_del))"
n_clean_omni=`wc -l ../input/omni_clean.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_omni $n_init_omni" >> ../output/flow_nrs.txt
echo "n_omni_qc_del $n_omni_qc_del" >> ../output/flow_nrs.txt
echo "n_omni_dupl_del $n_omni_dupl_del" >> ../output/flow_nrs.txt
echo "n_omni_del $n_omni_del" >> ../output/flow_nrs.txt
echo "n_clean_omni $n_clean_omni" >> ../output/flow_nrs.txt


cd ..
rm -r working
