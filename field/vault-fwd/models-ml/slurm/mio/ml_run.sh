#!/bin/bash
# ------------------------------------------------------------------------------
#               NOTE: this file should go right outside gerjoii.
# ------------------------------------------------------------------------------
# ask for field site
ls -d1 gerjoii/field/*-fwd
echo name of field-site: 
read field_name
# ------------------------------------------------------------------------------
# go to field site
cd gerjoii/field/$field_name/models-ml/slurm/mio/
# ------------------------------------------------------------------------------
# ask for job name.
# names should be like folder names
ls ../../projects/
echo name of job: 
read job_name
# ------------------------------------------------------------------------------
clone "base" folder if necessary
(base folders are named after the first letter of field_name)
if [ ! -d "../../projects/$job_name" ]
then
  mkdir "../../projects/$job_name"
  cp -r ../../base/. "../../projects/$job_name/"
else
  cp -r ../../base/main/. "../../projects/$job_name/main/"
fi
# ----------------------------------------------------------------------------
# get line from opti_param.txt that is meant for this job
job_number=$(echo $job_name | tr -dc '0-9')
sed ""$job_number"q;d" ../../param-ml/opti_param.txt > ../../projects/$job_name/tmp/param.txt
# ----------------------------------------------------------------------------
# # how many links should we do today?
# echo number of links: 
# read n_links
# ((n_links=n_links+1))
# # ----------------------------------------------------------------------------
# # choose # of workers
# echo choose number of workers: 
# read n_workers
# echo "$n_workers" > ../../projects/$job_name/tmp/workers.txt
# ----------------------------------------------------------------------------
# # choose # of iteration steps per job and link 
# echo choose number of iterations per job and link \(1000 or so\): 
# read tol_iter_
# echo "$tol_iter_" > ../../projects/$job_name/tmp/tol_iter_.txt
# ----------------------------------------------------------------------------
# choose partition
echo choose partition \(ppc, gpu\): 
read partition
# ------------------------------------------------------------------------------
# : <<'END'
# run slurm twice:
# once for beginning of chain,
# then for linker of chains in a for loop.
# RES takes the output of the sbatch command because we want its job-id!
RES=$(sbatch --job-name=$job_name --output=$job_name.o%j -p $partition \
--export=job_name=$job_name ml_run.bash)
# ------------------------------------------------------------------------------
: <<'END'
# linker for loop 
for ((i_=2;i_<=n_links;i_++))
do
  signature="_$i_"
  job_name_="$job_name$signature"
  RES=$(sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
  --dependency=aftercorr:${RES##* } --export=job_name=$job_name ml_continue.bash)
done
END
# ------------------------------------------------------------------------------
