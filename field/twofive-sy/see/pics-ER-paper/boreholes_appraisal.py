import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
figsize=[6.41*0.5,6.41*1]
aspect_= 2.5 # larger number --> y axis is longer
# ------------------------------------------------------------------------------
guarda_path='pics/'
# ------------------------------------------------------------------------------
path_t = '../../image2mat/nature-synth/mat-file/'
# ------------------------------------------------------------------------------
project_=np.loadtxt('project_.txt',dtype='str')
project_=project_.item()
# ------------------------------------------------------------------------------
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
dpi = 120*dpi_
# ------------------------------------------------------------------------------
path_r = '../../'+project_+'/output/dc/'
# ------------------------------------------------------------------------------
maxi_ = -float('Inf')
mini_ =  float('Inf')
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring(path_r,'x',0,0)
z,_,_=fancy_figure.bring(path_r,'z',0,0)
sigm_r,mini_,maxi_=fancy_figure.bring(path_r,'sigm',mini_,maxi_)
# ------------------------------------------------------------------------------
name_='sigm_topo'
struct_=name_
sigm_,_,_=fancy_figure.bring_struct(path_r,name_,struct_,'sigm',0,0)
sigm_=sigm_*1e+3
# ------------------------------------------------------------------------------
print('max sig ',maxi_*1e+3)
print('min sig ',mini_*1e+3)
# ------------------------------------------------------------------------------
sigm_t,mini_,maxi_=fancy_figure.bring(path_t,'sigm',mini_,maxi_)
circle,_,_=fancy_figure.bring(path_t,'circle',mini_,maxi_)
# ------------------------------------------------------------------------------
sigm_t = 1e+3*sigm_t
sigm_r = 1e+3*sigm_r
mini_ = mini_*1e+3
maxi_ = maxi_*1e+3
# ------------------------------------------------------------------------------
# boreholes
Bz = 10 # m
x_ = Bz  # m
# ------------------------------------------------------------------------------
x_ = np.where(x == x_)
x_ = x_[1][0]
# ------------------------------------------------------------------------------
Bz_true = sigm_t[:,x_]
Bz_reco = sigm_r[:,x_]
Bz_reco_= sigm_[:,x_]
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
# ------------------------------------------------------------------------------
z_min = np.argmin(Bz_reco_)
z_min = z[z_min]
# ------------------------------------------------------------------------------
# borehole true
plt_=fancy_figure(figsize=figsize,aspect=aspect_,
curve=z,x=Bz_true,
symbol='-',colop='k',ydir='reverse',
# xlabel="DC conductivity (mS/m)",ylabel="Depth (m)",
# ax_accu="%.0f",
margin=(0.02,0.03),
holdon='on').plotter()
# ------------------------------------------------------------------------------
# appraisal line
plt_=fancy_figure(figsize=figsize,aspect=aspect_,
curve=np.ones(x.shape)*z_min,x=np.linspace(mini_,maxi_,x.size),
symbol='--',colop=((0.5,0.5,0.5)),#ydir='reverse',
# xlabel="DC conductivity (mS/m)",ylabel="Depth (m)",
# ax_accu="%.0f",
margin=(0.02,0.03),
holdon='on').plotter()
# ------------------------------------------------------------------------------
# borehole reco
fancy_figure(figsize=figsize,aspect=aspect_,plt_=plt_,
curve=z,x=Bz_reco,
symbol='-',colop='r',#ydir='reverse',
xlabel="DC conductivity (mS/m)",ylabel="Depth (m)",
margin=(0.02,0.03),
holdon='on',
fig_name='boreholez-sy-',
guarda_path=guarda_path,
guarda=dpi).plotter()
# ------------------------------------------------------------------------------
# plt_.show()
# ------------------------------------------------------------------------------
