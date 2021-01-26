#!/bin/bash
# ------------------------------------------------------------------------------
# put all pics in one folder, and only the pics so it's a light folder.
# ------------------------------------------------------------------------------
# get number of labeled folders
echo number of labeled folders \(ie 3 or 100000\): 
read n_models
# ------------------------------------------------------------------------------
# name the folder
echo folder name \(ie pics-data\):
read dir_name
# ------------------------------------------------------------------------------
# choose file name
echo choose file name \(ie wdc or w or dd or wen\):
read file_
# ------------------------------------------------------------------------------
mkdir ../pics-ml/$dir_name/
mkdir ../pics-ml/$dir_name/train/
mkdir ../pics-ml/$dir_name/test/
# ------------------------------------------------------------------------------
# loop through each label 
for ((j_=1;j_<=n_models;j_++))
do
  mkdir ../pics-ml/$dir_name/train/$j_/
  cp ../data-set/train/$j_/$file_.png ../pics-ml/$dir_name/train/$j_/.
  # ----------------------------------------------------------------------------
  # for now, the testing set is the same as the training test. this has to change!
  mkdir ../pics-ml/$dir_name/test/$j_/
  cp ../data-set/train/$j_/$file_.png ../pics-ml/$dir_name/test/$j_/.
done
# ------------------------------------------------------------------------------
