#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --gres=gpu:1             # number of gpus per node
##SBATCH --ntasks=1              # total number of tasks across all nodes
#SBATCH --export=ALL             # pass current environment to nodes
#SBATCH --out=%J.out
#SBATCH --err=%J.msg
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=diegodomenzain@mines.edu

# -- get python and GPU ready
# load modules
module purge
module load PrgEnv/python/anaconda/3.7.6
conda activate tf_gpu

# -- set memory limits
# # ulimit -v unlimited
# # ulimit -s unlimited
# # ulimit -u 10000
# ulimit -c 0
# ulimit -u 4096

# -- change directory where my_job.py is.
#    this variable is defined in ml_run.sh
job_path="../../projects/$job_name/main/"
cd $job_path
# -- run job
python ml_2l.py
