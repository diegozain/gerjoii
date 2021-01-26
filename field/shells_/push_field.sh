#!/bin/bash
# ------------------------------------------------------------------------------
#               upload parameters of field data
# ------------------------------------------------------------------------------
printf "\n\n%-3s-----------------"
printf "\n%-4supload parameters"
printf "\n%-4sof field data."
printf "\n%-3s-----------------\n\n\n"
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
cd $big_project_name/
# ------------------------------------------------------------------------------
echo do you want w or dc? \(w or dc\)
read w_dc
# ------------------------------------------------------------------------------
echo do you want all? \(a if yes\)
read some_a
echo do you want only wave \(or dc\) parame_? \(p if yes\)
read some_p
echo do you want only initial models? \(i if yes\)
read some_i
# ------------------------------------------------------------------------------
if [ "$some_p" == "p" ]
then
  push_path_="gerjoii/field/$big_project_name/data/$w_dc/"
elif [ "$some_i" == "i" ]
then
  push_path_="gerjoii/field/$big_project_name/data/initial-guess/"  
elif [ "$some_a" == "a" ]
then
  push_path_="gerjoii/field/$big_project_name/"
fi
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
elif [ "$server_name" == "diegodomenzain@mio.mines.edu" ]
then
  server_path_="$server_name:/u/wy/ba/diegodomenzain"
  server_path="$server_path_/$push_path_"
fi
# ------------------------------------------------------------------------------
echo $server_path
# ------------------------------------------------------------------------------
if [ "$some_p" == "p" ]
then
  scp data/$w_dc/parame_.mat $server_path
elif [ "$some_i" == "i" ]
then
  scp data/initial-guess/*.mat $server_path
elif [ "$some_a" == "a" ]
then
  scp -r data $server_path
fi
cd ..
# ------------------------------------------------------------------------------
