#!/bin/bash

bash manual_omni_fixes.sh

cat fix_omni_sample_map.R | R --vanilla
