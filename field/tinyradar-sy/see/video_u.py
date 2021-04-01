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
project_= input ("project name     : ")
nfile   = input ("# of wave chunks : ")
ishot   = input ("# of source      : ")
nfile   = int(nfile)
ishot   = int(ishot)
guarda_path = "pics/wavefield/u/"
# ------------------------------------------------------------------------------
os.chdir(guarda_path)
os.system('rm *.png')
os.system('rm *.gif')
os.system('rm *.avi')
os.chdir('../../../')
# ------------------------------------------------------------------------------
# permittivity file path
# ------------------------------------------------------------------------------
path_  = '../'+project_+'/wavefield/u/'
name_u = 'u'
name_u_= 'u_w'
# ------------------------------------------------------------------------------
title_u = "Radar wave (V/m)"
midi_u  = 0
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring('../'+project_+'/output/w/','x',0,0)
z,_,_=fancy_figure.bring('../'+project_+'/output/w/','z',0,0)
# ------------------------------------------------------------------------------
# bring sources and receivers
sr_w_=fancy_figure.bring_cell('../'+project_+'/data-recovered/w/','s_r')
r_w  = sr_w_[ishot-1,1]
rx_w = r_w[:,0]
rz_w = r_w[:,1]
sx_w = sr_w_[ishot-1,0][0][0]
sz_w = sr_w_[ishot-1,0][0][1]
# '''
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
for i_ in range(1,nfile+1):
    file_ = path_ + name_u + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_u_]
    mini_ = data.min()
    maxi_ = data.max()
    mini = min(mini,mini_)
    maxi = max(maxi,maxi_)
# ------------------------------------------------------------------------------
mini_u = mini*0.05
maxi_u = maxi*0.05
# ------------------------------------------------------------------------------
# plot
# ------------------------------------------------------------------------------
extents_ = [x[0],x[-1],z[-1],z[0]]
aspect_ = 'auto'#0.16 # larger number --> y axis is longer
size=[9.6*0.6,9.6*0.6]
# ------------------------------------------------------------------------------
# plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
# print figures
# ------------------------------------------------------------------------------
for i_ in range(1,nfile+1):
    file_ = path_ + name_u + str(i_) + '.mat'
    file_ = sio.loadmat(file_)
    data  = file_[name_u_]
    # --------------------------------------------------------------------------
    _,_,nt= data.shape 
    # --------------------------------------------------------------------------
    title = title_u
    # --------------------------------------------------------------------------
    plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off',transparent='False').matrix()
    # --------------------------------------------------------------------------
    # count_ = count_ + nt
    # --------------------------------------------------------------------------    
    for ii_ in range(0,nt):
        fancy_figure(curve=rz_w,x=rx_w,
        colop='c',transparent='False',
        symbol='.',holdon='on').plotter()
        fancy_figure(curve=sz_w,x=sx_w,
        colop='c',transparent='False',
        symbol='*',holdon='on').plotter()
        # ----------------------------------------------------------------------
        data_ = data[:,:,ii_]
        data_ = np.squeeze(data_)
        # ----------------------------------------------------------------------
        fancy_figure(figsize=size,#aspect=aspect_,
        data=data_,
        x=x,y=z,extent=extents_,
        xlabel="x (m)",ylabel="y (m)",
        midi=midi_u,vmin=mini_u,vmax=maxi_u,
        title=title,transparent='False',
        colo_accu="%g",
        colorbaron='off',
        fig_name='wavefield'+str(ii_+(i_-1)*nt),
        guarda=420,guarda_path=guarda_path,holdon='close').matrix()
# ------------------------------------------------------------------------------
# make video using ffmpeg
# ------------------------------------------------------------------------------
import os
print('making a video now ...')
os.chdir(guarda_path)
os.environ["file_name"] = "wavefield"
os.environ["vide_name"] = "wavefield"
# ------------------------------------------------------------------------------
# os.system('ffmpeg -r 2 -i $file_name%d.png -c:v ffv1 -r 10 $vide_name.avi')
# ------------------------------------------------------------------------------
# sips -g pixelWidth $file_name0.png
# os.system('gifski -o $vide_name.gif -W 800 -H 400 --fps 1 $file_name*.png')
os.system('gifski -o $vide_name.gif -W 400 -H 406 --fps 40 $file_name*.png')
# ------------------------------------------------------------------------------
# os.system('ffmpeg -r 2 -i $file_name%d.png -c:v ffv1 -r 10 $vide_name.avi')
# os.system('ffmpeg -r 2 -i $file_name%d.png -vf scale="600:-1" -r 10 $vide_name.gif')
# os.system('ffmpeg -i $vide_name.avi -pix_fmt rgb24 $vide_name_.gif')
# ------------------------------------------------------------------------------# ------------------------------------------------------------------------------
# '''

