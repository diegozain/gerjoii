#!/bin/bash
# ------------------------------------------------------------------------------
printf "\n\n%-3s-----------------"
printf "\n%-4sdownload stuff."
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------
cd ../
# ------------------------------------------------------------------------------
echo which server \(sonic or lehmann or r2\)?
read server_name
# ---------------
# echo which gerjoii version?
# read v_num
v_num=9
# ---------------
ls
echo which big project \(eg, thor-finds-water or synthetic-3\)?
read big_project_name
# big_project_name="synthetic-3"
# echo by default big project is synthetic-3
# echo go to source to comment me and change that.
# ---------------
echo dc, w, wdc?
read wdc_name
if [ "$wdc_name" == "wdc" ]; then
  # noise folder?
  echo noise folder? \(y or n\)
  read noise_question
  # updates for videos?
  echo wanna download iteration updates? \(y or n\)
  read video_question
fi
# ---------------
echo which small project \(eg, sig-low\)?
read small_project_name
# ---------------
echo which small-small project to download \in local \(eg, 50iter-1\)?
to_choose="$big_project_name/$wdc_name-inv/buffer-pics/$small_project_name/\
$server_name"
ls $to_choose
read ss_project_name
# ------------------------------------------------------------------------------
# download path remote
down_path_="$big_project_name/$wdc_name-inv/buffer-pics/$small_project_name"
down_path_="gerjoii/field/$down_path_"
# download path local
down_path="$to_choose/$ss_project_name/"
if [ ! -d "$down_path" ]; then
  # Control will enter here if $DIRECTORY does not exist.
  mkdir $down_path
fi
# ------------------------------------------------------------------------------
cd $down_path
# ------------------------------------------------------------------------------
if [ "$server_name" == "sonic" ]
then
  server_name="diegozain@sonic.boisestate.edu:/home"
elif [ "$server_name" == "lehmann" ]
then
  server_name="diegozain@lehmann.mines.edu:/sonichome"
elif [ "$server_name" == "r2" ]
then
  server_name="ddomenzain@r2.boisestate.edu"
fi
# ------------------------------------------------------------------------------
server_path_="$server_name/diegozain/Documents/MATLAB/gerjoii-versions/v$v_num"
server_path="$server_path_/$down_path_"
if [ "$server_name" == "ddomenzain@r2.boisestate.edu" ]
then
  server_path_="$server_name:/home/ddomenzain"
  server_path="$server_path_/$down_path_"
fi
scp_this="$server_path/*.mat"
if [ "$wdc_name" == "wdc" ]; then
  if [ "$noise_question" == "y" ]; then
    scp_this="$server_path/noise/*.mat"
  fi
fi
# ------------------------------------------------------------------------------
scp $scp_this .
# ------------------------------------------------------------------------------
cd ../../../../../../
# ------------------------------------------------------------------------------
printf "\n\n%-4syour project was downloaded from:\n\n"
echo $scp_this
printf "\n\n%-4syour project was downloaded in:\n\n"
echo $down_path
printf "\n%-3s-----------------\n\n\n"
# ------------------------------------------------------------------------------
if [ "$video_question" == "y" ]; then
  down_path="$big_project_name/$wdc_name-inv/depsis"
  cd $down_path
  rm *.mat
  scp_this="$server_path_/gerjoii/field/$down_path/*.mat"
  scp $scp_this .
  cd ../dsigs/
  down_path="gerjoii/field/$big_project_name/$wdc_name-inv/dsigs"
  rm *.mat
  scp_this="$server_path_/$down_path/*.mat"
  scp $scp_this .
fi
# ------------------------------------------------------------------------------
cd ../../../
# ------------------------------------------------------------------------------