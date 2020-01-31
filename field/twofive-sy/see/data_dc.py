import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
midi=1100
# ------------------------------------------------------------------------------
reco_obs= input ("recovered or observed (reco or obs): ")
# ------------------------------------------------------------------------------
if (reco_obs == 'obs'):
    path_ = '../data/dc/pseudo/'
    name_ = 'observed'
elif (reco_obs == 'reco'):
    project_= input ("project name : ")
    path_ = '../'+project_+'/data-recovered/dc/'
    name_ = project_
# ------------------------------------------------------------------------------
dd_wen  = input ("dipole-dipole or wenner (-dd or -wen) : ")
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
dpi_=1
dpi =dpi_*120
# ------------------------------------------------------------------------------
guarda_path='pics/'
# ------------------------------------------------------------------------------
# names
# ------------------------------------------------------------------------------
name_      = name_ + dd_wen
struct_    = 'voltagram'
pseus_rhoa = 'pseus_rhoa'
source_no  = 'source_no'
n_levels   = 'n_levels'
# ------------------------------------------------------------------------------
if (dd_wen=='-dd'):
    title='Dipole-dipole (Ohm.m)'
elif (dd_wen=='-wen'):
    title='Wenner (Ohm.m)'
# ------------------------------------------------------------------------------
# bring to memory - noise free
# ------------------------------------------------------------------------------
pseus_rhoa,mini,maxi = fancy_figure.bring_struct(path_,name_,struct_,
                                    pseus_rhoa,float('Inf'),-float('Inf'))
source_no,_,_=fancy_figure.bring_struct(path_,name_,struct_,source_no,0,0)
n_levels,_,_ =fancy_figure.bring_struct(path_,name_,struct_,n_levels,0,0) 
# ------------------------------------------------------------------------------
# clean
# ------------------------------------------------------------------------------
n_levels =np.squeeze(n_levels)
source_no=np.squeeze(source_no)
# source_no  = source_no[0:-1]
# n_levels   = n_levels[0:-1]
# pseus_rhoa = pseus_rhoa[0:-1,0:-1]
# ------------------------------------------------------------------------------
# set consantants for plotting
# ------------------------------------------------------------------------------
print('min and max ',mini,maxi)
# ------------------------------------------------------------------------------
size=[6,6*0.8]
aspect_ = 'auto' # larger number --> y axis is longer. 'auto' 'equal'
# ------------------------------------------------------------------------------
plt_=fancy_figure(figsize=size,aspect=aspect_,
data=pseus_rhoa,
x=source_no,y=n_levels,
# y_ticklabels='off',
ax_accu="%.0f",
midi=midi,vmin=mini,vmax=maxi,
title=title,xlabel="Source \#",
ylabel="n level",
holdon='on',colorbaron='on',#colo='Greys',
guarda_path=guarda_path,
guarda=dpi,
fig_name='dc-'+name_,
).pmatrix()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------

