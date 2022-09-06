#!/bin/bash

#path configuration
full_path=$(realpath $0)
dir_path=$(dirname $full_path)
general_path=$(dirname $dir_path)
bucket_path="$general_path/BUCKET"
module_path="$general_path/MODULES"
config_path="$general_path/CONFIG"

source_file_path="$config_path/dynamic_mapping.properties"
file_mover_script_path="$module_path/file_mover_v_01.sh"

#source file
source $source_file_path

date=`date +%F`
pipe_line_token="$bucket_path/pipe_line_token.cfg"
file_name="$bucket_path/file_name.cfg"
file_descop="$bucket_path/file_descope.cfg"
pipe_line_dse="$config_path/pipe_line_desc.pipe"
socket_list="$config_path/socket_list.pipe"

master_loop_count=`wc --lines < $pipe_line_token`
pipe_line_name=0
file=0
descope_file_name=0
raw_pipe_line=0
socket_id=0
socket=0
pipe_path=pipe_line_raw.pipe
echo "$date | INFO | getting pipe line and file name from pipe_line_token.cfg"

#master loop
for (( i=1; i<=$master_loop_count; i++ ))
        do
		echo "$date | INFO | started $i st bucket loop"
		
		#getting pipeline name and file name from bucket configuration
		pipe_line_name=`sed ''$i'!d' $pipe_line_token`
		file=`sed ''$i'!d' $file_name`
		descope_file_name=`sed ''$i'!d' $file_descop`
		
		#file for file name
		echo $file > bkt_loop_file_name.txt
		#file for descop
		echo $descope_file_name > bkt_loop_descop_name.txt
		
		echo "$date | INFO | getted pipe line neme as $pipe_line_name and file name as $file and file descope as $descope_file_name"
		echo "$date | INFO | getting pipe line path from pipe_line_desc.pipe"
		
		#isolating pipe line path from pipe line desce file
		grep ''$pipe_line_name'' $pipe_line_dse | cut -d "$cut_parameter" -f2- > pipe_line_raw.pipe
		raw_pipe_line=`sed '1!d' $pipe_path`

		echo "$date | INFO | getted pipe line raw path as $raw_pipe_line"
		echo "$date | INFO | getting socket id from raw path | path:$raw_pipe_line"
		#spit the raw pipeline with delimiter		
		IFS=''$delimiter'' read -ra ADDR <<<"$raw_pipe_line"

                for j in "${ADDR[@]}"
                do
                        #merging variables in file
                        echo $j >> lsh_rsh_mid.pipe

                done
		soket_id=`sed '2!d' lsh_rsh_mid.pipe`
		LSH=`sed '1!d' lsh_rsh_mid.pipe`
		RSH=`sed '3!d' lsh_rsh_mid.pipe`
		socket=`grep ''$soket_id'' $socket_list | cut -d "$cut_parameter" -f2-`
		#getting socket description from soket file	
		
		echo "$date | INFO | getted socket id as $soket_id hece find the socket name name from socket_list.pipe"
		echo "$date | INFO | getted socket name as $socket hence find LSH and RSH"
		echo "$date | INFO | getted RSH LSH and socke |RSH = $RSH LSH=$LSH socket=$socket"
		echo "$date | INFO | all varible get hence going to create all path from varible"
		echo "$date | INFO | instas id geteed as $instanc_count"

		for (( k=1; k<=$instanc_count; k++ ))
       		 do
			#merging all poosible path with varibles
                	echo "${LSH}${socket}${k}${RSH}" >> $bucket_path/PIPE_LINE_LIST.pipe
			echo "$date | INFO | geted $k st path as ${LSH}${socket}${k}${RSH}"

       		 done
		
		#removing all procss file
		rm -f pipe_line_raw.pipe lsh_rsh_mid.pipe
		echo "$date | INFO | $i st bucket loop end"

		#call file mover script
		bash "$file_mover_script_path"
        done


