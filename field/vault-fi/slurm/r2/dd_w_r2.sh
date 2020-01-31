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
cd gerjoii/field/$field_name/
# ------------------------------------------------------------------------------
# choose partition
echo choose partition \(shortq or defq*\): 
read partition
# ------------------------------------------------------------------------------
# choose number of clones
echo choose number of first clone: 
read n_clones_
echo choose number of last clone: 
read n_clones
# ------------------------------------------------------------------------------
# choose # of links to do today (for all clones the same)
echo choose number of links \(same for all clones\): 
read n_links
((n_links=n_links+1))
# ----------------------------------------------------------------------------
# choose # of workers in matlab 
echo choose number of matlab workers \(for wavefield 7g do 6 workers\): 
read n_workers
# ----------------------------------------------------------------------------
# choose # of iteration steps per job and link 
echo choose number of iterations per job and link \(10 or so\): 
read tol_iter_
# ------------------------------------------------------------------------------
# get name of job_Name from first letter of field_name
job_Name=$(echo "${field_name}" | cut -c1-1)
# ------------------------------------------------------------------------------
# go to slurm/kestrel 
cd slurm/kestrel/
# ------------------------------------------------------------------------------
# loop through each clone 
for ((j_=n_clones_;j_<=n_clones;j_++))
do
  job_name="$job_Name$j_"
  signature="_1"
  job_name_="$job_name$signature"
  # ----------------------------------------------------------------------------
  # clone "base" folder if necessary
  # (base folders are named after the first letter of field_name)
  if [ ! -d "$job_name" ]; then
    mkdir "../../$job_name"
    cp -r ../../base/. "../../$job_name/"
  else
    cp -r ../../base/scripts/. "../../$job_name/scripts/"
  fi
  # ----------------------------------------------------------------------------
  echo "$n_workers" > ../../$job_name/tmp/workers.txt
  echo "$tol_iter_" > ../../$job_name/tmp/tol_iter_.txt
  # ----------------------------------------------------------------------------
  # run slurm twice:
  # once for beginning of chain,
  # then for linker of chains in a for loop.
  # RES takes the output of the sbatch command because we want its job-id!
  RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
  --export=job_name=$job_name begin_w_.bash)
  # ----------------------------------------------------------------------------
  # linker for loop 
  for ((i_=2;i_<=n_links;i_++))
  do
    signature="_$i_"
    job_name_="$job_name$signature"
    RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
    --dependency=aftercorr:${RES##* } --export=job_name=$job_name link_w_.bash)
  done
done