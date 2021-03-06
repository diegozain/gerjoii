#!/bin/bash
# ------------------------------------------------------------------------------
#               download observed data of synthetic example
# ------------------------------------------------------------------------------
printf "\n\n%-3s------------------------"
printf "\n%-4sdownload observed data"
printf "\n\n%-4sof synthetic example."
printf "\n%-3s------------------------\n\n\n"
# ------------------------------------------------------------------------------
cd ../
# ------------------------------------------------------------------------------
echo which server \(sonic or lehmann or r2 or kestrel or mio\)?
read server_name
# ------------------------------------------------------------------------------
# echo which gerjoii version?
# read v_num
v_num=9
# ------------------------------------------------------------------------------
ls
echo which big project \(eg, thor-finds-water or synthetic-3\)?
read big_project_name
# ------------------------------------------------------------------------------
ls $big_project_name
echo which small project \(eg, b2, l1, etc\)?
read small_project_name
# ------------------------------------------------------------------------------
# download path remote
down_path_="$big_project_name/$small_project_name/data-synth"
down_path_="gerjoii/field/$down_path_"
# download path local
down_path="$big_project_name/$small_project_name"
# ------------------------------------------------------------------------------
if [ ! -d "$down_path" ]; then
  mkdir -p $down_path
fi
cd $down_path
# ------------------------------------------------------------------------------
if [ "$server_name" == "sonic" ]
then
  server_name="diegozain@sonic.boisestate.edu:/home"
elif [ "$server_name" == "lehmann" ]
then
  server_name="diegozain@lehmann.mines.edu"
elif [ "$server_name" == "r2" ]
then
  server_name="ddomenzain@r2.boisestate.edu"
elif [ "$server_name" == "kestrel" ]
then
  server_name="diegodomenzain@kestrel.boisestate.edu"
elif [ "$server_name" == "mio" ]
then
  server_name="diegodomenzain@mio.mines.edu"
fi
# ------------------------------------------------------------------------------
server_path_="$server_name/diegozain/Documents/MATLAB/gerjoii-versions/v$v_num"
server_path="$server_path_/$down_path_"
if [ "$server_name" == "ddomenzain@r2.boisestate.edu" ]
then
  server_path_="$server_name:/home/ddomenzain"
  server_path="$server_path_/$down_path_"
elif [ "$server_name" == "diegodomenzain@kestrel.boisestate.edu" ]
then
  server_path_="$server_name:/home/diegodomenzain"
  server_path="$server_path_/$down_path_"
elif [ "$server_name" == "diegozain@lehmann.mines.edu" ]
then
  server_path_="$server_name:/sonichome/diegozain"
  server_path="$server_path_/$down_path_"
elif [ "$server_name" == "diegodomenzain@mio.mines.edu" ]
then
  server_path_="$server_name:/u/wy/ba/diegodomenzain"
  server_path="$server_path_/$down_path_"
fi
# ------------------------------------------------------------------------------
scp -r $server_path .
cd ../..
# ------------------------------------------------------------------------------
printf "\n\n%-4syour project was downloaded from:\n\n"
echo $server_path
printf "\n\n%-4syour project was downloaded in:\n\n"
echo $down_path
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------




