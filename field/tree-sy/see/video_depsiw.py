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
guarda_path = "pics/depsis_w/"
# ------------------------------------------------------------------------------
os.chdir(guarda_path)
os.system('rm *.png')
os.chdir('../..')
# ------------------------------------------------------------------------------
# permittivity file path
# ------------------------------------------------------------------------------
path_   = '../'+project_+'/depsis_w/'
name_ew = 'depsi'
name_ew_= 'epsi'
# ------------------------------------------------------------------------------
title_ew = "Permittivity update "
midi_    = 0
# ------------------------------------------------------------------------------
title_ew_= "Permittivity ( )"
midi__   = 7
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring('../'+project_+'/output/w/','x',0,0)
z,_,_=fancy_figure.bring('../'+project_+'/output/w/','z',0,0)
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
    file_ = path_ + name_ew + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_ew]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_ew = mini
maxi_ew = maxi
# ------------------------------------------------------------------------------
# load 1st file & get size
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
# ------------------------------------------------------------------------------
# get min & max of all files
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_ + name_ew_ + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_ew_]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_ew_ = mini
maxi_ew_ = maxi
# ------------------------------------------------------------------------------
# subplot
# ------------------------------------------------------------------------------
extents_ = [x[0],x[-1],z[-1],z[0]]
aspect_ = 'auto'#0.16 # larger number --> y axis is longer
size=[9.6*0.6,9.6*0.6]
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(2,1)
# ------------------------------------------------------------------------------
# print figures
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_ + name_ew_ + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_ew_]
    # --------------------------------------------------------------------------
    # title
    title = title_ew_
    # --------------------------------------------------------------------------
    fancy_figure(figsize=size,ax_=ax[0],#aspect=aspect_,
    data=data,
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi__,vmin=mini_ew_,vmax=maxi_ew_,
    title=title,transparent='False',
    colo_accu="%g",
    colorbaron='on',
    holdon='on').matrix()
    # --------------------------------------------------------------------------
    file_ = path_ + name_ew + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_ew]
    # --------------------------------------------------------------------------
    # title
    title = title_ew + str(i_)
    # --------------------------------------------------------------------------
    fancy_figure(figsize=size,ax_=ax[1],#aspect=aspect_,
    data=data,
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi_,vmin=mini_ew,vmax=maxi_ew,
    title=title,transparent='False',
    colo_accu="%g",
    colorbaron='on',
    guarda=120,guarda_path=guarda_path,holdon='close').matrix()
# ------------------------------------------------------------------------------
# remove transparencies
# ------------------------------------------------------------------------------
from fancy_image import fancy_image
print('removing transparencies')
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = guarda_path + title_ew + str(i_) + ".png"
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
import os
print('making a video now ...')
os.chdir(guarda_path)
os.environ["file_name"] = "Permittivity-update"
os.environ["vide_name"] = "updates-eps"
# ------------------------------------------------------------------------------
os.system('ffmpeg -r 2 -i $file_name-%d.png -c:v ffv1 -r 10 $vide_name.avi')
# ------------------------------------------------------------------------------
# sips -g pixelWidth $file_name0.png
# os.system('gifski -o $vide_name.gif -W 800 -H 400 --fps 1 $file_name-*.png')
os.system('gifski -o $vide_name.gif --fps 1 $file_name-*.png')
# ------------------------------------------------------------------------------
# os.system('ffmpeg -r 2 -i $file_name-%d.png -c:v ffv1 -r 10 $vide_name.avi')
# os.system('ffmpeg -r 2 -i $file_name-%d.png -vf scale="600:-1" -r 10 $vide_name.gif')
# os.system('ffmpeg -i $vide_name.avi -pix_fmt rgb24 $vide_name_.gif')
# ------------------------------------------------------------------------------


