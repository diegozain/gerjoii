import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
name_= input ("line (eg line1) : ")
reco_obs= input ("recovered or observed: ")
# ------------------------------------------------------------------------------
if (reco_obs == 'observed'):
    path_ = '../'+project_+'/data-synth/w/'
elif (reco_obs == 'recovered'):
    path_ = '../'+project_+'/data-recovered/w/'
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
dpi = 120*1
size=[5,5]
# percentage of max amplitude to clip for plotting
prct  = 0.1
midi  = 0
# ------------------------------------------------------------------------------
# bring to memory (w)
# ------------------------------------------------------------------------------
struct_ = 'radargram'
# ------------------------------------------------------------------------------
rx,_,_     = fancy_figure.bring_struct(path_,name_,struct_,'r',0,0)
t,_,_      = fancy_figure.bring_struct(path_,name_,struct_,'t',0,0)
dr,_,_     = fancy_figure.bring_struct(path_,name_,struct_,'dr',0,0)
# ------------------------------------------------------------------------------
d,_,_ = fancy_figure.bring_struct(path_,name_,struct_,'d',0,0)
# ------------------------------------------------------------------------------
# delete tapered parts
nt,nr=d.shape
nt_cut=1
# ------------------------------------------------------------------------------
d = np.delete(d, slice(0, nt_cut), axis=0)
d = np.delete(d, slice(nt-2*nt_cut, nt-nt_cut), axis=0)
t = np.delete(t, slice(nt-2*nt_cut, nt), axis=0)
# ------------------------------------------------------------------------------
print('max ',d.max())
print('min ',d.min())

mini  = -d.max()*prct
maxi  =  d.max()*prct
# ------------------------------------------------------------------------------
# set consantants for plotting
# ------------------------------------------------------------------------------
# extent_ = [0,1,0,1]
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
il = np.argmax(np.diff(rx))
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
# ------------------------------------------------------------------------------
extent_ = np.array([rx[0],rx[-1],t[-1],t[0]],dtype=float)
# ------------------------------------------------------------------------------
#                       data w
# ------------------------------------------------------------------------------
aspect_ = 'auto'#0.16 # larger number --> y axis is longer
# ------------------------------------------------------------------------------
fancy_figure(
aspect=aspect_,
figsize=size,
data=d,
extent=extent_,
x=rx,y=t,
# y_ticklabels='off',x_ticklabels='off',
midi=midi,
vmin=mini,
vmax=maxi,
# colo='Greys',
title=name_+' '+reco_obs,xlabel='Receivers (m)',ylabel='Time (ns)',
guarda_path=guarda_path,
guarda=dpi,fig_name=name_+'_'+project_+'_'+reco_obs
).matrix()
# -------------------------
