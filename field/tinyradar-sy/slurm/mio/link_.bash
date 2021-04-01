#!/bin/bash
#SBATCH -n 1                                             # run one process
#SBATCH --exclusive                                      # dont share node
#SBATCH --cpus-per-task=20                               # how many cpus?
#SBATCH -t 0-11:59:00                                    # run time (d-hh:mm:ss)
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=diegodomenzain@mines.edu
# -- set memory limits
ulimit -v unlimited
ulimit -s unlimited
ulimit -u 10000
# -- load from available modules
module load Apps/Matlab/R2020a
# -- change directory where my_job.m is.
#    this variable is defined in steady_.sh
job_path="../../$job_name/scripts/"
cd $job_path
# -- run job
matlab -nodisplay -nodesktop -r "run ./wdc_link_.m ; quit"