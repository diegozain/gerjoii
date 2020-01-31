from fancy_figure import fancy_figure
import numpy as np
import glob
# -----------------------------------------------------
file_ = glob.glob('rhos.mat')
file__= glob.glob('obs_rhos.mat')
file_ = file_[0]
file_ = file_[0:4]
file__ = file__[0]
file__ = file__[0:8]
# -----------------------------------------------------
# bring to memory
# -----------------------------------------------------
d_reco,_,_ = fancy_figure.bring('',file_,0,0)
d_obse,_,_ = fancy_figure.bring('',file__,0,0)
# -----------------------------------------------------
# set consantants for plotting
# -----------------------------------------------------
size=[9.6*0.5,9.6*0.5] # tweak here to fit plot to bigger plot
# -------------------------
fancy_figure(figsize=size,#
curve=d_reco,x=d_obse,#
symbol='.',#
margin=(0.05,0.02),#
colop=((0,0,0)),#
holdon='on').plotter()
# -------------------------
fancy_figure(figsize=size,#
curve=d_obse,x=d_obse,#
symbol='-',#
margin=(0.05,0.02),#
colop=((0.4,0.4,0.4)),#
title="Apparent resistivity",#
xlabel="Observed (Ohm.m)",#
ylabel="Recovered (Ohm.m)",
guarda=120).plotter()
# -------------------------
plt_.show()
