#!/bin/bash
# ------------------------------------------------------------------------------
# Activate forward models with parameters recovered from a previous inversion.
# ------------------------------------------------------------------------------
# ask for job name.
# names should be like folder names
ls ../..
echo name of job: 
read job_name
# ------------------------------------------------------------------------------
# clone "base" folder if necessary
# (base folders are named after the first letter of field_name)
if [ ! -d "$job_name/data-recovered/" ]
then
  mkdir "../../$job_name/data-recovered/"
  mkdir "../../$job_name/data-recovered/w/"
  mkdir "../../$job_name/data-recovered/dc/"
  cp -r ../../base/scripts/. "../../$job_name/scripts/"
fi
# ----------------------------------------------------------------------------
# choose # of workers in matlab 
echo choose number of matlab workers \(for wavefield 7g do 6 workers\): 
read n_workers
echo "$n_workers" > ../../$job_name/tmp/workers.txt
# ------------------------------------------------------------------------------
# choose partition
echo choose partition \(shortq or defq\): 
read partition
# ------------------------------------------------------------------------------
# run slurm once
sbatch --job-name=$job_name --output=$job_name.oFWD%j -p $partition \
--export=job_name=$job_name begin_fwd.bash
# ------------------------------------------------------------------------------











