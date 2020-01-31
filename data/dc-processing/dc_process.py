import os
import pandas as pd
import numpy as np
# ------------------------------------------------------------------------------
# set directory path
project_  = input ("project name    : ")
data_name_= input ("data name       : ")
separator_= input ("separator       : ")
# ------------------------------------------------------------------------------
# project_   = "utah"
# data_name_ = "utah.txt"
# project_   = "erb-lawn"
# data_name_ = "erb-36.txt"
# project_   = "gowen"
# data_name_ = "bill_june15.txt"
# project_   = "bhrs"
# data_name_ = "bhrs32electrodes.txt"
# project_   = "groningen"
# data_name_ = "groningen_.txt"
# project_   = "groningen2"
# data_name_ = "groningen2_.txt"
# ------------------------------------------------------------------------------
path_ = "../raw/"+project_+"/dc-data/"
data_name_ = path_+data_name_
# ------------------------------------------------------------------------------
print('\nprocess er data!!')
print('   ...directly from Prosys (o_O)')
print('\n gonna do projec: ', project_)
# ------------------------------------------------------------------------------
# # remove extra tabs first because baby-python cant handle it ¬_¬
# os.system('cd ../raw/bhrs/dc-data/')
# os.system('cat bhrs32electrodes.txt  | tr -s " " > bhrs32electrodes-.txt')
# os.system('mv bhrs32electrodes-.txt bhrs32electrodes.txt')
# ------------------------------------------------------------------------------
# open file
# data columns are arranged in the following way:
# header = ["El-array","Spa.1","Spa.2","Spa.3","Spa.4","Rho","Dev.","M","Sp","Vp",
# "In","Spa.5","Spa.6","Spa.7","Spa.8"]
data = pd.read_csv(data_name_,sep=separator_)
# ------------------------------------------------------------------------------
# get all of the data!!
voltages = data["Vp"].values    # mV
currents = data["In"].values    # mA
std      = data["Dev."].values  
if 'Sp' in data.columns:
    self_pot = data["Sp"].values    # V
app_resi = data["Rho"].values   # Ohm.m
abmn = data[["Spa.1","Spa.2","Spa.3","Spa.4"]].values # indicies begining in 0
# ------------------------------------------------------------------------------
# change units
voltages = voltages*1e-3 # V
currents = currents*1e-3 # A
abmn = abmn+1            # indicies begining in 1
# ------------------------------------------------------------------------------
os.chdir(path_+"data-mat-raw/")
os.system('touch voltages.txt currents.txt std.txt self_pot.txt app_resi.txt abmn.txt')
# ------------------------------------------------------------------------------
# write data to disk
np.savetxt("voltages.txt", voltages)
np.savetxt("currents.txt", currents)
np.savetxt("std.txt", std)
np.savetxt("self_pot.txt", self_pot)
np.savetxt("app_resi.txt", app_resi)
np.savetxt("abmn.txt", abmn)
# ------------------------------------------------------------------------------
print('\n ok, done. data is in\n', path_+"data-mat-raw/")
# ------------------------------------------------------------------------------
