#!/bin/bash

bash 1_clean_650.sh
bash 2_clean_omni.sh
bash 3_run_ibd_initial.sh
bash 4_get_650_omni_fixes.sh
bash 5_fix_pedigrees.sh
bash 6_fix_omni_sample_map.sh
bash 7_run_ibd_after_fixes.sh
bash 8_create_summary_figures.sh
cat 9_check_sex.R | R --vanilla
cat 10_get_singleton_families.R | R --vanilla
