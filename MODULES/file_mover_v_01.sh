#!/bin/bash

#path configuration
full_path=$(realpath $0)
dir_path=$(dirname $full_path)
general_path=$(dirname $dir_path)
bucket_path="$general_path/BUCKET"
module_path="$general_path/MODULES"
config_path="$general_path/CONFIG"

source_file_path="$config_path/dynamic_mapping.properties"

#source file
source $source_file_path

date=`date +%F`
file_name_loop_file=bkt_loop_file_name.txt
file_descop_loop_file=bkt_loop_descop_name.txt
global_file_path_file=PIPE_LINE_LIST.pipe

file_name=`sed '1!d' $file_name_loop_file`
descop_file=`sed '1!d' $file_descop_loop_file`

echo "$date | INFO | all path getted for updating the file"
echo "$date | INFO | moving on bucket path for getting file | path:$bucket_path"

#moving buket path
cd $bucket_path
master_loop_count=`wc --lines < $global_file_path_file`

echo "$date | INFO | etering file upadting loop"
#moving loop
for (( i=1; i<=$master_loop_count; i++ ))
	do
		moving_path=`sed ''$i'!d' $global_file_path_file`
		echo "$date | INFO | getted $i st file path as $moving_path"
		echo "$date | INFO | getted file name as $file_name"
		echo "$date | INFO | getted descop file name as $descop_file"
		
		#descoping
		if (( ${#descop_file} > 0))
		then

			rm -f $moving_path/$descop_file
			echo "$date | INFO | sucessfully descoped the file $descop_file"
		else
			echo "$date | INFO | descope file getting as null | descop file = null"
		fi

		#file copying
		cp $file_name $moving_path
		echo "$date | INFO | sucessfully updated the file $file_name in path:$moving_path"
		echo "$date | INFO | moving to pick next file path"		
	done
rm -f PIPE_LINE_LIST.pipe

echo "$date | INFO | going to start next loop"
