import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
midi_e  = 7
midi_s  = 2
# ------------------------------------------------------------------------------
path_ = '../'+project_+'/output/wdc/'
# ------------------------------------------------------------------------------
maxi_e  = 9
mini_e  = 4
maxi_s  = 5*1e-3
mini_s  = 1*1e-3
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring(path_,'x',0,0)
z,_,_=fancy_figure.bring(path_,'z',0,0)
epsi,mini_e,maxi_e=fancy_figure.bring(path_,'epsi',mini_e,maxi_e)
sigm,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
maxi_s = maxi_s*1e+3
mini_s = mini_s*1e+3
# ------------------------------------------------------------------------------
print('max eps ',maxi_e)
print('min eps ',mini_e)
print('max sig ',maxi_s)
print('min sig ',mini_s)
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
# ------------------------------------------------------------------------------
box_ix = [552-1,610-1,610-1,552-1,552-1]
box_iz = [88-1,88-1,146-1,146-1,88-1]
reflect_ix = [1-1,1160-1]
reflect_iz = [204-1,204-1]
# ------------------------------------------------------------------------------
sigm = 1e+3*sigm
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,(ax1,ax2)=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# epsi
fancy_figure(ax_=ax1,data=epsi,
x=x,y=z,extent=extents_,
midi=midi_e,
vmin=mini_e,vmax=maxi_e,
title='Recovered permittivity ( )',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
holdon='on').matrix()
# ------------------------------------------------------------------------------
# sigm
fancy_figure(ax_=ax2,data=sigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,vmax=maxi_s,
title='Recovered conductivity (mS/m)',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------







