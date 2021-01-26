import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
midi_e  = 0
midi_s  = 0
# ------------------------------------------------------------------------------
path_ = '../'+project_+'/output/wdc/'
# ------------------------------------------------------------------------------
maxi_e  = -float('Inf')
mini_e  =  float('Inf')
maxi_s  = -float('Inf')
mini_s  =  float('Inf')
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring(path_,'x',0,0)
z,_,_=fancy_figure.bring(path_,'z',0,0)
depsi,mini_e,maxi_e=fancy_figure.bring(path_,'depsi',mini_e,maxi_e)
dsigm,mini_s,maxi_s=fancy_figure.bring(path_,'dsigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
dsigm_w,_,_=fancy_figure.bring(path_,'dsigm_w',mini_s,maxi_s)
dsigm_dc,_,_=fancy_figure.bring(path_,'dsigm_dc',mini_s,maxi_s)
# ------------------------------------------------------------------------------
print('max eps ',maxi_e)
print('min eps ',mini_e)
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
depsi = depsi[z_:z__,x_:x__]
dsigm = dsigm[z_:z__,x_:x__]
# ------------------------------------------------------------------------------
dsigm_w = dsigm_w[z_:z__,x_:x__]
dsigm_dc = dsigm_dc[z_:z__,x_:x__]
# ------------------------------------------------------------------------------
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# depsi
fancy_figure(
data=depsi,
x=x,y=z,extent=extents_,
midi=midi_e,
colo='groundwater',
title='Permittivity update',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='deps-wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------
# dsigm
fancy_figure(
data=dsigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
colo='groundwater',
title='Conductivity update',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='dsig-wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,(ax1,ax2)=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(
ax_=ax1,
figsize=[9,6],
data=depsi,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
midi=midi_e,
vmin=mini_e,
vmax=maxi_e,
colo='groundwater',
title='Permittivity update',
xlabel="Length (m)",
ylabel="Depth (m)",
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(
figsize=[9,6],
data=dsigm,
ax_=ax2,
x=x,y=z,
extent=extents_,
ax_accu="%.0f",
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
colorbaron='on',holdon='on',colo_accu="%g",
colo='groundwater',
title='Conductivity update',
ylabel="Depth (m)",
xlabel="Length (m)",
guarda=120,
guarda_path='pics/',
fig_name='wdc-updates-'+project_).matrix()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,(ax1,ax2)=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(
ax_=ax1,
figsize=[9,6],
data=dsigm_w,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
midi=midi_e,
colo='groundwater',
title='GPR conductivity update',
xlabel="Length (m)",
ylabel="Depth (m)",
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(
figsize=[9,6],
data=dsigm_dc,
ax_=ax2,
x=x,y=z,
extent=extents_,
ax_accu="%.0f",
midi=midi_s,
colorbaron='on',holdon='on',colo_accu="%g",
colo='groundwater',
title='ER conductivity update',
ylabel="Depth (m)",
xlabel="Length (m)",
guarda=120,
guarda_path='pics/',
fig_name='wdc-dsigs-'+project_).matrix()
# ------------------------------------------------------------------------------







