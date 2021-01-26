#!/bin/bash
# ------------------------------------------------------------------------------
printf "\n\n%-3s---------------------------------------------"
printf "\n%-4s        gonna rsync all of gerjoii!!"
printf "\n%-3s---------------------------------------------\n\n\n"
# ------------------------------------------------------------------------------
cd ..
# ------------------------------------------------------------------------------
echo r2 or kes or leh or mio?
read server_name
# ------------------------------------------------------------------------------
if [ "$server_name" == "r2" ]
then
  server_name="ddomenzain@r2.boisestate.edu:/home/ddomenzain/gerjoii/"
  # ----------------------------------------------------------------------------
  rsync -r -rav -e ssh --include '*/' --include='*'.{m,bash,sh,txt} -p --exclude='*' --exclude .git/ gerjoii/ $server_name
elif [ "$server_name" == "kes" ]
then
  server_name="diegodomenzain@kestrel.boisestate.edu:/home/diegodomenzain/gerjoii/"
  # ----------------------------------------------------------------------------
  rsync -r -rav -e ssh --include '*/' --include='*'.{m,bash,sh,txt} -p --exclude='*' --exclude .git/ gerjoii/ $server_name
elif [ "$server_name" == "leh" ]
then
  server_name="diegozain@lehmann.mines.edu:/sonichome/diegozain/gerjoii/"
  # ----------------------------------------------------------------------------
  rsync -r -rav -e ssh --include '*/' --include='*'.{m,py,bash,sh,txt} -p --exclude='*' --exclude .git/ gerjoii/ $server_name
elif [ "$server_name" == "mio" ]
then
  server_name="diegodomenzain@mio.mines.edu:/u/wy/ba/diegodomenzain/gerjoii/"
  # ----------------------------------------------------------------------------
  rsync -r -rav -e ssh --include '*/' --include='*'.{m,py,bash,sh,txt} -p --exclude='*' --exclude .git/ gerjoii/ $server_name
fi
# ------------------------------------------------------------------------------
cd gerjoii/
# ------------------------------------------------------------------------------
