#!/bin/bash
# ------------------------------------------------------------------------------
#               upload data for learning machine
#            
# ------------------------------------------------------------------------------
printf "\n\n%-3s------------------------------"
printf "\n%-4supload data for learning machine"
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
# upload path local
push_path="$big_project_name/models-ml/mat-file/field/"
# ------------------------------------------------------------------------------
# upload path remote
push_path_="$server_path_/gerjoii/field/$big_project_name/models-ml/mat-file/"
# ------------------------------------------------------------------------------
scp -r $push_path $push_path_
# ------------------------------------------------------------------------------
printf "\n\n%-4syour project was uploaded from:\n\n"
echo $push_path
printf "\n\n%-4syour project was uploaded to:\n\n"
echo $push_path_
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------

