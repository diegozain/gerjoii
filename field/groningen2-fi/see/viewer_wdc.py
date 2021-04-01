import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
midi_e  = 18
midi_s  = 60
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
epsi,mini_e,maxi_e=fancy_figure.bring(path_,'epsi',mini_e,maxi_e)
sigm,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
project__= input ('compare with dc project name (just press enter if you dont care): ')
if project__ is not '':
    path_ = '../'+project__+'/output/dc/'
    _,mini_s,maxi_s=fancy_figure.bring(path_,'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
maxi_s=maxi_s*1e+3
mini_s=mini_s*1e+3
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
x_ = 5;    # m
x__= 34;   # m
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
epsi = epsi[z_:z__,x_:x__]
sigm = sigm[z_:z__,x_:x__]
# ------------------------------------------------------------------------------
sigm = 1e+3*sigm
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# epsi
fancy_figure(
data=epsi,
x=x,y=z,extent=extents_,
midi=midi_e,
title='Recovered permittivity ( )',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='eps-wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------
# sigm
fancy_figure(
data=sigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
title='Recovered conductivity (mS/m)',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='sig-wdc-'+project_,
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
data=epsi,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
xlabel="Length (m)",
midi=midi_e,
vmin=mini_e,
vmax=maxi_e,
title='Recovered permittivity ( )',
ylabel="Depth (m)",
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(
figsize=[9,6],
data=sigm,
ax_=ax2,
x=x,y=z,
extent=extents_,
ax_accu="%.0f",
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
colorbaron='on',holdon='on',colo_accu="%g",
title='Recovered conductivity (mS/m)',
ylabel="Depth (m)",
xlabel="Length (m)",
guarda=120,
guarda_path='pics/',
fig_name='wdc-'+project_).matrix()
# ------------------------------------------------------------------------------






