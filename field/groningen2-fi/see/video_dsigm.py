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
guarda_path = "pics/updates/"
# ------------------------------------------------------------------------------
os.chdir(guarda_path)
os.system('rm *.png')
os.chdir('../..')
# ------------------------------------------------------------------------------
# permittivity file path
# ------------------------------------------------------------------------------
path_   = '../'+project_+'/dsigs/'
name_sw = 'wdsig'
name_sdc= 'dcdsig'
name_s  = 'wdcsig'
# ------------------------------------------------------------------------------
title_sw = "Radar conductivity update "
title_sdc= "ER conductivity update "
title_s  = "Joint conductivity update "
midi_    = 0
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
    file_ = path_ + name_sw + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_sw]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_sw = mini
maxi_sw = maxi
# ------------------------------------------------------------------------------
# load 1st file & get size
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
# ------------------------------------------------------------------------------
# get min & max of all files
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_ + name_sdc + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_sdc]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_sdc = mini
maxi_sdc = maxi
# ------------------------------------------------------------------------------
# load 1st file & get size
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
# ------------------------------------------------------------------------------
# get min & max of all files
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_ + name_s + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_s]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
mini_s= mini
maxi_s= maxi
# ------------------------------------------------------------------------------
# subplot
# ------------------------------------------------------------------------------
extents_ = [x[0],x[-1],z[-1],z[0]]
aspect_ = 'auto'#0.16 # larger number --> y axis is longer
size=[9.6*0.6,9.6*0.9]
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),#
holdon='on',colorbaron='off',transparent='False').matrix()
# ------------------------------------------------------------------------------
# print figures
# ------------------------------------------------------------------------------
for i_ in range(0,nfile):
    file_ = path_ + name_sw + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_sw]
    # --------------------------------------------------------------------------
    # title
    title = title_sw + str(i_)
    # --------------------------------------------------------------------------
    plt_.subplot(3,1,1)
    fancy_figure(aspect=aspect_,figsize=size,
    data=data,
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi_,vmin=mini_sw,vmax=maxi_sw,
    holdon='on',title=title,transparent='False',
    colo_accu="%g",
    colorbaron='on').matrix()
    # --------------------------------------------------------------------------
    file_ = path_ + name_sdc + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_sdc]
    # --------------------------------------------------------------------------
    # title
    title = title_sdc + str(i_)
    # --------------------------------------------------------------------------
    plt_.subplot(3,1,2)
    fancy_figure(aspect=aspect_,figsize=size,
    data=data.transpose(),
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi_,vmin=mini_sdc,vmax=maxi_sdc,
    title=title,transparent='False',
    colo_accu="%2.2g",
    colorbaron='on',holdon='on').matrix()
    # --------------------------------------------------------------------------
    file_ = path_ + name_s + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_s]
    # --------------------------------------------------------------------------
    # title
    title = title_s + str(i_)
    # --------------------------------------------------------------------------
    plt_.subplot(3,1,3)
    fancy_figure(aspect=aspect_,figsize=size,
    data=data,
    x=x,y=z,extent=extents_,
    xlabel="Length (m)",ylabel="Depth (m)",
    midi=midi_,vmin=mini_s,vmax=maxi_s,
    title=title,transparent='False',
    colo_accu="%2.2g",
    guarda=120,guarda_path=guarda_path,holdon='close').matrix()
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
import os
print('making a video now ...')
os.chdir(guarda_path)
os.environ["file_name"] = "Joint-conductivity-update"
os.system('ffmpeg -r 2 -i $file_name-%d.png -c:v ffv1 -r 10 updates-sig.avi')
# ------------------------------------------------------------------------------


