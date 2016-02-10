HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/650.* .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/illumina_qc_report.txt .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/manifest.txt .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/original_sample_map.txt .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/overlap_snps_650_omni.txt .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/pedigrees.txt .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_3/final_report/data/input/sample_map.txt .
mv original_sample_map.txt sample_map.txt
HDC-D-DAYAM-MAC:scripts dayam$ cp ../../iteration_2/data/working/orig_omni.fam .
HDC-D-DAYAM-MAC:scripts dayam$ cp ../../iteration_2/data/working/array.* .
HDC-D-DAYAM-MAC:scripts dayam$ cd ../data/input/
HDC-D-DAYAM-MAC:input dayam$ mv array.bed omni.bed
HDC-D-DAYAM-MAC:input dayam$ mv array.bim omni.bim
HDC-D-DAYAM-MAC:input dayam$ mv array.fam omni.fam
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_2/data/raw/HumanOmni2-5-8-v1-2-A-b138-rsIDs.txt .
HDC-D-DAYAM-MAC:input dayam$ cp ../../iteration_2/data/raw/uscs.hg19.snp142.chr* .
