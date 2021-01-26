import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
import numpy as np
# ------------------------------------------------------------------------------
# from all subsurface models,
# 
# 1. max and min
# 2. make a picture of the models and the receivers
# ------------------------------------------------------------------------------
n_models = 48
name_    = 'model'
# ------------------------------------------------------------------------------
colo  = 'ybwrk' # 'plasma'
colo_e= 'kb'#colo
colo_s= 'kgr'#colo
# ------------------------------------------------------------------------------
pathi__= input ("train or test or estimated: ")
# ------------------------------------------------------------------------------
if pathi__=='estimated':
    esti   ='_esti'
    path__ = '../data-set/test/'
else:
    esti=''
    path__ = '../data-set/' + pathi__ + '/'
# ------------------------------------------------------------------------------
guarda_path = '../pics-ml/pics-models-compare/'+pathi__+'/'
# ------------------------------------------------------------------------------
dpi      = 200
size     = [5,3]
# ------------------------------------------------------------------------------
#                       get max and min
# ------------------------------------------------------------------------------
eps_, mini_e, maxi_e = fancy_figure.bring_struct(
                        '../mat-file/','discreti_','discreti_','eps_',
                        float('Inf'),-float('Inf'))
midi_e = 0.5*(maxi_e-mini_e) + mini_e
# ------------------------------------------------------------------------------
sig_, mini_s, maxi_s = fancy_figure.bring_struct(
                        '../mat-file/','discreti_','discreti_','sig_',
                        float('Inf'),-float('Inf'))
midi_s = 0.5*(maxi_s-mini_s) + mini_s
# ------------------------------------------------------------------------------
mini_s = mini_s*1e+3
maxi_s = maxi_s*1e+3
midi_s = midi_s*1e+3
# ------------------------------------------------------------------------------
#                       get x and z
# ------------------------------------------------------------------------------
x,_,_ = fancy_figure.bring_struct(
                        '../mat-file/','discreti_','discreti_','x',
                        0,0)
z,_,_ = fancy_figure.bring_struct(
                        '../mat-file/','discreti_','discreti_','z',
                        0,0)
x = x[0,:]
z = z[0,:]
extents_ = [x[0],x[-1],z[-1],z[0]]
# ------------------------------------------------------------------------------
#                       get receivers
# ------------------------------------------------------------------------------
# bring receivers and sources -- gpr
sr_w_ =fancy_figure.bring_cell('../mat-file/','s_r_')
ishot = 1
rx_   = sr_w_[ishot-1,1]
sx_w  = sr_w_[ishot-1,0][0][1]
nrx   = rx_.shape[0]
rx_w  = np.ones(nrx,dtype=int)
for i_ in range(0,nrx):
    rx_w[i_] = rx_[i_][0]
rx_w=x[rx_w-1]
sx_w=x[sx_w-1]
# ------------------------------------------------------------------------------
# make receivers and sources -- er
rx_dc = np.arange(2,34,1,dtype=float)
# ------------------------------------------------------------------------------
for im in range(1,n_models+1):
    path_ = path__ + str(im) + '/'
    # --------------------------------------------------------------------------
    #                   models
    # --------------------------------------------------------------------------
    epsi,_,_=fancy_figure.bring(path_,'epsi'+esti,0,0)
    sigm,_,_=fancy_figure.bring(path_,'sigm'+esti,0,0)
    # --------------------------------------------------------------------------
    # have to initialize plt_ like this for some reason
    plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
    # --------------------------------------------------------------------------
    fig,(ax1,ax2)=plt_.subplots(2,1)
    # --------------------------------------------------------------------------
    # # wave recs and source
    # fancy_figure(
    #     ax_=ax1,figsize=size,
    #     curve=-0.7,x=sx_w,
    #     colop='w',
    #     symbol='.',holdon='on'
    #     ).plotter()
    # fancy_figure(ax_=ax1,figsize=size,
    #     curve=0*np.ones(rx_w.shape),x=rx_w,
    #     colop='c',
    #     symbol='.',markersize=2,
    #     holdon='on'
    #     ).plotter()
    # fancy_figure(ax_=ax1,figsize=size,
    #     curve=0,x=sx_w,
    #     colop='r',markersize=10,
    #     symbol='*',holdon='on'
    #     ).plotter()
    # --------------------------------------------------------------------------
    # permittivity
    fancy_figure(
        ax_=ax1,figsize=size,
        data=epsi,
        x=x,y=z,extent=extents_,
        x_ticklabels='off',
        y_ticklabels='off',
        midi=midi_e,vmin=mini_e,vmax=maxi_e,
        holdon='on',
        no_frame='on',
        colorbaron='off',
        colo=colo_e
        ).matrix()
    # --------------------------------------------------------------------------
    # plt_.text(x[-1]*0.5,z[-1]*0.5,str(im),fontsize=50,color='white')
    # --------------------------------------------------------------------------
    # # dc recs and source
    # fancy_figure(
    #     ax_=ax2,figsize=size,
    #     curve=-0.7,x=sx_w,
    #     colop='w',
    #     symbol='.',holdon='on'
    #     ).plotter()
    # fancy_figure(ax_=ax2,figsize=size,
    #     curve=0.1*np.ones(rx_dc.shape),x=rx_dc,
    #     colop=(0.6941,0.2039,0.9216),
    #     symbol='v',holdon='on'
    #     ).plotter()
    # --------------------------------------------------------------------------
    # conductivity
    fancy_figure(
        ax_=ax2,figsize=size,
        data=sigm*1e+3,
        x=x,y=z,extent=extents_,
        midi=midi_s,vmin=mini_s,vmax=maxi_s,
        colorbaron='off',holdon='on',
        x_ticklabels='off',
        y_ticklabels='off',
        colo=colo_s,
        no_frame='on',
        guarda_path=guarda_path,
        guarda=dpi,
        fig_name=name_+str(im)
        ).matrix()
    # --------------------------------------------------------------------------
    plt_.close()
    # --------------------------------------------------------------------------
    print('just finished your pics for model ',im)
# ------------------------------------------------------------------------------
# !sips -g all tmp/line1.png
# ------------------------------------------------------------------------------
# colorbars extra
# ------------------------------------------------------------------------------
# have to initialize plt_ like this for some reason
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fancy_figure(
midi=midi_e,vmin=mini_e,vmax=maxi_e,
colo=colo_e,
colo_title='Permittivity ( )',
figsize=size,
holdon='on',
guarda_path='../pics-ml/pics-models-compare/',
fig_name='colo_e',
guarda=dpi).colorbar_alone()
# ------------------------------------------------------------------------------
fancy_figure(
midi=midi_s,vmin=mini_s,vmax=maxi_s,
colo=colo_s,
colo_title='Conductivity (mS/m)',
figsize=size,
holdon='on',
guarda_path='../pics-ml/pics-models-compare/',
fig_name='colo_s',
guarda=dpi).colorbar_alone()
# ----------------------------------------------------------------------------
# join figures
# ----------------------------------------------------------------------------
im   = '../pics-ml/pics-models-compare/colo_e.png'
im_  = '../pics-ml/pics-models-compare/colo_s.png'
im   = fancy_image(im=im).openim()
dpii = im.info['dpi']
nh,nv= im.size
im   = fancy_image(im=im,nh=nh+200,nh_r=200).padder_h()
im   = fancy_image(im=im,im_=im_).concat_h()
# im.show()
im.save('../pics-ml/pics-models-compare/colors.png',"PNG", dpi=dpii)
# ----------------------------------------------------------------------------

