#!/bin/bash
# ------------------------------------------------------------------------------
# Second script in a chain of .sh and .bash scripts that submit inversion routines.
# 
# 
#  
# 
#
# ------------------------------------------------------------------------------
# read job_name, partition, signature and server
job_name=$(sed '1!d' ../tmp/job_data.txt)
partition=$(sed '2!d' ../tmp/job_data.txt)
signature=$(sed '3!d' ../tmp/job_data.txt)
server=$(sed '4!d' ../tmp/job_data.txt)
# ------------------------------------------------------------------------------
# new signature
((signature=signature+1))
signature_="_$signature"
job_name_="$job_name$signature_"
# ------------------------------------------------------------------------------
# bundle up job_name, partition and signature
echo "$job_name" > ../tmp/job_data.txt
echo "$partition" >> ../tmp/job_data.txt
echo "$signature" >> ../tmp/job_data.txt
echo "$server" >> ../tmp/job_data.txt
# ------------------------------------------------------------------------------
path_="../../slurm/$server/"
cd $path_
# ------------------------------------------------------------------------------
# run slurm once
# for linking of chain
sbatch --job-name=$job_name_ --output=$job_name.o%j -p $partition \
--export=job_name=$job_name link_light_.bash
# ------------------------------------------------------------------------------











