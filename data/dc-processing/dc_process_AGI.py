import os
import pandas as pd
import numpy as np
# ------------------------------------------------------------------------------
# set directory path
project_  = input ("project name    : ")
data_name_= input ("data name       : ")
separator_= input ("separator       : ")
# ------------------------------------------------------------------------------
# project_   = "florida-dylan"
# data_name_ = "florida-dylan.txt"
# ------------------------------------------------------------------------------
path_ = "../raw/"+project_+"/dc-data/"
data_name_ = path_+data_name_
# ------------------------------------------------------------------------------
print('\nprocess er data!!')
print('   ...directly from AGI (o_O)')
print('\n gonna do projec: ', project_)
# ------------------------------------------------------------------------------
# # remove extra tabs first because baby-python cant handle it ¬_¬
# os.chdir(path_)
# os.system('cat florida-dylan.txt  | tr -s " " > florida-dylan-.txt')
# os.system('mv florida-dylan-.txt florida-dylan.txt')
# ------------------------------------------------------------------------------
# open file
# data columns are arranged in the following way:
# 
# data record number, USER, date (YYYYMMDD), time (hh:mm:ss), V/I, % error in tenths of percent, output current in mA, apparent resistivity in Ωm or Ωft, command file identifier, X-coordinate for the A-electrode, Y-coordinate for the A-electrode, Z-coordinate for the A-electrode, X-coordinate for the B-electrode, Y-coordinate for the B-electrode, Z-coordinate for the B-electrode, X-coordinate for the M-electrode, Y-coordinate for the M-electrode, Z-coordinate for the M-electrode, X-coordinate for the N-electrode, Y-coordinate for the N-electrode, Z-coordinate for the N-electrode, IP:, IP time slot in msec., IP time constant, IP reading in sec for the first time slot, IP reading in sec for the second time slot, IP reading in sec for the third time slot, IP reading in sec for the forth time slot, IP reading in sec for the fifth time slot, IP reading in sec for the sixth time slot, total IP reading in sec, Cmd line number, Transmitter volt code, # of measurement cycles, Measurement time used, Gain setting, Channel used
# 
# for more info go to 
# https://www.agiusa.com/what-are-column-labels-supersting-stg-data-file
# 
data = pd.read_csv(data_name_,sep=separator_)
# ------------------------------------------------------------------------------
# first three rows are boring:
# 
# Advanced Geosciences, Inc. SuperSting R8-IP Resistivity meter. S/N: SS0205071 Type: 3D
# Software version: 01.23.73E Survey period: 20190419 Records: 4113
# Unit: meter
# 
# data = data.iloc[3:,]
# ------------------------------------------------------------------------------
# get all of the data!!
voltages = data.iloc[:,4]    # V/I
currents = data.iloc[:,6]    # mA
std      = data.iloc[:,5]    # tenths of percent
app_resi = data.iloc[:,7]    # ?
abmn = data.iloc[:,[9,12,15,18]]
# ------------------------------------------------------------------------------
# # change units
# voltages = voltages*1e-3 # V
currents = currents*1e-3 # A
# std = std/10 # %
# ------------------------------------------------------------------------------
os.chdir(path_+"data-mat-raw/")
os.system('touch voltages.txt currents.txt std.txt app_resi.txt abmn.txt')
# ------------------------------------------------------------------------------
# write data to disk
np.savetxt("voltages.txt", voltages)
np.savetxt("currents.txt", currents)
np.savetxt("std.txt", std)
np.savetxt("app_resi.txt", app_resi)
np.savetxt("abmn.txt", abmn)
# ------------------------------------------------------------------------------
print('\n ok, done. data is in\n', path_+"data-mat-raw/")
# ------------------------------------------------------------------------------
