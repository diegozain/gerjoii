import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import numpy as np
import scipy.io as sio
import glob
# ------------------------------------------------------------------------------
project_= input ("project name : ")
path_     = '../' + project_ + '/output/wdc/'
# ------------------------------------------------------------------------------
guarda_path = "pics/"
dpi=120
# ------------------------------------------------------------------------------
legend_ = [r'$a_w$',r'$a_{dc}$']
# ------------------------------------------------------------------------------
as_,_,_ = fancy_figure.bring(path_,'as',0,0)
# ------------------------------------------------------------------------------
as_= as_[:,:,1:]
aw = as_[0,0,:].squeeze()
adc= as_[0,1,:].squeeze()
Ew = as_[1,0,:].squeeze()
Edc= as_[1,1,:].squeeze()
# ------------------------------------------------------------------------------
Ew = Ew / Ew.max()
Edc= Edc / Edc.max()
# ------------------------------------------------------------------------------
iter_ = aw.size
iter_ = np.arange(1.,iter_+1)
# ------------------------------------------------------------------------------
size=[6.41*0.75,6.41*1.1]
aspect_ = 2 # larger number --> y axis is longer
aspect__='equal'
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(2,1,figsize=size)
# ------------------------------------------------------------------------------
# aw and adc
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],figsize=size,#aspect=aspect__,
curve=aw,x=iter_,
symbol='.-',legends=legend_,legend_coord=(10,0.75),
xlabel="Iteration \#",ylabel="Weights",
colop=((0.1,0.5,0.3)),margin=(0.02,0.03),
holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],figsize=size,#aspect=aspect__,
curve=adc,x=iter_,
symbol='.-',legends=legend_,legend_coord=(10,0.75),
xlabel="Iteration \#",ylabel="Value",
colop=((0.3882,0.2039,0.6588)),margin=(0.02,0.03),
holdon='on').plotter() 
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[1],figsize=size,aspect=aspect_,
curve=Ew,x=Edc,
symbol='o',
scatter_colo=iter_,
colo_accu='%2i',
# colo='Greys',
xlabel=r'$\Theta_{dc}$',ylabel=r'$\Theta_{w,\sigma}$',
colo_title="Iteration \#",
margin=(0.02,0.03),
guarda_path=guarda_path,holdon='on',
guarda=dpi,fig_name="objective-fncs-"+project_).scatterer()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------

