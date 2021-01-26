import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name : ") 
midi_e  = 15
midi_v  = 0.12
midi_s  = 2
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
epsi = epsi[z_:z__,x_:x__]
sigm = sigm[z_:z__,x_:x__]
# ------------------------------------------------------------------------------
# boreholes
B5=12.3;
A1=15.8;
B3=18.3;
B2=19.5;

m=0.01933429
# ------------------------------------------------------------------------------
velo = 0.29/np.sqrt(epsi)
# ------------------------------------------------------------------------------
sigm = 1e+3*sigm
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# 
# epsi & sigm separate 
# 
# ------------------------------------------------------------------------------
# boreholes for vel
# ------------------------------------------------------------------------------
fancy_figure(
curve=z,x=B5*np.ones(z.shape),
colop='k',
symbol='-',holdon='on'
).plotter()
fancy_figure(
curve=z,x=A1*np.ones(z.shape),
colop='k',
symbol='-',holdon='on'
).plotter()
fancy_figure(
curve=z,x=B2*np.ones(z.shape),
colop='k',
symbol='-',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# guide-line
plt_=fancy_figure(
curve=x*m-m+1,x=x,
colop='k',
symbol='--',holdon='on').plotter()
# ------------------------------------------------------------------------------
# vel
fancy_figure(
data=velo,
x=x,y=z,extent=extents_,
midi=midi_v,
#colo='groundwater',
title='Recovered velocity (m/ns)',
xlabel="Length (m)",ylabel="Depth (m)",
colo='johns',
ax_accu="%.0f",
fig_name='vel-wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------
# boreholes for eps
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
# epsi
fancy_figure(
data=epsi,
x=x,y=z,extent=extents_,
midi=midi_e,
colo='groundwater',
title='Recovered permittivity ( )',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='eps-wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
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
fancy_figure(
data=sigm,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
colo='groundwater',
title='Recovered conductivity (mS/m)',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
fig_name='sig-wdc-'+project_,
guarda_path='pics/',
guarda=120).matrix()
# ------------------------------------------------------------------------------
# 
# epsi & sigm together
# 
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,(ax1,ax2)=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# boreholes for eps
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax1,
curve=z,x=B5*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax1,
curve=z,x=A1*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax1,
curve=z,x=B2*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# guide-line
plt_=fancy_figure(
ax_=ax1,
curve=x*m-m+1,x=x,
colop='r',
symbol='--',holdon='on'
).plotter()
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
colo='groundwater',
title='Recovered permittivity ( )',
ylabel="Depth (m)",
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# boreholes for sig
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax2,
curve=z,x=B5*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax2,
curve=z,x=A1*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax2,
curve=z,x=B2*np.ones(z.shape),
colop='r',
symbol='-',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# guide-line
plt_=fancy_figure(
ax_=ax2,
curve=x*m-m+1,x=x,
colop='r',
symbol='--',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(
ax_=ax2,
figsize=[9,6],
data=sigm,
x=x,y=z,
extent=extents_,
ax_accu="%.0f",
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
colorbaron='on',holdon='on',colo_accu="%g",
colo='groundwater',
title='Recovered conductivity (mS/m)',
ylabel="Depth (m)",
xlabel="Length (m)",
guarda=120,
guarda_path='pics/',
fig_name='wdc-'+project_).matrix()
# ------------------------------------------------------------------------------







