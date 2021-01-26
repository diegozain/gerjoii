import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
# 
# view the model
# 
# ------------------------------------------------------------------------------
n_models = 48
name_ = 'model'
colo  = 'ybwrk' # 'plasma'
guarda_path = "pics/"
# ------------------------------------------------------------------------------
# set directory & # of files
# ------------------------------------------------------------------------------
project_= input ("project name     : ")
# ------------------------------------------------------------------------------
path_   = '../' + project_ + '/output/'
path_w  = '../' + project_ + '/data-recovered/w/'
# ------------------------------------------------------------------------------
dpi     = 200
size    = [5,6]
# ------------------------------------------------------------------------------
#                       get max and min
# ------------------------------------------------------------------------------
epsi,mini_e,maxi_e = fancy_figure.bring(path_,'epsi',float('Inf'),-float('Inf'))
midi_e = 0.5*(maxi_e-mini_e) + mini_e
# ------------------------------------------------------------------------------
sigm,mini_s,maxi_s = fancy_figure.bring(path_,'sigm',float('Inf'),-float('Inf'))
midi_s = 0.5*(maxi_s-mini_s) + mini_s
# ------------------------------------------------------------------------------
mini_s = mini_s*1e+3
maxi_s = maxi_s*1e+3
midi_s = midi_s*1e+3
# ------------------------------------------------------------------------------
#                       get x and z
# ------------------------------------------------------------------------------
x,_,_ = fancy_figure.bring(path_,'x',0,0)
z,_,_ = fancy_figure.bring(path_,'z',0,0)
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
#                       get receivers
# ------------------------------------------------------------------------------
# bring receivers and sources -- gpr
sr_w_ =fancy_figure.bring_cell(path_w,'s_r_')
ishot = 1
rx_   = sr_w_[ishot-1,1]
sx_w  = sr_w_[ishot-1,0][0][1]
nrx   = rx_.shape[0]
rx_w  = np.ones(nrx,dtype=int)
for i_ in range(0,nrx):
    rx_w[i_] = rx_[i_][0]
rx_w=x[rx_w-1]
sx_w=x[sx_w-1]
# ------------------------------------------------------------------------------
# make receivers and sources -- er
rx_dc = np.arange(2,34,1,dtype=float)
# ------------------------------------------------------------------------------
# 
#                   pictures
# 
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,(ax1,ax2)=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# wave recs and source
fancy_figure(
    ax_=ax1,figsize=size,
    curve=-0.7,x=sx_w,
    colop='w',
    symbol='.',holdon='on'
    ).plotter()
fancy_figure(ax_=ax1,figsize=size,
    curve=0*np.ones(rx_w.shape),x=rx_w,
    colop='c',
    symbol='.',markersize=2,
    holdon='on'
    ).plotter()
fancy_figure(ax_=ax1,figsize=size,
    curve=0,x=sx_w,
    colop='r',markersize=10,
    symbol='*',holdon='on'
    ).plotter()
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(
    ax_=ax1,figsize=size,
    data=epsi,
    x=x,y=z,extent=extents_,
    # x_ticklabels='off',
    ax_accu="%.0f",
    xlabel="Length (m)",
    midi=midi_e,vmin=mini_e,vmax=maxi_e,
    title='Permittivity ( )',
    ylabel="Depth (m)",
    holdon='on',colo_accu="%g",
    colorbaron='on',
    colo=colo
    # no_frame='on'
    ).matrix()
# ------------------------------------------------------------------------------
# dc recs and source
fancy_figure(
    ax_=ax2,figsize=size,
    curve=-0.7,x=sx_w,
    colop='w',
    symbol='.',holdon='on'
    ).plotter()
fancy_figure(ax_=ax2,figsize=size,
    curve=0.1*np.ones(rx_dc.shape),x=rx_dc,
    colop=(0.6941,0.2039,0.9216),
    symbol='v',holdon='on'
    ).plotter()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(
    ax_=ax2,figsize=size,
    data=sigm*1e+3,
    x=x,y=z,extent=extents_,
    ax_accu="%.0f",
    midi=midi_s,vmin=mini_s,vmax=maxi_s,
    colorbaron='on',holdon='on',colo_accu="%g",
    title='Conductivity (mS/m)',
    ylabel="Depth (m)",
    xlabel="Length (m)",
    colo=colo,
    guarda_path=guarda_path,
    guarda=dpi,
    fig_name=name_+'_'+project_
    ).matrix()
# ------------------------------------------------------------------------------
plt_.close()
# ------------------------------------------------------------------------------
# !sips -g all tmp/line1.png
# ------------------------------------------------------------------------------
