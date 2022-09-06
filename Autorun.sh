#!/bin/bash

#path configuration
full_path=$(realpath $0)
dir_path=$(dirname $full_path)
general_path=$(dirname $dir_path)
bucket_path="$general_path/BUCKET"
module_path="$dir_path/MODULES"
config_path="$general_path/CONFIG"

source_file_path="$config_path/dynamic_mapping.properties"

#all scripts path
bkp_setter="$module_path/back_up_createor_v_01.sh"
dynamic_socketing="$module_path/dynamic_soket_mapping_v_01.sh"
patch_updatetor="$module_path/file_mover_v_01.sh"
date=`date +%F`

#source file
#source $source_file_path

echo "GOING TO START ...."
echo "$date | INFO | going to start the BACKUP process"
echo "$date | INFO | entering backup modules"

#call backup taking script
bash "$bkp_setter"

echo "$date | INFO | backup process is sucessfully completed going to create possible pipe lines"

#call dynamic socket mapping script
bash "$dynamic_socketing"

echo "$date | INFO | no more pipeline is avilable hece exiting from bucket loop"
echo "$date | INFO | sucessfully updated the all files in the pipe line directory"
echo "$date | INFO | STOPING the script..."

#deleting all precoss file
rm -f bkt_loop_file_name.txt bkt_loop_descop_name.txt

