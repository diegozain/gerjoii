import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
import os
# ------------------------------------------------------------------------------
project_= input("project name (for colormap): ")  
guarda_path = "pics/"
path_= ["../"+project_+"/output/wdc/"]
path_param = "../data/w/"
path_init = "../data/initial-guess/"
print(os.listdir(path_init))
epsi_name= input("name for initial epsi (no .mat) : ") 
sigm_name= input("name for initial sigm (no .mat) : ")
# ------------------------------------------------------------------------------
title_e = "Initial permittivity ( )"
title_s = "Initial conductivity (mS/m)"
midi_e  = 15
midi_s  = 2
# ------------------------------------------------------------------------------
maxi_e = -float('Inf')
mini_e =  float('Inf')
maxi_s = -float('Inf')
mini_s =  float('Inf')
# ------------------------------------------------------------------------------
# bring x and z
x,_,_=fancy_figure.bring_struct(path_param,'parame_','parame_','x',0,0)
z,_,_=fancy_figure.bring_struct(path_param,'parame_','parame_','z',0,0)
# ------------------------------------------------------------------------------
# bring initial
epsi,mini_e,maxi_e=fancy_figure.bring(path_init,epsi_name,mini_e,maxi_e,name__='epsi')
sigm,mini_s,maxi_s=fancy_figure.bring(path_init,sigm_name,mini_s,maxi_s,name__='sigm')
# ------------------------------------------------------------------------------
# bring recovered (for right colorbar)
for i_ in range(0,len(path_)):
    _,mini_e,maxi_e=fancy_figure.bring(path_[i_],'epsi',mini_e,maxi_e)
    _,mini_s,maxi_s=fancy_figure.bring(path_[i_],'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
# sigm=np.ones(sigm.shape)*2e-3
sigm=sigm*1e+3
mini_s=mini_s*1e+3
maxi_s=maxi_s*1e+3
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
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
# boreholes
B5=12.3;
A1=15.8;
B3=18.3;
B2=19.5;

m=0.01933429
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
colop='c',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax1,
curve=z,x=A1*np.ones(z.shape),
colop='c',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax1,
curve=z,x=B2*np.ones(z.shape),
colop='c',
symbol='-',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# guide-line
plt_=fancy_figure(
ax_=ax1,
curve=x*m-m+1,x=x,
colop='c',
symbol='--',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(
figsize=[9,6],
ax_=ax1,
data=epsi,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
xlabel="Length (m)",
midi=midi_e,
vmin=mini_e,
vmax=maxi_e,
colo='groundwater',
title=title_e,ylabel="Depth (m)",
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# boreholes for sig
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax2,
curve=z,x=B5*np.ones(z.shape),
colop='c',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax2,
curve=z,x=A1*np.ones(z.shape),
colop='c',
symbol='-',holdon='on'
).plotter()
fancy_figure(
ax_=ax2,
curve=z,x=B2*np.ones(z.shape),
colop='c',
symbol='-',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# guide-line
plt_=fancy_figure(
ax_=ax2,
curve=x*m-m+1,x=x,
colop='c',
symbol='--',holdon='on'
).plotter()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(
figsize=[9,6],
ax_=ax2,
data=sigm,
x=x,y=z,
extent=extents_,
ax_accu="%.0f",
midi=midi_s,
vmin=mini_s,
vmax=maxi_s,
colorbaron='on',
holdon='on',
colo_accu="%g",
colo='groundwater',
title=title_s,ylabel="Depth (m)",
xlabel="Length (m)",
guarda=120,
guarda_path=guarda_path,fig_name="initial-"+project_).matrix()
# ------------------------------------------------------------------------------
# plt_.show()
# ------------------------------------------------------------------------------
