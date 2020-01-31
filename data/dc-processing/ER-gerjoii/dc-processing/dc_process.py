import os
import pandas as pd
import numpy as np
# ------------------------------------------------------------------------------
# set directory path
project_ = "geothermal"
data_name_ = "data-example.txt"
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
data = pd.read_csv(data_name_,sep=" ")
# ------------------------------------------------------------------------------
# get all of the data!!
voltages = data["Vp"].values    # mV
currents = data["In"].values    # mA
std      = data["Dev."].values  
self_pot = data["Sp"].values    # V
app_resi = data["Rho"].values   # Ohm.m
abmn = data[["Spa.1","Spa.2","Spa.3","Spa.4"]].values # indicies begining in 0
# ------------------------------------------------------------------------------
# change units
voltages = voltages*1e-3 # V
currents = currents*1e-3 # A
abmn = abmn+1            # indicies begining in 1
# ------------------------------------------------------------------------------
# write data to disk
np.savetxt(path_+"data-mat-raw/"+"voltages.txt", voltages)
np.savetxt(path_+"data-mat-raw/"+"currents.txt", currents)
np.savetxt(path_+"data-mat-raw/"+"std.txt", std)
np.savetxt(path_+"data-mat-raw/"+"self_pot.txt", self_pot)
np.savetxt(path_+"data-mat-raw/"+"app_resi.txt", app_resi)
np.savetxt(path_+"data-mat-raw/"+"abmn.txt", abmn)
# ------------------------------------------------------------------------------
print('\n ok, done. data is in\n', path_+"data-mat-raw/")
