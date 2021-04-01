import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import numpy as np
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
# ------------------------------------------------------------------------------
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
dpi = 120*dpi_
# ------------------------------------------------------------------------------
# set retrieving dirs
# ------------------------------------------------------------------------------
dd_wen   = "_dd" # "_dd" "_wen"
# ------------------------------------------------------------------------------
path_ = 'data1/'
# ------------------------------------------------------------------------------
name_ = 'data_dc'
d_dc,mini,maxi = fancy_figure.bring_struct(path_,'data_dc','data_dc',
                                    'd',float('Inf'),-float('Inf'))
idv,mini,maxi = fancy_figure.bring_struct(path_,'data_dc','data_dc','idv',0,0)
# ------------------------------------------------------------------------------
# names
# ------------------------------------------------------------------------------
name_   = 'voltagram' + dd_wen
struct_ = 'voltagram'
field_pseus_rhoa = 'pseus_rhoa'
field_source_no  = 'source_no'
field_n_levels   = 'n_levels'
if dd_wen == '_dd':
    title_='cluster-dipole-dipole'
elif dd_wen == '_wen':
    title_='cluster-wenner'
# ------------------------------------------------------------------------------
# bring to memory - noise free
# ------------------------------------------------------------------------------
pseus_rhoa,mini,maxi = fancy_figure.bring_struct(path_,name_,struct_,
                                    field_pseus_rhoa,float('Inf'),-float('Inf'))
source_no,_,_=fancy_figure.bring_struct(path_,name_,struct_,field_source_no,0,0)
n_levels,_,_ =fancy_figure.bring_struct(path_,name_,struct_,field_n_levels,0,0) 
# ------------------------------------------------------------------------------
# bring to memory - with noise
# ------------------------------------------------------------------------------
name_ = name_+'_noise'
pseus_rhoa_noise,_,_ = fancy_figure.bring_struct(path_,name_,struct_,
                                    field_pseus_rhoa,mini,maxi)
# ------------------------------------------------------------------------------
# clean
# ------------------------------------------------------------------------------
n_levels=np.squeeze(n_levels)
source_no=np.squeeze(source_no)
# source_no  = source_no[0:-1]
# n_levels   = n_levels[0:-1]
# pseus_rhoa = pseus_rhoa[0:-1,0:-1]
# ------------------------------------------------------------------------------
# set consantants for plotting
# ------------------------------------------------------------------------------
print('min and max ',mini,maxi)
midi = None
# ------------------------------------------------------------------------------
size=[6.41*1.6,9.6*0.4]
aspect_ = 0.1 # larger number --> y axis is longer
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(1,3)
# ------------------------------------------------------------------------------
for i_ in range(0,3):
    d_dc_ = d_dc[np.where(idv== (i_+1) )]
    if i_==0:
        symbol='kx'
    elif i_==1:
        symbol='+'
    elif i_==2:
        symbol='o'
    fancy_figure(ax_=ax[0],figsize=size,aspect=aspect_,
    curve=d_dc_,symbol=symbol,
    colop=((0,0,0)),
    margin=(0.02,0.03),
    # x_ticklabels='off',y_ticklabels='off',
    title='Noise free clusters',ylabel="ER data (V)",xlabel="Index \#",
    holdon='on'
    ).plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[1],figsize=size,aspect=aspect_,
data=pseus_rhoa,
x=source_no,y=n_levels,
ax_accu="%.0f",
midi=midi,vmin=mini,vmax=maxi,
title='Dipole-dipole noise free',xlabel="Source \#",ylabel="n level",
holdon='on',colorbaron='off',colo='Greys',
).pmatrix()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[2],figsize=size,aspect=aspect_,
data=pseus_rhoa_noise,
x=source_no,y=n_levels,
# y_ticklabels='off',
ax_accu="%.0f",
midi=midi,vmin=mini,vmax=maxi,
title='Dipole-dipole with noise',xlabel="Source \#",
ylabel="n level",
holdon='on',colorbaron='off',colo='Greys',
guarda_path=guarda_path,
guarda=dpi,fig_name="figo"
).pmatrix()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------
# colorbar extra
# ------------------------------------------------------------------------------
fig = plt_.gcf()
plt_.close()
size = fig.get_size_inches()
fancy_figure(midi=midi,vmin=mini,vmax=maxi,
figsize=size,holdon='on',
colo_title='Apparent resistivity (Ohm.m)',
colo='Greys',
guarda_path=guarda_path,
guarda=dpi).colorbar_alone()
# ------------------------------------------------------------------------------
# join figures
# ------------------------------------------------------------------------------
im =guarda_path+"figo.png"
im_=guarda_path+"fig.png"
im = fancy_image(im=im).openim()
dpi=im.info['dpi']
nh,_=im.size
im_ = fancy_image(im=im_,nh=nh,nh_r=115*dpi_).padder_h()
im = fancy_image(im=im,im_=im_).concat_v()
im.show()
im.save(guarda_path+'datadc'+".png","PNG", dpi=dpi)