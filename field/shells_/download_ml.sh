#!/bin/bash
# ------------------------------------------------------------------------------
#               download test or training data
#            for machine learning
# ------------------------------------------------------------------------------
printf "\n\n%-3s------------------------------"
printf "\n%-4sdownload test or train data "
printf "\n%-4sfor machine learning"
printf "\n%-3s--------------------------------\n\n\n"
# ------------------------------------------------------------------------------
cd ../
# ------------------------------------------------------------------------------
echo which server \(r2 or kestrel or lehmann\)?
read server_name
# ------------------------------------------------------------------------------
ls
echo which big project \(eg, thor-finds-water or synthetic-3\)?
read big_project_name
# ------------------------------------------------------------------------------
echo synthetic or field \(eg, set or field\)?
read set_field
# ------------------------------------------------------------------------------
echo test or train?
read test_train
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
# download paths
data_set="data-$set_field/"
if [ "$set_field" == "set" ]
then
  mat_file="mat-file"
elif [ "$set_field" == "field" ]
  mat_file="mat-file/field"
fi
# ------------------------------------------------------------------------------
# download path local
down_path="$big_project_name/models-ml"
# ------------------------------------------------------------------------------
# purge
rm -r $down_path/$data_set/$test_train/*
# ------------------------------------------------------------------------------
# download path remote
down_path_="$server_path_/gerjoii/field/$big_project_name/models-ml"
# ------------------------------------------------------------------------------
scp -r $down_path_/$data_set/$test_train/* $down_path/$data_set/$test_train/. > /dev/null 2>&1
scp $down_path_/$mat_file/* $down_path/$mat_file/.
# ------------------------------------------------------------------------------
printf "\n\n%-4syour project was downloaded from:\n\n"
echo $down_path_
printf "\n\n%-4syour project was downloaded in:\n\n"
echo $down_path
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------




