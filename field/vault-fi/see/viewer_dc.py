import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
midi_s  = 2
# ------------------------------------------------------------------------------
path_ = '../'+project_+'/output/dc/'
# ------------------------------------------------------------------------------
maxi_s = -float('Inf')
mini_s =  float('Inf')
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring(path_,'x',0,0)
z,_,_=fancy_figure.bring(path_,'z',0,0)
sigm,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
maxi_s = maxi_s*1e+3
mini_s = mini_s*1e+3
# ------------------------------------------------------------------------------
print('max sig ',maxi_s)
print('min sig ',mini_s)
# ------------------------------------------------------------------------------
x = np.squeeze(x)
z = np.squeeze(z)
# ------------------------------------------------------------------------------
x_push = 5 # m
x_ = 6;    # m
x__= 41;   # m
z_ = 0;    # m
z__= 8;    # m
# ------------------------------------------------------------------------------
x_  = (np.abs(x - x_)).argmin()
x__ = (np.abs(x - x__)).argmin()+1
z_  = (np.abs(z - z_)).argmin()
z__ = (np.abs(z - z__)).argmin()+1
# ------------------------------------------------------------------------------
x = x[x_:x__]-x_push
z = z[z_:z__]
sigm = sigm[z_:z__,x_:x__]
# ------------------------------------------------------------------------------
sigm = 1e+3*sigm
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# boreholes
B5=12.3;
A1=15.8;
B3=18.3;
B2=19.5;

m=0.01933429
# ------------------------------------------------------------------------------
# boreholes for sig
# ------------------------------------------------------------------------------
fancy_figure(
curve=z,x=B5*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
fancy_figure(
curve=z,x=A1*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
fancy_figure(
curve=z,x=B2*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# guide-line
plt_=fancy_figure(
curve=x*m-m+1,x=x,
colop='r',
symbol='--',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# sigm
fancy_figure(data=sigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,vmax=maxi_s,
colo='groundwater',
title='Recovered ER conductivity (mS/m)',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='dc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------







