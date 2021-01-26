#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --partition=gpu
#SBATCH --overcommit
#SBATCH --exclusive
#SBATCH --gres=gpu:pascal:1
##SBATCH --gres=gpu:fermi:3
##SBATCH --ntasks=1
#SBATCH --export=ALL
#SBATCH --out=%J.out
#SBATCH --err=%J.msg

# Go to the directoy from which our job was launched
cd $SLURM_SUBMIT_DIR

#set up our environment

#set up our environment
ulimit -c 0
#this may help run better
ulimit -u 4096

#set python version 2 or 3
PV=2
$SLURM_SUBMIT_DIR/tymer.py $SLURM_JOBID.time
if [[ $PV == 3 ]] ; then
  export INTEL_PYTHONHOME=/sw/compilers/scripting/python/3/3.6/comercial/intel/2018_1/intelpython3
  export PATH=$INTEL_PYTHONHOME/bin:$PATH
#run a test
  echo "running " `which python3`
  python3 tf_test.py
else
  export INTEL_PYTHONHOME=/sw/compilers/scripting/python/2/2.7/comercial/intel/2018_1/intelpython2
  export PATH=$INTEL_PYTHONHOME/bin:$PATH
#run a test
  echo "running " `which python`
  python tf_test.py
fi
$SLURM_SUBMIT_DIR/tymer.py $SLURM_JOBID.time



