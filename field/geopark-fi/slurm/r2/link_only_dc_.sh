#!/bin/bash
# ------------------------------------------------------------------------------
# if an inversion got cut, this script continous it.
# ------------------------------------------------------------------------------
# ask for job name.
# names should be like folder names
ls ../..
echo name of job \(choose from existing folder name\): 
read job_name
# ----------------------------------------------------------------------------
# choose # of iterations 
tol_iter=$(cat ../../$job_name/tmp/tol-iter.txt)
echo number of current max iterations is $tol_iter
echo choose new \(or same\) max number of iterations: 
read tol_iter
echo "$tol_iter" > ../../$job_name/tmp/tol-iter.txt
# ------------------------------------------------------------------------------
# how many links should we do today?
echo number of links: 
read n_links
((n_links=n_links+2))
# ----------------------------------------------------------------------------
# choose # of iteration steps per job and link 
tol_iter_=$(cat ../../$job_name/tmp/tol_iter_.txt)
echo number of current iterations per job and link is $tol_iter_
echo choose number of iterations per job and link \(10 or so\): 
read tol_iter_
echo "$tol_iter_" > ../../$job_name/tmp/tol_iter_.txt
# ----------------------------------------------------------------------------
# choose # of workers in matlab 
n_workers=$(cat ../../$job_name/tmp/workers.txt)
echo number of current matlab workers is $n_workers
echo choose number of matlab workers \(for wavefield 7g do 6 workers\): 
read n_workers
echo "$n_workers" > ../../$job_name/tmp/workers.txt
# ------------------------------------------------------------------------------
# choose partition
echo choose partition \(shortq or defq*\): 
read partition
# ------------------------------------------------------------------------------
# run slurm twice:
# once for beginning of link,
# then for linker of chains in a for loop.
# RES takes the output of the sbatch command because we want its job-id!
signature="_2"
job_name_="$job_name$signature"
RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
--export=job_name=$job_name link_dc_.bash)
# ------------------------------------------------------------------------------
# linker for loop 
for ((i_=3;i_<=n_links;i_++))
do
  signature="_$i_"
  job_name_="$job_name$signature"
  RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
  --dependency=aftercorr:${RES##* } --export=job_name=$job_name link_dc_.bash)
done











