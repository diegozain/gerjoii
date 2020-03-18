#!/bin/bash
# ------------------------------------------------------------------------------
#               upload parameters of synthetic data
# ------------------------------------------------------------------------------
printf "\n\n%-3s-----------------"
printf "\n%-4supload parameters"
printf "\n%-4sof synthetic data"
printf "\n%-4sfor forward models."
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------
echo which server \(sonic or lehmann or r2 or kestrel\)?
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
echo which small project \(eg, t2 or s5\)?
read small_project_name
# ------------------------------------------------------------------------------
cd $big_project_name/model-generator/nature-synth/mat-file/$small_project_name/
# ------------------------------------------------------------------------------
push_path_="gerjoii/field/$big_project_name/$small_project_name/mat-file"
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
fi
# ------------------------------------------------------------------------------
server_path_="$server_name/diegozain/Documents/MATLAB/gerjoii-versions/v$v_num"
server_path="$server_path_/$push_path_"
if [ "$server_name" == "ddomenzain@r2.boisestate.edu" ]
then
  server_path_="$server_name:/home/ddomenzain"
  server_path="$server_path_/$push_path_"
elif [ "$server_name" == "diegodomenzain@kestrel.boisestate.edu" ]
then
  server_path_="$server_name:/home/diegodomenzain"
  server_path="$server_path_/$push_path_"
elif [ "$server_name" == "diegozain@lehmann.mines.edu" ]
then
  server_path_="$server_name:/sonichome/diegozain"
  server_path="$server_path_/$push_path_"
fi
# ------------------------------------------------------------------------------
scp *.mat $server_path/
# echo $server_path_
# echo $server_path
# ------------------------------------------------------------------------------
cd ../../../../../
# ------------------------------------------------------------------------------
