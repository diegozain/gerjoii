import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
project_= input ("project name (for colormap): ") 
guarda_path = "pics/"
# ------------------------------------------------------------------------------
path_=["../"+project_+"/output/wdc/"]
# ------------------------------------------------------------------------------
path_true = "true/"
path_init = "../image2mat/nature-synth/initial-guess/"
# ------------------------------------------------------------------------------
title_e = "Initial permittivity ( )"
title_s = "Initial conductivity (mS/m)"
midi_e  = 7
midi_s  = 2
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
# bring initial
epsi,mini_e,maxi_e=fancy_figure.bring(path_init,'epsi3',mini_e,maxi_e,name__='epsi')
sigm,mini_s,maxi_s=fancy_figure.bring(path_init,'sigm0',mini_s,maxi_s,name__='sigm')
# ------------------------------------------------------------------------------
# bring true
_,mini_e,maxi_e=fancy_figure.bring(path_true,'epsi_true',mini_e,maxi_e)
_,mini_s,maxi_s=fancy_figure.bring(path_true,'sigm_true',mini_s,maxi_s)
# ------------------------------------------------------------------------------
# bring recovered (for right colorbar)
for i_ in range(0,len(path_)):
    _,mini_e,maxi_e=fancy_figure.bring(path_[i_],'epsi',mini_e,maxi_e)
    _,mini_s,maxi_s=fancy_figure.bring(path_[i_],'sigm',mini_s,maxi_s)
# ------------------------------------------------------------------------------
sigm=sigm*1e+3
mini_s=mini_s*1e+3
maxi_s=maxi_s*1e+3
# ------------------------------------------------------------------------------
# mini_s=1
# maxi_s=5
# mini_e=4
# maxi_e=9
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,(ax1,ax2)=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# permittivity
fancy_figure(ax_=ax1,
data=epsi,
x=x,y=z,extent=extents_,
# x_ticklabels='off',
ax_accu="%.0f",
xlabel="Length (m)",
midi=midi_e,vmin=mini_e,vmax=maxi_e,
title=title_e,ylabel="Depth (m)",
holdon='on',colo_accu="%g",
colorbaron='on').matrix()
# ------------------------------------------------------------------------------
# conductivity
fancy_figure(ax_=ax2,
data=sigm,
x=x,y=z,extent=extents_,
ax_accu="%.0f",
midi=midi_s,vmin=mini_s,vmax=maxi_s,
colorbaron='on',holdon='on',colo_accu="%g",
title=title_s,ylabel="Depth (m)",
xlabel="Length (m)",
guarda=120,
guarda_path=guarda_path,fig_name="initial").matrix()
# ------------------------------------------------------------------------------
# plt_.show()
# ------------------------------------------------------------------------------
