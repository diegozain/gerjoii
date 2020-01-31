import sys
sys.path.append('../../../../graphics_py/')
# ------------------------------------------------------------------------------
from fancy_figure import fancy_figure
import numpy as np
import glob
# -----------------------------------------------------
file_ = glob.glob('line*.mat')
file_ = file_[0]
file_ = file_[0:5]
# -----------------------------------------------------
# names
# -----------------------------------------------------
struct_ = 'radargram'
# -----------------------------------------------------
# bring to memory
# -----------------------------------------------------
d_obse,mini_obse,maxi_obse = fancy_figure.bring_struct('',file_,struct_,'d',0,0)
d_obse_src,_,_ = fancy_figure.bring_struct('',file_,struct_,'Jy',0,0)
rx,_,_ = fancy_figure.bring_struct('',file_,struct_,'r',0,0)
t,_,_ = fancy_figure.bring_struct('',file_,struct_,'t',0,0)
dr,_,_ = fancy_figure.bring_struct('',file_,struct_,'dr',0,0)
# -----------------------------------------------------
print('max_obse = ',maxi_obse)
print('mini_obse= ',mini_obse)
mini_obse = 0.1*mini_obse
maxi_obse = 0.1*maxi_obse
t = t*1e+9;
# -----------------------------------------------------
midi = 0
# -----------------------------------------------------
# set consantants for plotting
# -----------------------------------------------------
# extent_ = [0,1,0,1]
rx = rx[:,0]
nr = rx.size
nt = t.size
# -----------------
extent_ = [rx[0],rx[-1],t[-1],t[0]]
aspect = 0.5 # larger number --> y axis is longer
size=[9.6*0.5,9.6*0.5]
# -----------------------------------------------------
# data w
# -----------------------------------------------------
fancy_figure(data=d_obse,extent=extent_,
x=rx,y=t,
aspect='auto',figsize=size,
# y_ticklabels='off',x_ticklabels='off',
midi=midi,vmin=mini_obse,vmax=maxi_obse,
title="Data GPR",xlabel='Receivers (m)',ylabel='Time (ns)',
guarda_path='pics/',
guarda=120).matrix()
# -----------------------------------------------------
# -----------------------------------------------------