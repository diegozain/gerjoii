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
# do you want linker power?
echo do you want linker power? \(y or n\)
read link_power
echo "$link_power" > ../../$job_name/tmp/link_power.txt
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
echo choose partition \(shotq defq*\): 
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
# for linking of chain
sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
--export=job_name=$job_name link_light_.bash
# ------------------------------------------------------------------------------











