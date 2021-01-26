#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --partition=ppc
#SBATCH --overcommit
#SBATCH --exclusive
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
if [ `hostname` = "ppc002" ]
then
  export CONTAINER_DIR=/data
else
  export CONTAINER_DIR=/software/apps/singularity/containers
fi
export COS=$CONTAINER_DIR/IBM_mldl_ppc64el.img

ulimit -c 0
#this may help run better
ulimit -u 4096


#run a test
singularity exec $COS python tf_test.py


