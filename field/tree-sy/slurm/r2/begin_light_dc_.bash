#!/bin/bash
#SBATCH -n 1                                             # run one process
#SBATCH --exclusive                                      # dont share node
#SBATCH --cpus-per-task=20                               # how many cpus?
#SBATCH -t 0-11:59:00                                    # run time (d-hh:mm:ss)
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=diegodomenzain@u.boisestate.edu
#SBATCH -N 1                                             # nodecount
#SBATCH -c 28           # SLURM_CPUS_PER_TASK=the number of workers your calling
# -- set memory limits
ulimit -v unlimited
ulimit -s unlimited
ulimit -u 10000
# -- load from available modules
module load matlab/r2019a
# -- change directory where my_job.m is.
#    this variable is defined in steady_.sh
job_path="../../$job_name/scripts/"
cd $job_path
# -- run job
matlab -nosplash -nodesktop -r "run ./dc_begin_light_.m ;"