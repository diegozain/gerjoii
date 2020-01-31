import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
import os
# ------------------------------------------------------------------------------
# set directory & # of files
# ------------------------------------------------------------------------------
project_= input ("project name    : ")
nfile   = input ("# of iterations : ")
nfile = int(nfile)
guarda_path = "pics/parameters/"
# ------------------------------------------------------------------------------
os.chdir(guarda_path)
os.system('rm *.png')
os.chdir('../..')
# ------------------------------------------------------------------------------
# permittivity file path
# ------------------------------------------------------------------------------
path_e = '../'+project_+'/depsis/'
path_s = '../'+project_+'/dsigs/'
name_e = 'epsi'
name_s = 'sigm'
# ------------------------------------------------------------------------------
title_e   = "Permittivity "
title_s   = "Conductivity "
midi_e    = 7
midi_s    = 2
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring('../'+project_+'/output/wdc/','x',0,0)
z,_,_=fancy_figure.bring('../'+project_+'/output/wdc/','z',0,0)
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
# ------------------------------------------------------------------------------
# load 1st file & get size
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
# ------------------------------------------------------------------------------
# get min & max of all files
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_e + name_e + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_e]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_e = mini
maxi_e = maxi
# ------------------------------------------------------------------------------
# load 1st file & get size
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
# ------------------------------------------------------------------------------
# get min & max of all files
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_s + name_s + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_s]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_s = mini*1e+3
maxi_s = maxi*1e+3
# ------------------------------------------------------------------------------
# subplot
# ------------------------------------------------------------------------------
extents_ = [x[0],x[-1],z[-1],z[0]]
plt_=fancy_figure(data=np.zeros((2,2)),#
holdon='on',colorbaron='off',transparent='False').matrix()
# ------------------------------------------------------------------------------
# print figures
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_e + name_e + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_e]
    # --------------------------------------------------------------------------
    # title
    title = title_e + str(i_)
    # --------------------------------------------------------------------------
    plt_.subplot(2,1,1)
    fancy_figure(data=data,#
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi_e,vmin=mini_e,vmax=maxi_e,#
    holdon='on',title=title,transparent='False',#
    colo_accu="%g",#
    colorbaron='on').matrix()
    # --------------------------------------------------------------------------
    file_ = path_s + name_s + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_s]
    data  = data*1e+3
    # --------------------------------------------------------------------------
    # title
    title = title_s + str(i_)
    # --------------------------------------------------------------------------
    plt_.subplot(2,1,2)
    fancy_figure(data=data,#
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi_s,vmin=mini_s,vmax=maxi_s,#
    title=title,holdon='close',transparent='False',#
    colo_accu="%2.2g",#
    guarda=120,guarda_path=guarda_path).matrix()
# ------------------------------------------------------------------------------
# remove transparencies
# ------------------------------------------------------------------------------
from fancy_image import fancy_image
print('removing transparencies')
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = guarda_path + title_s + str(i_) + ".png"
    file_ = file_.replace(" ", "-")
    im = fancy_image(im=file_).openim()
    dpi=im.info['dpi']
    im = fancy_image(im=im).transpa_bye()
    # --------------------------------------------------------------------------
    # save
    # --------------------------------------------------------------------------
    im.save(file_,"PNG", dpi=dpi)
# ------------------------------------------------------------------------------
# make video using ffmpeg
# ------------------------------------------------------------------------------
print('making a video now ...')
os.chdir(guarda_path)
os.environ["file_name"] = "Conductivity"
os.system('ffmpeg -r 2 -i $file_name-%d.png -c:v ffv1 -r 10 parameters.avi')
# ------------------------------------------------------------------------------


