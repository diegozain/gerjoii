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
project_= input ("project name   : ") 
midi_s  = 2
midi_e  = 15
z_guide = 1
# ------------------------------------------------------------------------------
wdc_= input ("w, dc, or wdc? : ")
path_  = '../'+project_+'/output/'+wdc_+'/'
name_  = 'sigm_topo'
struct_=name_
# ------------------------------------------------------------------------------
maxi_s = -float('Inf')
mini_s =  float('Inf')
maxi_e = -float('Inf')
mini_e =  float('Inf')
# ------------------------------------------------------------------------------
# boreholes
B5=12.3;
A1=15.8;
B3=18.3;
B2=19.5;
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring_struct(path_,name_,struct_,'x',0,0)
z,_,_=fancy_figure.bring_struct(path_,name_,struct_,'z',0,0)
sigm,_,_=fancy_figure.bring_struct(path_,name_,struct_,'sigm',0,0)
_,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
if wdc_ != 'dc':
    epsi,_,_=fancy_figure.bring_struct(path_,'epsi_topo','epsi_topo','epsi',0,0)
    _,mini_e,maxi_e=fancy_figure.bring(path_,'epsi',mini_e,maxi_e)
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
# colop='c',
# colop=(0.5412,0.0824,0.9176),
colop='r',
symbol='--',holdon='on').plotter()
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
# sigm
fancy_figure(data=sigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,vmax=maxi_s,
colo='groundwater',
title='Recovered conductivity (mS/m)',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='topo-sigm-'+project_,
guarda_path=guarda_path,
guarda=120).pmatrix()
# ------------------------------------------------------------------------------
if wdc_ != 'dc':
    # boreholes for sig
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
    # guide-line
    fancy_figure(
    curve=np.ones(x.shape)*z_guide,x=x,
    # colop=(0.5412,0.0824,0.9176),
    colop='r',
    symbol='--',holdon='on').plotter()
    # epsi
    fancy_figure(data=epsi,
    x=x,y=z,extent=extents_,
    midi=midi_e,
    vmin=mini_e,vmax=maxi_e,
    colo='groundwater',
    title='Recovered permittivity ( )',
    xlabel="Length (m)",ylabel="Depth (m)",
    ax_accu="%.0f",
    fig_name='topo-epsi-'+project_,
    guarda_path=guarda_path,
    guarda=120).pmatrix()
# ------------------------------------------------------------------------------




