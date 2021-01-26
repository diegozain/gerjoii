import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
guarda_path = "pics/"
path_w = '../data/w/'
# ------------------------------------------------------------------------------
# bring x and z
x,_,_=fancy_figure.bring_struct(path_w,'parame_','parame_','x',0,0)
z,_,_=fancy_figure.bring_struct(path_w,'parame_','parame_','z',0,0)
# ------------------------------------------------------------------------------
x = np.squeeze(x)
z = np.squeeze(z)
x_full = x
z_full = z
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
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# bring receivers and sources -- gpr

sr_w_ = fancy_figure.bring_cell(path_w,'s_r_')
ns = sr_w_.shape[0]
for ishot in range(1,ns+1):
    rx_= sr_w_[ishot-1,1]
    sx_w = sr_w_[ishot-1,0][0][1]
    nrx= rx_.shape[0]
    rx_w = np.ones(nrx,dtype=int)
    for i_ in range(0,nrx):
        rx_w[i_] = rx_[i_][0]
    rx_w=x_full[rx_w-1]-x_push
    sx_w=x_full[sx_w-1]-x_push
    # --------------------------------------------------------------------------
    # receivers
    fancy_figure(
    curve=np.ones(rx_w.shape)*ishot,
    x=rx_w,
    colop='k',
    symbol='.',
    holdon='on'
    ).plotter()
    # source
    fancy_figure(
    curve=ishot,
    x=sx_w,
    colop='r',
    symbol='*',
    markersize=5,
    holdon='on'
    ).plotter()
# ------------------------------------------------------------------------------
# make pretty
fancy_figure(
curve=0,
x=-1,
colop='w',
holdon='on'
).plotter()
fancy_figure(
curve=ns+1,
x=rx_w[-1]+1,
colop='w',
title='Sources and Receivers GPR',
ylabel='Shot \#',
xlabel='Length (m)',
guarda=120,
guarda_path=guarda_path,
fig_name='srcs_recs_w'
).plotter()
# ------------------------------------------------------------------------------
