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
path_     = '../' + project_ + '/output/dc/'
# ------------------------------------------------------------------------------
guarda_path = "pics/"
dpi=120
# ------------------------------------------------------------------------------
Edc,_,_ = fancy_figure.bring(path_,'E',0,0)
Edc= Edc / Edc.max()
Edc= Edc[0,:] 
# ------------------------------------------------------------------------------
iter_ = Edc.size
iter_ = np.arange(1.,iter_+1)
# ------------------------------------------------------------------------------
size=[6.41*0.7,6.41*0.7]
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
# Edc
# ------------------------------------------------------------------------------
fancy_figure(figsize=size,
curve=Edc,x=iter_,
symbol='.-',
xlabel="Iteration \#",ylabel=r'$\Theta_{dc}$',
colop=((0,0,0)),margin=(0.02,0.03),
guarda_path=guarda_path,holdon='on',
guarda=dpi,fig_name="dc-obj-fnc-"+project_).plotter()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------

