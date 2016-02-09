#!/bin/bash

#Check user parameters
if [ "$#" -eq  "0" ];
then
    echo "Usage: ${0##*/} <in_file_name> <out_file_name> <data_set1> <data_set2>"
    exit
fi

#Setup
in_file_name=$1
out_file_name=$2
data_set1=$3
data_set2=$4

head -1 $in_file_name >  $out_file_name
grep $data_set1 $in_file_name | grep $data_set2 >> $out_file_name
