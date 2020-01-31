import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
path_true = "../image2mat/nature-synth/mat-file/"
guarda_path="pics/"
# ------------------------------------------------------------------------------
path_ini = "../image2mat/nature-synth/initial-guess/"
epsi_ini = 'epsi_init'
sigm_ini = 'sigm_init'
# ------------------------------------------------------------------------------
title_e = "True permittivity ( )"
title_s = "True conductivity (mS/m)"
midi_e  = 3.5
midi_s  = 1
figsize = [6.4*1.1,6.4*0.8]
# ------------------------------------------------------------------------------
maxi_e = -float('Inf')
mini_e =  float('Inf')
maxi_s = -float('Inf')
mini_s =  float('Inf')
# ------------------------------------------------------------------------------
# bring x and z
x,_,_=fancy_figure.bring(path_true,'x',0,0)
z,_,_=fancy_figure.bring(path_true,'z',0,0)
x = x[0,:]
z = z[0,:]
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# bring true
epsi,mini_e,maxi_e=fancy_figure.bring(path_true,'epsi',mini_e,maxi_e)
sigm,mini_s,maxi_s=fancy_figure.bring(path_true,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
# bring initial
epsi_ini,mini_e,maxi_e=fancy_figure.bring(path_ini,epsi_ini,mini_e,maxi_e,name__='epsi')
sigm_ini,mini_s,maxi_s=fancy_figure.bring(path_ini,sigm_ini,mini_s,maxi_s,name__='sigm')
# ------------------------------------------------------------------------------
sigm=sigm*1e+3
mini_s=mini_s*1e+3
maxi_s=maxi_s*1e+3
# ------------------------------------------------------------------------------
sigm_ini=sigm_ini*1e+3
# ------------------------------------------------------------------------------
# mini_s=1
# maxi_s=5
# mini_e=4
# maxi_e=9
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,(ax1,ax2)=plt_.subplots(1,2)
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(ax_=ax1,figsize=figsize,
data=epsi,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
xlabel="Length (m)",
midi=midi_e,vmin=mini_e,vmax=maxi_e,
title=title_e,ylabel="Width (m)",
colo='cafe',
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(ax_=ax2,figsize=figsize,
data=sigm,
x=x,y=z,extent=extents_,
ax_accu="%.0f",
midi=midi_s,vmin=mini_s,vmax=maxi_s,
colorbaron='on',holdon='on',colo_accu="%g",
title=title_s,ylabel="Width (m)",
colo='cafe',
xlabel="Length (m)",
# super_title='Tree trunk',
guarda=120,
guarda_path=guarda_path,fig_name="true").matrix()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,(ax1,ax2)=plt_.subplots(1,2)
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(ax_=ax1,figsize=figsize,
data=epsi_ini,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
xlabel="Length (m)",
midi=midi_e,vmin=mini_e,vmax=maxi_e,
title="Initial permittivity ( )",
ylabel="Width (m)",
colo='cafe',
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(ax_=ax2,figsize=figsize,
data=sigm_ini,
x=x,y=z,extent=extents_,
ax_accu="%.0f",
midi=midi_s,vmin=mini_s,vmax=maxi_s,
colorbaron='on',holdon='on',colo_accu="%g",
title="Initial conductivity (mS/m)",
ylabel="Width (m)",
xlabel="Length (m)",
colo='cafe',
guarda=120,
guarda_path=guarda_path,fig_name="initial").matrix()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------
