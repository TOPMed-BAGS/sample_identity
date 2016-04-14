#!/bin/bash

cat fix_omni_sample_map_check_qc_identity.R | R --vanilla

bash run_ibd_qc_id_check.sh

bash create_qc_id_check_summary_figures.sh
