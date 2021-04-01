#!/bin/bash
# ------------------------------------------------------------------------------
#               NOTE: this file should go right outside gerjoii.
# ------------------------------------------------------------------------------
# ask first name of job
echo first name of job: 
read job_name
# ------------------------------------------------------------------------------
# choose first linker
echo choose number of first linker: 
read n_linker_
echo choose number of last linker: 
read n_linker
# ------------------------------------------------------------------------------
# loop through each clone 
for ((j_=n_linker_;j_<=n_linker;j_++))
do
  dash="_"
  job_name_="$job_name$dash$j_"
  # ----------------------------------------------------------------------------
  echo $job_name_
  # ----------------------------------------------------------------------------
  scancel -n $job_name_
done