#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --partition=ppc
#SBATCH --overcommit
#SBATCH --exclusive
#SBATCH --nodelist=ppc002
#SBATCH --gres=gpu:4
##SBATCH --ntasks=1
#SBATCH --export=ALL
#SBATCH --out=%J.out
#SBATCH --err=%J.msg

# Go to the directoy from which our job was launched
cd $SLURM_SUBMIT_DIR

#set up our environment
source /etc/profile
module purge

#set up our environment
source /opt/DL/tensorflow/bin/tensorflow-activate
ulimit -c 0
#this may help run better
ulimit -u 4096


#run a test
$SLURM_SUBMIT_DIR/tymer.py $SLURM_JOBID.time
python tf_test.py
$SLURM_SUBMIT_DIR/tymer.py $SLURM_JOBID.time


