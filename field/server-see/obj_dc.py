import sys
sys.path.append('../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import numpy as np
import scipy.io as sio
import glob
# ------------------------------------------------------------------------------
file_ = glob.glob('*.mat')
file_ = file_[0]
fi_   = file_[0:4]
# ------------------------------------------------------------------------------
guarda_path = "pics/"
dpi=120
# ------------------------------------------------------------------------------
E,_,_ = fancy_figure.bring('','E',0,0)
# ------------------------------------------------------------------------------
E  = E.squeeze()
# ------------------------------------------------------------------------------
E  = E / E.max()
# ------------------------------------------------------------------------------
iter_ = E.size
iter_ = np.arange(1.,iter_+1)
# ------------------------------------------------------------------------------
size=[6.41*0.75,6.41*0.75]
aspect_ =0.2 # larger number --> y axis is longer
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
plt_=fancy_figure(figsize=size,#aspect=aspect_,
curve=E,x=iter_,
title='Objective function ER',
xlabel='Iteration \#',ylabel=r'$\Theta_{dc}$',
symbol='o-',
colo_accu='%2i',
colop=((0,0,0)),
margin=(0.02,0.03),
guarda_path=guarda_path,
guarda=dpi,fig_name="obj_fncER").plotter()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------

