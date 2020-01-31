import sys
sys.path.append('../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import numpy as np
# ------------------------------------------------------------------------------
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
file_ = sio.loadmat(file_)
if fi_=="epsi":
    data  = file_['epsi']
    title = "Recovered permittivity ( )"
    print('min ',data.min())
    print('max ',data.max())
elif fi_=="sigm":
    data  = file_['sigm']
    data  = 1e+3*data
    title = "Recovered conductivity (mS/m)"
    print('min ',data.min())
    print('max ',data.max())
elif fi_=="dsig":
    name_ = input ("dsigm, dsigm_w or dsigm_dc ? ")
    data  = file_[name_]
    midi = 0
    if len(name_)<6:
        name_=''
    else:
        name_=name_[6:]
    title="Update conductivity "+name_
elif fi_=="deps":
    data  = file_['depsi']
    title = "Update permittivity"
# ------------------------------------------------------------------------------
# borehole
bx = input ("index for x coordinate: ")
bx = int(bx)
bx = bx-1 
bx = data[:,bx]
# ------------------------------------------------------------------------------
size_ = [6.41*0.5,6.41*1]
# ------------------------------------------------------------------------------
guarda_path = "pics/"
# ------------------------------------------------------------------------------
# boreholes
# ------------------------------------------------------------------------------
mini_ = data.min()
maxi_ = data.max()
xlim=[mini_-mini_*0.1,maxi_+maxi_*0.1]
# ------------------------------------------------------------------------------
# borehole
plt_=fancy_figure(figsize=size_,
curve=np.arange(data.shape[0]),x=bx,ydir = 'reverse',
colop='k',symbol='-',xlim=xlim,
ylabel='Depth (m)',
y_ticklabels='off',
holdon='on',
title=title,
guarda=dpi,
guarda_path=guarda_path,fig_name='borehole'+fi_).plotter()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------
