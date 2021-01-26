#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --partition=ppc
#SBATCH --overcommit
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
##SBATCH --ntasks=1
#SBATCH --export=ALL
#SBATCH --out=%J.out

# Go to the directoy from which our job was launched
cd $SLURM_SUBMIT_DIR

#set up our environment
source /etc/profile
module purge
unset OMP_PROC_BIND


#short variable for our Job number
export JOB=$SLURM_JOBID
 
#create a compy of our script
cat $0 > $JOB.script

#not important here but needed if we 
#want to run parallel
export MP_RESD=poe
export MP_HOSTFILE=$JOB.list
export MP_LABELIO=yes

#save a copy of our environment
printenv > $JOB.env


#set the path to where our container is stored
#it is in a different place on each of the two nodes
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


#start a timer
./tymer.py time.$JOB running in container

#run our program inside of the continer
#the commented line below could be used to run another script
#singularity exec $COS ./bash_script > sing_out.$JOB 2>sing_msg.$JOB

singularity exec $COS python fully_connected_feed.py --input_data_dir=./tmp --log_dir=./tmp  > sing_out.$JOB 2>sing_msg.$JOB

#stop the timer
./tymer.py time.$JOB done with container

#I added timers to the program also 
#here we move the time data to a new file
mv mytimer mytimer_sing.$JOB


#if we are running on ppc002 we can run natively, outside the container
if [ `hostname` = "ppc002" ]
then
#set up our environment
source /opt/DL/tensorflow/bin/tensorflow-activate

#start a timer
./tymer.py time.$JOB running native tf

#run our program natively
python fully_connected_feed.py --input_data_dir=./tmp --log_dir=./tmp   > native_out.$JOB 2>native_msg.$JOB

#stop the timer
./tymer.py time.$JOB done with native tf

#I added timers to the program also 
#here we move the time data to a new file
mv mytimer mytimer_native.$JOB

#if we are running on ppc001 we can't run outside of the container
else
./tymer.py time.$JOB running native tf
echo "can't run native" > native_out.$JOB
./tymer.py time.$JOB done with native tf
fi
./tymer.py time.$JOB done
exit


