#!/bin/bash
# ------------------------------------------------------------------------------
printf "\n\n%-3s---------------------------------------------"
printf "\n%-4sgonna rsync all of gerjoii!!"
printf "\n%-3s---------------------------------------------\n\n\n"
# ------------------------------------------------------------------------------
cd ..
# ------------------------------------------------------------------------------
echo r2 or kes or leh?
read server_name
# ------------------------------------------------------------------------------
if [ "$server_name" == "r2" ]
then
  server_name="ddomenzain@r2.boisestate.edu:/home/ddomenzain/gerjoii/"
elif [ "$server_name" == "kes" ]
then
  server_name="diegodomenzain@kestrel.boisestate.edu:/home/diegodomenzain/gerjoii/"
elif [ "$server_name" == "leh" ]
then
  server_name="diegozain@lehmann.mines.edu:/sonichome/diegozain/gerjoii/"
fi
# ------------------------------------------------------------------------------
rsync -r -rav -e ssh --include '*/' --include='*'.{m,bash,sh,txt} -p --exclude='*' --exclude .git/ gerjoii/ $server_name
# ------------------------------------------------------------------------------
cd gerjoii/
# ------------------------------------------------------------------------------
