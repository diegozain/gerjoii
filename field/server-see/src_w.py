import sys
sys.path.append('../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import numpy as np
import scipy.io as sio
# ------------------------------------------------------------------------------
size=[6,4]
guarda_path = "pics/"
dpi=120
# ------------------------------------------------------------------------------
src,_,_ = fancy_figure.bring_struct('','parame_','parame_','w.wvlets_',0,0)
t,_,_ = fancy_figure.bring_struct('','parame_','parame_','w.t',0,0)
# ------------------------------------------------------------------------------
src=src[:,0]
t=t*1e+9
# ------------------------------------------------------------------------------
# src
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
curve=src,
x=t,
symbol='-',
colop='k',
title='Source for shot \#1',
ylabel='Amplitude',
xlabel='Time (ns)',
margin=(0.03,0.03),
guarda_path=guarda_path,
guarda=dpi,
fig_name="src_wvlet").plotter()
# ------------------------------------------------------------------------------

