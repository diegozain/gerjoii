#!/bin/bash
# ------------------------------------------------------------------------------
# put all pics in one folder, and only the pics so it's a light folder.
# ------------------------------------------------------------------------------
# get number of labeled folders
echo number of labeled folders \(ie 3 or 100000\): 
read n_models
# ------------------------------------------------------------------------------
# loop through each label 
for ((j_=1;j_<=n_models;j_++))
do
  mkdir ../pics-data/test/$j_/
  cp ../data-set/test/$j_/wdc.png ../pics-data/test/$j_/wdc.png
done
# ------------------------------------------------------------------------------
