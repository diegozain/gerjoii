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
cd gerjoii/field/$field_name/slurm/r2/
# ------------------------------------------------------------------------------
# run Mr. steady_light_.sh
./steady_light_dc_.sh
