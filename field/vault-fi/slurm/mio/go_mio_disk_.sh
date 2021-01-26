#!/bin/bash
# ------------------------------------------------------------------------------
#               NOTE: this file should go right outside gerjoii.
# ------------------------------------------------------------------------------
# ask for field site
ls gerjoii/field/
echo name of field-site: 
read field_name
# ------------------------------------------------------------------------------
# go to field site
cd gerjoii/field/$field_name/slurm/mio/
# ------------------------------------------------------------------------------
# run Mr. steady_.sh
./steady_disk_.sh
