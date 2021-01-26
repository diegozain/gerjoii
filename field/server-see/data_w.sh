#!/bin/bash
# ------------------------------------------------------------------------------
printf "\n\n%-3s---------------------------------------------"
printf "\n%-4sgonna download w data for fast view (v2)"
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
echo which line number?
read line
# ------------------------------------------------------------------------------
echo real or synthetic data \(real or synth\)?
read synth_real
# ------------------------------------------------------------------------------
file="line$line.mat"
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
if [ "$synth_real" == "real" ]
then
  scp $server_name/gerjoii/field/$project/data/w/$file .
  mv $file "obs_$file"
  # ----------------------------------------------------------------------------
  scp $server_name/gerjoii/field/$project/$subproject/data-recovered/w/$file .
elif [ "$synth_real" == "synth" ]
then
  scp $server_name/gerjoii/field/$project/$subproject/data-synth/w/$file .
  mv $file "obs_$file" 
  # ----------------------------------------------------------------------------
  scp $server_name/gerjoii/field/$project/$subproject/data-recovered/w/$file .
fi
# ------------------------------------------------------------------------------
# source activate seg-bsu
# ------------------------------------------------------------------------------
python data_w.py
# ------------------------------------------------------------------------------
