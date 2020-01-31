import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
import scipy.io as sio
import numpy as np
# ------------------------------------------------------------------------------
midi_s  = 6
maxi_s  = 10
mini_s  = 4
# ------------------------------------------------------------------------------
size=[6*1.4,6*1]
# aspect_ = 'auto' # larger number --> y axis is longer. 'auto' 'equal'
# ------------------------------------------------------------------------------
guarda_path='pics/'
# ------------------------------------------------------------------------------
path_t = '../../image2mat/nature-synth/mat-file/'
# ------------------------------------------------------------------------------
project_=np.loadtxt('project_.txt',dtype='str')
project_=project_.item()
# ------------------------------------------------------------------------------
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
dpi = 120*dpi_
# ------------------------------------------------------------------------------
path_r = '../../'+project_+'/output/dc/'
# ------------------------------------------------------------------------------
maxi_ = -float('Inf')
mini_ =  float('Inf')
# ------------------------------------------------------------------------------
x,_,_=fancy_figure.bring(path_r,'x',0,0)
z,_,_=fancy_figure.bring(path_r,'z',0,0)
sigm_r,mini_,maxi_=fancy_figure.bring(path_r,'sigm',mini_,maxi_)
# ------------------------------------------------------------------------------
name_='sigm_topo'
struct_=name_
sigm_,_,_=fancy_figure.bring_struct(path_r,name_,struct_,'sigm',0,0)
sigm_=sigm_*1e+3
# ------------------------------------------------------------------------------
sigm_t,_,_=fancy_figure.bring(path_t,'sigm',mini_,maxi_)
circle,_,_=fancy_figure.bring(path_t,'circle',mini_,maxi_)
# ------------------------------------------------------------------------------
print('max sig ',maxi_*1e+3)
print('min sig ',mini_*1e+3)
# ------------------------------------------------------------------------------
mini_s = min(mini_*1e+3,mini_s)
# ------------------------------------------------------------------------------
# borehole
B  = 10 # m
x_ = B  # m
# ------------------------------------------------------------------------------
x_ = np.where(x == x_)
x_ = x_[1][0]
# ------------------------------------------------------------------------------
x = x[0,:]
z = z[0,:]
# ------------------------------------------------------------------------------
sigm_t = 1e+3*sigm_t
sigm_r = 1e+3*sigm_r
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
cx=circle[:,0]
cz=circle[:,1]
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(3,1)
# ------------------------------------------------------------------------------
# borehole
fancy_figure(figsize=size,ax_=ax[0],#aspect=aspect_,
curve=z,x=B*np.ones(z.shape),
extent=extents_,
symbol='--',colop='c',
ax_accu="%.0f",
holdon='on').plotter()
# ------------------------------------------------------------------------------
# sigm
fancy_figure(figsize=size,ax_=ax[0],#aspect=aspect_,
data=sigm_t,
x=x,y=z,extent=extents_,
midi=midi_s,
vmin=mini_s,vmax=maxi_s,
# title='True ER conductivity',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
holdon='on',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
# circle
fancy_figure(figsize=size,ax_=ax[1],#aspect=aspect_,
x=cx,curve=cz,extent=extents_,
symbol='--',colop=((0,0,0)),
holdon='on').plotter()
# ------------------------------------------------------------------------------
# sigm
fancy_figure(figsize=size,ax_=ax[1],#aspect=aspect_,
data=sigm_r,
x=x,y=z,extent=extents_,
midi=midi_s,vmin=mini_s,vmax=maxi_s,
# title='Recovered ER conductivity',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
holdon='on',colorbaron='off',
fig_name='figo').matrix()
# ------------------------------------------------------------------------------
# circle
fancy_figure(figsize=size,ax_=ax[2],#aspect=aspect_,
x=cx,curve=cz,extent=extents_,
symbol='--',colop=((0,0,0)),
holdon='on').plotter()
# ------------------------------------------------------------------------------
# sigm_
fancy_figure(figsize=size,ax_=ax[2],#aspect=aspect_,
data=sigm_,
x=x,y=z,extent=extents_,
midi=midi_s,vmin=mini_s,vmax=maxi_s,
# title='Recovered ER conductivity',
xlabel="Length (m)",ylabel="Depth (m)",
ax_accu="%.0f",
holdon='on',colorbaron='off',
fig_name='figo',
guarda_path=guarda_path,
guarda=dpi).pmatrix()
# ------------------------------------------------------------------------------
# plt_.show()
# ------------------------------------------------------------------------------
# colorbar extra
# ------------------------------------------------------------------------------
fig = plt_.gcf()
plt_.close()
size = fig.get_size_inches()
fancy_figure(midi=midi_s,vmin=mini_s,vmax=maxi_s,colo='ybwrk',
figsize=size,holdon='on',
guarda_path=guarda_path,colo_title='Conductivity (mS/m)',cololabel=15,
guarda=dpi).colorbar_alone()
# ------------------------------------------------------------------------------
# join figures
# ------------------------------------------------------------------------------
im=guarda_path+"figo.png"
im_=guarda_path+"fig.png"
im = fancy_image(im=im).openim()
dpii=im.info['dpi']
nh,_=im.size
im_ = fancy_image(im=im_,nh=nh,nh_r=35*dpi_).padder_h()
im = fancy_image(im=im,im_=im_).concat_v()
# ------------------------------------------------------------------------------
# im.show()
# ------------------------------------------------------------------------------
im.save(guarda_path+'conductivity-sy-'+'.png',"PNG", dpi=dpii)
# ------------------------------------------------------------------------------
plt_.close()
# ------------------------------------------------------------------------------



