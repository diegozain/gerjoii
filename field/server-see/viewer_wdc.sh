#!/bin/bash
# ------------------------------------------------------------------------------
printf "\n\n%-3s---------------------------------------------"
printf "\n%-4sgonna download epsis or sigs for fast view (v2)"
printf "\n%-3s---------------------------------------------\n\n\n"
# ------------------------------------------------------------------------------
rm *.mat
# ------------------------------------------------------------------------------
echo r2 or kes or mio?
read server_name
# ------------------------------------------------------------------------------
echo which project to download?
read project
# ------------------------------------------------------------------------------
echo which sub-project to download?
read subproject
# ------------------------------------------------------------------------------
echo epsi, sigm, depsi, dsigm, etc?
read file
# ------------------------------------------------------------------------------
if [ "$server_name" == "r2" ]
then
  server_name="ddomenzain@r2.boisestate.edu:/home/ddomenzain"
elif [ "$server_name" == "kes" ]
then
  server_name="diegodomenzain@kestrel.boisestate.edu:/home/diegodomenzain"
elif [ "$server_name" == "mio" ]
then
  server_name="diegodomenzain@mio.mines.edu:/u/wy/ba/diegodomenzain"
fi
# ------------------------------------------------------------------------------
scp $server_name/gerjoii/field/$project/\
$subproject/output/wdc/$file.mat .
# ------------------------------------------------------------------------------
# source activate seg-bsu
# ------------------------------------------------------------------------------
python viewer_w.py
# ------------------------------------------------------------------------------