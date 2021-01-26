#!/bin/bash
#SBATCH -n 1 
#SBATCH --mem-per-cpu=1G
#SBATCH -t 0-11:59:00 # run time (d-hh:mm:ss)
#SBATCH -J matlab-tester
#SBATCH --out=%J.out
#SBATCH --err=%J.msg

# -- set memory limits
ulimit -v unlimited
ulimit -s unlimited
ulimit -u 10000
# -- load from available modules
module load Apps/Matlab/R2020a
# -- change directory where my_job.m is.
cd ../scripts/
# -- clean 
rm -r domains/*
# -- run job
matlab -nodisplay -nodesktop -r "run ./wdc_begin_disk_.m ; quit"
# -- clean 
rm -r domains/*