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
if fi_=="sigm":
    data  = file_['sigm']
    data  = 1e+3*data
    title = "Recovered conductivity DC (mS/m)"
    print('min ',data.min())
    print('max ',data.max())
    vmax=None
    vmin=None
    midi  = input ("midi for colormap: ") 
    # midi = 2
elif fi_=="dsig":
    data  = file_['dsigm_dc']
    title = "Update conductivity DC"
    vmax=None
    vmin=None
    midi = 0
elif fi_=="v_cu":
    data  = file_['v_currs']
    title = "Electric current sensitivity"
    data = data/data.max()
    vmin=0
    vmax  = input ("vmax for colormap: ")
    midi  = input ("midi for colormap: ")
    # midi = 0.1
# ------------------------------------------------------------------------------
nz,nx=data.shape
print(data.min())
print(data.max())
# ------------------------------------------------------------------------------
fancy_figure(data=data,
x_ticklabels='off',y_ticklabels='off',
midi=midi,
vmax=vmax,
vmin=vmin,
title=title,
colo='groundwater',
xlabel="Length (m)",
ylabel="Depth (m)",
guarda_path=guarda_path,
guarda=120).matrix()
# ------------------------------------------------------------------------------






