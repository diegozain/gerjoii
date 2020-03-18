#!/bin/bash
# ------------------------------------------------------------------------------
#               download inversion parameters and 
#            objective function history of many inversions
# ------------------------------------------------------------------------------
printf "\n\n%-3s----------------------------------"
printf "\n%-4sdownload inversion parameters"
printf "\n\n%-4sand objective function history of"
printf "\n\n%-4smany inversions."
printf "\n%-3s------------------------------------\n\n\n"
# ------------------------------------------------------------------------------
echo which server \(r2 or kestrel or lehmann\)?
read server_name
# ------------------------------------------------------------------------------
ls
echo which big project \(eg, thor-finds-water or synthetic-3\)?
read big_project_name
# ------------------------------------------------------------------------------
ls $big_project_name
# ------------------------------------------------------------------------------
echo first number of download: 
read run_
echo last number of download: 
read run__
# ------------------------------------------------------------------------------
# download path local
down_path="$big_project_name/inv-param/all"
# ------------------------------------------------------------------------------
if [ "$server_name" == "r2" ]
then
  server_path_="ddomenzain@r2.boisestate.edu:/home/ddomenzain"
elif [ "$server_name" == "kestrel" ]
then
  server_path_="diegodomenzain@kestrel.boisestate.edu:/home/diegodomenzain"
elif [ "$server_name" == "lehmann" ]
then
  server_path_="diegozain@lehmann.mines.edu:/sonichome/diegozain"
fi
# ------------------------------------------------------------------------------
# download path remote
down_path_="$server_path_/gerjoii/field/$big_project_name"
# ------------------------------------------------------------------------------
for ((i_=run_;i_<=run__;i_++))
do
  # ----------------------------------------------------------------------------
  # get first part of folder name from first letter of big_project_name
  small_project_name=$(echo "${big_project_name}" | cut -c1-1)
  small_project_name="$small_project_name$i_"
  # ----------------------------------------------------------------------------
  # general download path remote
  down_path__="$down_path_/$small_project_name/output/wdc"
  # ----------------------------------------------------------------------------
  file_path_="$down_path__/p_inv.mat"
  file_path="$down_path/p_inv$i_.mat"
  scp $file_path_ $file_path > /dev/null 2>&1
  # ----------------------------------------------------------------------------
  file_path_="$down_path__/as.mat"
  file_path="$down_path/as$i_.mat"
  scp $file_path_ $file_path > /dev/null 2>&1
  echo      downloaded $small_project_name
done
# ------------------------------------------------------------------------------
printf "\n\n%-4syour project was downloaded from:\n\n"
echo $down_path_
printf "\n\n%-4syour project was downloaded in:\n\n"
echo $down_path
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------




