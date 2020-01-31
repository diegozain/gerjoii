import sys
sys.path.append('../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import glob
# ------------------------------------------------------------------------------
file_ = glob.glob('*.mat')
file_ = file_[0]
fi_   = file_[0:4]
# ------------------------------------------------------------------------------
guarda_path = "pics/"
# ------------------------------------------------------------------------------
file_ = sio.loadmat(file_)
if fi_=="epsi":
    data  = file_['epsi']
    title = "Recovered permittivity ( )"
    print('min ',data.min())
    print('max ',data.max())
    midi  = input ("midi for colormap: ")
elif fi_=="sigm":
    data  = file_['sigm']
    data  = 1e+3*data
    title = "Recovered conductivity (mS/m)"
    print('min ',data.min())
    print('max ',data.max())
    midi  = input ("midi for colormap: ")
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
    midi = 0
# ------------------------------------------------------------------------------
nz,nx=data.shape
print('min ',data.min())
print('max ',data.max())
print('shape ',nz,nx)
# ------------------------------------------------------------------------------
fancy_figure(data=data,
x_ticklabels='off',y_ticklabels='off',
midi=midi,
# vmax=9,   # 9 4
# vmin=4,
title=title,
xlabel="Length (m)",
ylabel="Depth (m)",
guarda_path=guarda_path,
guarda=120).matrix()
# ------------------------------------------------------------------------------






