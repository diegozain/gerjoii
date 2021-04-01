#!/bin/bash
# ------------------------------------------------------------------------------
# if an inversion got cut, this script continous it.
# ------------------------------------------------------------------------------
# ask for job name.
# names should be like folder names
ls ../..
echo name of job: 
read job_name
# ------------------------------------------------------------------------------
# how many links should we do today?
echo number of links: 
read n_links
((n_links=n_links+2))
# ------------------------------------------------------------------------------
# choose partition
echo choose partition \(compute* or geop\): 
read partition
# ------------------------------------------------------------------------------
# run slurm twice:
# once for beginning of link,
# then for linker of chains in a for loop.
# RES takes the output of the sbatch command because we want its job-id!
signature="_2"
job_name_="$job_name$signature"
RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
--export=job_name=$job_name link_.bash)
# ------------------------------------------------------------------------------
# linker for loop 
for ((i_=3;i_<=n_links;i_++))
do
  signature="_$i_"
  job_name_="$job_name$signature"
  RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
  --dependency=aftercorr:${RES##* } --export=job_name=$job_name link_.bash)
done











