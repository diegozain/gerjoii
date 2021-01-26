#!/bin/bash
# ------------------------------------------------------------------------------
# put all pics in one folder, and only the pics so it's a light folder.
# ------------------------------------------------------------------------------
# get number of labeled folders
echo number of labeled folders \(ie 3 or 100000\): 
read n_models
# ------------------------------------------------------------------------------
echo test or train? 
read test_train
# ------------------------------------------------------------------------------
test_train_="model-$test_train"
# ------------------------------------------------------------------------------
mkdir ../data-set/$test_train_/
# ------------------------------------------------------------------------------
# loop through each label 
for ((j_=1;j_<=n_models;j_++))
do
  mv ../data-set/$test_train/$j_/model.png ../data-set/$test_train_/model$j_.png
done
# ------------------------------------------------------------------------------
