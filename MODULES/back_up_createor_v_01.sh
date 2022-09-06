#!/bin/bash

#path configuration
full_path=$(realpath $0)
dir_path=$(dirname $full_path)
general_path=$(dirname $dir_path)
bucket_path="$general_path/BUCKET"
module_path="$general_path/MODULES"
config_path="$general_path/CONFIG"

source_file_path="$config_path/backup.properties"
bkp_path_file="$config_path/backup_file_path_list.cfg"
bkp_dir_list="$config_path/backup_list.cfg"
dir="$bucket_path/bkp_dir_cound.bkp"
#source file
source $source_file_path



date=`date +%F`
DIR=FOLDER
bkp_count=bkp_file_count.txt
bkp_list_file="$config_path/backup_list.cfg"
bkp_dir_lst_file=bkp_dir_cound.bkp
master_loop_count=0
bkp_path=/

#moving bucket path
cd $bucket_path

master_loop_count=`wc --lines < $bkp_path_file`
#master loop
for (( j=1; j<=$master_loop_count; j++ ))
        do
                bkp_path=`sed ''$j'!d' $bkp_path_file`
		dir_raw=`sed ''$j'!d' $bkp_dir_list`
		
		#split dir name with dlimeter
		IFS=',' read -ra ADDR <<<"$dir_raw"

                for k in "${ADDR[@]}"
                do
                        #merging variables in file
                        echo $k >> bkp_dir_cound.bkp

                done
		n_loop_count=`wc --lines < bkp_dir_cound.bkp`
		echo "$date | INFO | moving backup folder path $bkp_path"

		#move to bkp folder
		cd $bkp_path

		echo "$date | INFO | checking old backupfiels present in the $bkp_path"

		#checking bkp fle exist or not
		for (( n=1; n<=$n_loop_count; n++ ))
       		do
			dir_name=`sed ''$n'!d' $dir`
			find -name 'BKP_'$dir_name'*' > bkp_file_count.txt
               		bkp_file_count=`wc --lines < $bkp_count`

                	#check the bkp file is exist or not
                	if (( $bkp_file_count > 0 ))
                	then
                        	echo "$date | INFO | old backup file is present directory of $dir_name hence going to remove old backup files in $bkp_path"
                                rm -f BKP_$dir_name*
                                echo "$date | INFO | removed old backup files in $bkp_path of directory $dir_name"
                                echo "$date | INFO | created  new backup file of $dir_name in $bkp_path"
				
				tar -cvzf BKP_${dir_name}_${date}.tgz $dir_name
				#remove process file
				rm -f bkp_file_count.txt
                else
                                echo "$date | INFO | old backup file is not present hence going to take new backup files of $dir_name in $bkp_path"
                                echo "$date | INFO | created  new backup file of $dir_name in $bkp_path"

                                tar -cvzf BKP_${dir_name}_${date}.tgz $dir_name
				rm -f bkp_file_count.txt
                fi


	
		done
        done
#remove process file
cd $bucket_path

rm -f bkp_dir_cound.bkp
cd $module_path
