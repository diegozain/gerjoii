import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
import numpy as np
# ------------------------------------------------------------------------------
colo='groundwater_'
# colo='groundwater__'
size=[5.5,5.5]
aspect_ = 'auto' # larger number --> y axis is longer. 'auto' 'equal'
dd_wen  = input ("dipole-dipole or wenner (dd or wen) : ")
# dd_wen = 'dd'

if (dd_wen=='dd'):
    title='Dipole-dipole'
    midi=850
elif (dd_wen=='wen'):
    title='Wenner'
    midi=850

guarda_path='pics/'

dpi = 120
# ------------------------------------------------------------------------------
path_o = '../t1/data-synth/dc/pseudo/'
name_o = 'observed-'
# ------------------------------------------------------------------------------
maxi_rho  = -float('Inf')
mini_rho  =  float('Inf')
# ------------------------------------------------------------------------------
# bring data to memory
# ------------------------------------------------------------------------------
do,_,_= fancy_figure.bring(path_o,name_o+'data',0,0,name__='d_o')
# ------------------------------------------------------------------------------
# bring pseudo sections to memory
# ------------------------------------------------------------------------------
pseus_rhoa_o,mini_rho,maxi_rho= fancy_figure.bring_struct(path_o,name_o+dd_wen,'voltagram','pseus_rhoa',mini_rho,maxi_rho)

n_levels,_,_= fancy_figure.bring_struct(path_o,name_o+dd_wen,'voltagram','n_levels',0,0)

source_no,_,_= fancy_figure.bring_struct(path_o,name_o+dd_wen,'voltagram','source_no',0,0)
# ------------------------------------------------------------------------------
# clean
# ------------------------------------------------------------------------------
n_levels =np.squeeze(n_levels)
source_no=np.squeeze(source_no)
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
data=pseus_rhoa_o,
x=source_no,
y=n_levels,
ax_accu="%.0f",
midi=midi,
vmin=mini_rho,
vmax=maxi_rho,
ylabel="n level",
xlabel="Source \#",
title=title+' $(\Omega \cdot m)$',
# colo=colo,
guarda_path=guarda_path,
guarda=dpi,
fig_name=name_o+dd_wen,
).pmatrix()
# ------------------------------------------------------------------------------
