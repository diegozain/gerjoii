#!/bin/bash
# ------------------------------------------------------------------------------
# First script in a chain of .sh and .bash scripts that submit inversion routines.
# 
# 
#  
# 
#
# ------------------------------------------------------------------------------
# ask for job name.
# names should be like folder names
ls ../..
echo name of job: 
read job_name
# ------------------------------------------------------------------------------
# clone "base" folder if necessary
# (base folders are named after the first letter of field_name)
if [ ! -d "$job_name" ]
then
  mkdir "../../$job_name"
  cp -r ../../base/. "../../$job_name/"
else
  cp -r ../../base/scripts/. "../../$job_name/scripts/"
fi
# ------------------------------------------------------------------------------
# do you want linker power?
echo do you want linker power? \(y or n\)
read link_power
echo "$link_power" > ../../$job_name/tmp/link_power.txt
# ----------------------------------------------------------------------------
# choose # of iteration steps per job and link 
echo choose number of iterations per job and link \(10 or so\): 
read tol_iter_
echo "$tol_iter_" > ../../$job_name/tmp/tol_iter_.txt
# ----------------------------------------------------------------------------
# choose # of workers in matlab 
echo choose number of matlab workers \(for wavefield 7g do 6 workers\): 
read n_workers
echo "$n_workers" > ../../$job_name/tmp/workers.txt
# ------------------------------------------------------------------------------
# choose partition
echo choose partition \(compute* or geop\): 
read partition
# ------------------------------------------------------------------------------
# assign first subindex to job name (not to parent job)
signature="1"
signature_="_$signature"
job_name_="$job_name$signature_"
# ------------------------------------------------------------------------------
# get server
server=${PWD##*/}
# ------------------------------------------------------------------------------
# bundle up job_name, partition, signature and server
echo "$job_name" > ../../$job_name/tmp/job_data.txt
echo "$partition" >> ../../$job_name/tmp/job_data.txt
echo "$signature" >> ../../$job_name/tmp/job_data.txt
echo "$server" >> ../../$job_name/tmp/job_data.txt
# ------------------------------------------------------------------------------
# run slurm once
# for beginning of chain
sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
--export=job_name=$job_name begin_light_w_.bash
# ------------------------------------------------------------------------------











