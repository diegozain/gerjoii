#!/bin/bash
# ------------------------------------------------------------------------------
# First script in a chain of .sh and .bash scripts that submit inversion routines.
# After steady.sh is activated, begin_.bash turns on submitting the starting 
#   job of the inversion with name of the folder it acts in + the number 1. 
# Then the for loop with link_2.bash turns on and submits jobs with the same  
#   folder name + numbers 2:n_links that will only start when the previous job 
#   is done.
# ------------------------------------------------------------------------------
# ask for job name.
# names should be like folder names
ls ../..
echo name of job: 
read job_name
# ------------------------------------------------------------------------------
# clone "base" folder if necessary
# (base folders are named after the first letter of field_name)
if [ ! -d "$job_name" ]; then
  mkdir "../../$job_name"
  cp -r ../../base/. "../../$job_name/"
else
  cp -r ../../base/scripts/. "../../$job_name/scripts/"
fi
# ------------------------------------------------------------------------------
# how many links should we do today?
echo number of links: 
read n_links
((n_links=n_links+1))
# ----------------------------------------------------------------------------
# choose # of workers in matlab 
echo choose number of matlab workers \(for wavefield 7g do 10 workers\): 
read n_workers
echo "$n_workers" > ../../$job_name/tmp/workers.txt
# ----------------------------------------------------------------------------
# choose # of iteration steps per job and link 
echo choose number of iterations per job and link \(10 or so\): 
read tol_iter_
echo "$tol_iter_" > ../../$job_name/tmp/tol_iter_.txt
# ------------------------------------------------------------------------------
# choose partition
echo choose partition \(compute* or geop\): 
read partition
# ------------------------------------------------------------------------------
# run slurm twice:
# once for beginning of chain,
# then for linker of chains in a for loop.
# RES takes the output of the sbatch command because we want its job-id!
RES=$(sbatch --job-name=$job_name --output=$job_name.o%j -p $partition \
--export=job_name=$job_name begin_disk_.bash)
# ------------------------------------------------------------------------------
# linker for loop 
for ((i_=2;i_<=n_links;i_++))
do
  signature="_$i_"
  job_name_="$job_name$signature"
  RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
  --dependency=aftercorr:${RES##* } --export=job_name=$job_name link_disk_.bash)
done











