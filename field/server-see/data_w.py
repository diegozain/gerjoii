import sys
sys.path.append('../../../../graphics_py/')
# ------------------------------------------------------------------------------
from fancy_figure import fancy_figure
import numpy as np
import glob
# -----------------------------------------------------
file__= glob.glob('obs_line*.mat')
file__ = file__[0]
file__ = file__[0:9]
# -----------------------------------------------------
# names
# -----------------------------------------------------
struct_ = 'radargram'
guarda_path='pics/'
# -----------------------------------------------------
# bring to memory
# -----------------------------------------------------
d_obse,mini_obse,maxi_obse = fancy_figure.bring_struct('',file__,struct_,'d',0,0)
rx,_,_ = fancy_figure.bring_struct('',file__,struct_,'r',0,0)
t,_,_ = fancy_figure.bring_struct('',file__,struct_,'t',0,0)
dr,_,_ = fancy_figure.bring_struct('',file__,struct_,'dr',0,0)
# -----------------------------------------------------
mini_obse = 0.015*mini_obse
maxi_obse = 0.015*maxi_obse
t = t*1e+9
# -----------------------------------------------------
print('max_obse = ',maxi_obse)
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
size=[6,6]
# -----------------------------------------------------
# data w
# -----------------------------------------------------
plt_=fancy_figure(data=d_obse,extent=extent_,
x=rx,y=t,
aspect='auto',figsize=size,
# y_ticklabels='off',#x_ticklabels='off',
midi=midi,vmin=mini_obse,vmax=maxi_obse,
title="Observed GPR",xlabel='Receivers (m)',ylabel='Time (ns)',
holdon='on',
guarda_path=guarda_path,
guarda=120).matrix()
# -----------------------------------------------------
plt_.show()
# -----------------------------------------------------
