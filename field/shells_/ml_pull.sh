#!/bin/bash
# ------------------------------------------------------------------------------
#               download learning machine
#            
# ------------------------------------------------------------------------------
printf "\n\n%-3s------------------------------"
printf "\n%-4sdownload learning machine "
printf "\n%-3s--------------------------------\n\n\n"
# ------------------------------------------------------------------------------
cd ../
# ------------------------------------------------------------------------------
echo which server \(r2 or kestrel or lehmann or mio\)?
read server_name
# ------------------------------------------------------------------------------
ls -d1 *-fwd
echo which big project \(eg, thor-finds-water or synthetic-3\)?
read big_project_name
# ------------------------------------------------------------------------------
echo which small project name \(e.g. v2\)?
read small_project_name
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
elif [ "$server_name" == "mio" ]
then
  server_path_="diegodomenzain@mio.mines.edu:/u/wy/ba/diegodomenzain"
fi
# ------------------------------------------------------------------------------
# download path local
down_path="$big_project_name/models-ml/projects/$small_project_name/output/"
# ------------------------------------------------------------------------------
# create folder in case it doesn't exist
if [ ! -d "$down_path" ]; then
  mkdir -p $down_path
fi
# ------------------------------------------------------------------------------
# download path remote
down_path_="$server_path_/gerjoii/field/$down_path"
# ------------------------------------------------------------------------------
scp $down_path_/* $down_path.
# ------------------------------------------------------------------------------
printf "\n\n%-4syour project was downloaded from:\n\n"
echo $down_path_
printf "\n\n%-4syour project was downloaded in:\n\n"
echo $down_path
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------
