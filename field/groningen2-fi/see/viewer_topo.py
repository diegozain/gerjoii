import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
midi_s  = 5
z_guide = 6
# ------------------------------------------------------------------------------
path_  = '../'+project_+'/output/dc/'
name_  = 'sigm_topo'
struct_=name_
# ------------------------------------------------------------------------------
maxi_s = -float('Inf')
mini_s =  float('Inf')
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring_struct(path_,name_,struct_,'x',0,0)
z,_,_=fancy_figure.bring_struct(path_,name_,struct_,'z',0,0)
sigm,_,_=fancy_figure.bring_struct(path_,name_,struct_,'sigm',0,0)
_,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
maxi_s = maxi_s*1e+3
mini_s = mini_s*1e+3
# ------------------------------------------------------------------------------
print('max sig ',maxi_s)
print('min sig ',mini_s)
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
# ------------------------------------------------------------------------------
sigm = 1e+3*sigm
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# guide-line
fancy_figure(
curve=np.ones(x.shape)*z_guide,x=x,
colop='c',
symbol='--',holdon='on').plotter()
# ------------------------------------------------------------------------------
# sigm
fancy_figure(data=sigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,vmax=maxi_s,
title='Recovered DC conductivity (mS/m)',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='dc-topo-'+project_,
guarda_path=guarda_path,
guarda=120).pmatrix()
# ------------------------------------------------------------------------------







