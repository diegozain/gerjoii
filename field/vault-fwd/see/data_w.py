import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
name_= input ("line (eg line1) : ")
# ------------------------------------------------------------------------------
path_ = '../'+project_+'/data-recovered/w/'
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
dpi = 120*1
# ------------------------------------------------------------------------------
# bring to memory (w)
# ------------------------------------------------------------------------------
midi  = 0
mini  = -5
maxi  = 5
struct_ = 'radargram'
# ------------------------------------------------------------------------------
rx,_,_     = fancy_figure.bring_struct(path_,name_,struct_,'r',0,0)
t,_,_      = fancy_figure.bring_struct(path_,name_,struct_,'t',0,0)
dr,_,_     = fancy_figure.bring_struct(path_,name_,struct_,'dr',0,0)
# ------------------------------------------------------------------------------
d,_,_      = fancy_figure.bring_struct(path_,name_,struct_,'d',0,0)
# ------------------------------------------------------------------------------
# delete tapered parts
nt,nr=d.shape
nt_cut=100
# ------------------------------------------------------------------------------
d = np.delete(d, slice(0, nt_cut), axis=0)
d = np.delete(d, slice(nt-2*nt_cut, nt-nt_cut), axis=0)
t = np.delete(t, slice(nt-2*nt_cut, nt), axis=0)
# ------------------------------------------------------------------------------
print('max ',d.max())
print('min ',d.min())
# ------------------------------------------------------------------------------
# set consantants for plotting
# ------------------------------------------------------------------------------
rx = rx[:,0]
nr = rx.size
t  = t*1e+9
nt = t.size
# ------------------------------------------------------------------------------
# john and dylan REALLY need to see the data matrix 
# broken up where the source is because they cant 
# visualize it by themselves. whatever.
# ------------------------------------------------------------------------------
# in matlab:
# [~,il]=max(diff(rx));
# no=(rx(il+1)-rx(il))/dr;
# no=uint32(no);
# d_=[d(:,1:il),zeros(nt,no),d(:,(il+1):end)];              
# rx=[rx(1:il); linspace(rx(il)+dr,rx(il+1)-dr,no).'  ; rx(il+1:end)  ];
# -
# np.full([nt, no], np.nan)
# ------------------------------------------------------------------------------
il = np.argmax(np.diff(rx))
if name_ != 'line1':
    no = (rx[il+1]-rx[il])/dr;
    no=no[0];no=no[0];
    no = no.astype(int)
    # data high synth
    d = np.concatenate((
    d[:,0:(il+1)],
    np.zeros((nt,no)),
    d[:,(il+1):]
    ),1)
    # receivers
    rx = np.concatenate((
    rx[0:(il+1)],
    np.linspace(rx[il]+dr,rx[il+1]-dr,no).transpose().squeeze(),
    rx[il+1:]
    ),0)
# -----------------
extent_ = [rx[0],rx[-1],t[-1],t[0]]
print(d.shape)
# ------------------------------------------------------------------------------
#                       data w
# ------------------------------------------------------------------------------
aspect_ = 'auto'#0.16 # larger number --> y axis is longer
size=[9.6*0.5,9.6*0.5]
# ------------------------------------------------------------------------------
fancy_figure(aspect=aspect_,figsize=size,
data=d,extent=extent_,
x=rx,y=t,
# y_ticklabels='off',x_ticklabels='off',
midi=midi,vmin=mini,vmax=maxi,
# colo='Greys',
title=name_,xlabel='Receivers (m)',ylabel='Time (ns)',
guarda_path=guarda_path,
guarda=dpi,fig_name=name_+'_'+project_).matrix()
# -------------------------
