import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
wdc_w   = input ("w or wdc? : ") 
midi_e  = 7
midi_s  = 2
# ------------------------------------------------------------------------------
path_     = '../' + project_ + '/output/' + wdc_w + '/'
path_true = '../image2mat/nature-synth/mat-file/'
path_init = '../image2mat/nature-synth/initial-guess/'
# ------------------------------------------------------------------------------
guarda_path = "pics/"
# ------------------------------------------------------------------------------
# boreholes
b1_ix = 291-1 # 5 meters
b2_ix = 581-1 # 5 meters
b3_ix = 871-1 # 5 meters
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring(path_,'x',0,0)
z,_,_=fancy_figure.bring(path_,'z',0,0)
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
# ------------------------------------------------------------------------------
maxi_e = -float('Inf')
mini_e =  float('Inf')
maxi_s = -float('Inf')
mini_s =  float('Inf')
# ------------------------------------------------------------------------------
# bring recovered
epsi_r,mini_e,maxi_e=fancy_figure.bring(path_,'epsi',mini_e,maxi_e)
sigm_r,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
# bring true
epsi_t,mini_e,maxi_e = fancy_figure.bring(path_true,'epsi',mini_e,maxi_e)
sigm_t,mini_s,maxi_s = fancy_figure.bring(path_true,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
# bring init
epsi_i,mini_e,maxi_e = fancy_figure.bring(path_init,'epsi_smooth',mini_e,maxi_e,name__='epsi')
sigm_i,mini_s,maxi_s = fancy_figure.bring(path_init,'sigm_smooth5',mini_s,maxi_s,name__='sigm')
# ------------------------------------------------------------------------------
mini_s = mini_s*1e+3
maxi_s = maxi_s*1e+3
sigm_t = sigm_t*1e+3
sigm_i = sigm_i*1e+3
sigm_r = sigm_r*1e+3
# ------------------------------------------------------------------------------
# boreholes true
b1_z_t = epsi_t[:,b1_ix]
b2_z_t = epsi_t[:,b2_ix]
b3_z_t = epsi_t[:,b3_ix]
# boreholes init
b1_z_i = epsi_i[:,b1_ix]
b2_z_i = epsi_i[:,b2_ix]
b3_z_i = epsi_i[:,b3_ix]
# boreholes reco
b1_z_r = epsi_r[:,b1_ix]
b2_z_r = epsi_r[:,b2_ix]
b3_z_r = epsi_r[:,b3_ix]
# ------------------------------------------------------------------------------
dpi=120
size_ = [6.41*1,6.41*0.8]
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
# boreholes
# ------------------------------------------------------------------------------
fig,(ax1,ax2,ax3)=plt_.subplots(1,3)
xlim=[mini_e-mini_e*0.5,maxi_e+maxi_e*0.1]
# ------------------------------------------------------------------------------
# borehole 1
fancy_figure(ax_=ax1,figsize=size_,
curve=z,x=b1_z_t,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 1
fancy_figure(ax_=ax1,figsize=size_,
curve=z,x=b1_z_i,ydir = 'reverse',
colop='b',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 1
fancy_figure(ax_=ax1,figsize=size_,
curve=z,x=b1_z_r,ydir = 'reverse',
colop='r',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# ------------------------------------------------------------------------------
# borehole 2
fancy_figure(ax_=ax2,figsize=size_,
curve=z,x=b2_z_t,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 2
fancy_figure(ax_=ax2,figsize=size_,
curve=z,x=b2_z_i,ydir = 'reverse',
colop='b',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 2
fancy_figure(ax_=ax2,figsize=size_,
curve=z,x=b2_z_r,ydir = 'reverse',
colop='r',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# ------------------------------------------------------------------------------
# borehole 3
fancy_figure(ax_=ax3,figsize=size_,
curve=z,x=b3_z_t,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 3
fancy_figure(ax_=ax3,figsize=size_,
curve=z,x=b3_z_i,ydir = 'reverse',
colop='b',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 3
fancy_figure(ax_=ax3,figsize=size_,
curve=z,x=b3_z_r,ydir = 'reverse',
colop='r',symbol='-',xlim=[xlim[0],7.5],
ylabel='Depth (m)',
guarda=dpi,holdon='on',
super_title='Permittivity ( )',
guarda_path=guarda_path,fig_name='boreholes-permis-'+project_).plotter()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------
# 
# condus
# 
# ------------------------------------------------------------------------------
plt_.close()
# ------------------------------------------------------------------------------
# boreholes true
b1_z_t = sigm_t[:,b1_ix]
b2_z_t = sigm_t[:,b2_ix]
b3_z_t = sigm_t[:,b3_ix]
# boreholes init
b1_z_i = sigm_i[:,b1_ix]
b2_z_i = sigm_i[:,b2_ix]
b3_z_i = sigm_i[:,b3_ix]
# boreholes reco
b1_z_r = sigm_r[:,b1_ix]
b2_z_r = sigm_r[:,b2_ix]
b3_z_r = sigm_r[:,b3_ix]
# ------------------------------------------------------------------------------
# boreholes
# ------------------------------------------------------------------------------
fig,(ax1,ax2,ax3)=plt_.subplots(1,3)
xlim=[mini_s-mini_s*0.1,maxi_s+maxi_s*0.1]
# ------------------------------------------------------------------------------
# borehole 1
fancy_figure(ax_=ax1,figsize=size_,
curve=z,x=b1_z_t,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 1
fancy_figure(ax_=ax1,figsize=size_,
curve=z,x=b1_z_i,ydir = 'reverse',
colop='b',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 1
fancy_figure(ax_=ax1,figsize=size_,
curve=z,x=b1_z_r,ydir = 'reverse',
colop='r',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# ------------------------------------------------------------------------------
# borehole 2
fancy_figure(ax_=ax2,figsize=size_,
curve=z,x=b2_z_t,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 2
fancy_figure(ax_=ax2,figsize=size_,
curve=z,x=b2_z_i,ydir = 'reverse',
colop='b',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 2
fancy_figure(ax_=ax2,figsize=size_,
curve=z,x=b2_z_r,ydir = 'reverse',
colop='r',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# ------------------------------------------------------------------------------
# borehole 3
fancy_figure(ax_=ax3,figsize=size_,
curve=z,x=b3_z_t,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 3
fancy_figure(ax_=ax3,figsize=size_,
curve=z,x=b3_z_i,ydir = 'reverse',
colop='b',symbol='-',xlim=xlim,
ylabel='Depth (m)',
holdon='on').plotter()
# borehole 3
fancy_figure(ax_=ax3,figsize=size_,
curve=z,x=b3_z_r,ydir = 'reverse',
colop='r',symbol='-',xlim=[xlim[0],2.5],
ylabel='Depth (m)',
guarda=dpi,holdon='on',
super_title='Conductivity (mS/m)',
guarda_path=guarda_path,fig_name='boreholes-condus-'+project_).plotter()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------







