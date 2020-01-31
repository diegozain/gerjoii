import sys
sys.path.append('../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import numpy as np
# ------------------------------------------------------------------------------
size   =[6.41*0.75,6.41*1]
colors = [(0,0,0),(0.5,0.5,0.5),(0.8,0.8,0.8)]
aspect_= 'auto'
margin=(0.04,0.04)
# ------------------------------------------------------------------------------
guarda_path = "pics/"
# ------------------------------------------------------------------------------
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
dpi = 120*dpi_
# ------------------------------------------------------------------------------
mo_le = input('more or less? ')
# ------------------------------------------------------------------------------
path_  = 'mat-files/'
# ------------------------------------------------------------------------------
if mo_le=='less':
    names_ = ['sand_dry','sand_moist','sand_wet']
elif mo_le=='more':
    names_ = ['silty_loam','clay_wet','brine_wet']
# ------------------------------------------------------------------------------
# legends_= ['Dry sand','Moist sand','Wet sand']
# ------------------------------------------------------------------------------
f,_,_ = fancy_figure.bring_struct(path_,names_[0],'material','f',0,0)
nf = f.size
alph = np.zeros((nf,len(names_)))
alph_dc = np.zeros((nf,len(names_)))
epsi = np.zeros((nf,len(names_)))
sigm_w= np.zeros((nf,len(names_)))
sigm_dc  = np.zeros((len(names_)))
# ------------------------------------------------------------------------------
for i_ in range(0,len(names_)):
    alph_,_,_   = fancy_figure.bring_struct(path_,names_[i_],'material','alph',0,0)
    alph_dc_,_,_   = fancy_figure.bring_struct(path_,names_[i_],'material','alph_dc',0,0)
    epsi_,_,_   = fancy_figure.bring_struct(path_,names_[i_],'material','epsi',0,0)
    sigm_w_,_,_ = fancy_figure.bring_struct(path_,names_[i_],'material','sigm_w',0,0)
    sigm_dc_,_,_= fancy_figure.bring_struct(path_,names_[i_],'material','sigm_dc',0,0)
    alph[:,i_]  = np.squeeze(alph_)
    alph_dc[:,i_]  = np.squeeze(alph_dc_)
    epsi[:,i_]  = np.squeeze(epsi_)
    sigm_w[:,i_]= np.squeeze(sigm_w_)
    sigm_dc[i_] = sigm_dc_
# ------------------------------------------------------------------------------
sigm_dc= sigm_dc*1e+3
sigm_w = sigm_w*1e+3
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(2,1,figsize=size)
# ------------------------------------------------------------------------------
# conductivity
# ------------------------------------------------------------------------------
for i_ in range(0,len(names_)-1):
    fancy_figure(ax_=ax[0],figsize=size,aspect=aspect_,
    curve=sigm_w[:,i_],x=f,
    symbol='-',
    # legends=legends_,#legend_coord=(10,0.75),
    xlabel="Frequency (MHz)",ylabel='Conductivity (mS/m)',
    colop=colors[i_],margin=margin,
    holdon='on').plotter()
    # --------------------------------------------------------------------------
    fancy_figure(ax_=ax[0],figsize=size,aspect=aspect_,
    curve=sigm_dc[i_]*np.ones(f.shape),x=f,
    symbol='--',
    # legends=legends_,#legend_coord=(10,0.75),
    xlabel="Frequency (MHz)",ylabel='Conductivity (mS/m)',
    colop=colors[i_],margin=margin,
    holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],figsize=size,aspect=aspect_,
curve=sigm_dc[len(names_)-1]*np.ones(f.shape),x=f,
symbol='--',
# legends=legends_,#legend_coord=(10,0.75),
xlabel="Frequency (MHz)",ylabel='Conductivity (mS/m)',
colop=colors[len(names_)-1],margin=margin,
holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],figsize=size,aspect=aspect_,
curve=sigm_w[:,len(names_)-1],x=f,
symbol='-',
# legends=legends_,#legend_coord=(10,0.75),
xlabel="Frequency (MHz)",ylabel='Conductivity (mS/m)',
colop=colors[len(names_)-1],margin=margin,
holdon='on').plotter()
# ------------------------------------------------------------------------------
# attenuation
# ------------------------------------------------------------------------------
for i_ in range(0,len(names_)-1):
    fancy_figure(ax_=ax[1],figsize=size,aspect=aspect_,
    curve=alph[:,i_],x=f,
    symbol='-',
    # legends=legends_,#legend_coord=(10,0.75),
    xlabel="Frequency (MHz)",ylabel='Attenuation (1/m)',
    colop=colors[i_],margin=margin,
    holdon='on').plotter()
    # --------------------------------------------------------------------------
    fancy_figure(ax_=ax[1],figsize=size,aspect=aspect_,
    curve=alph_dc[:,i_],x=f,
    symbol='--',
    # legends=legends_,#legend_coord=(10,0.75),
    xlabel="Frequency (MHz)",ylabel='Attenuation (1/m)',
    colop=colors[i_],margin=margin,
    holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[1],figsize=size,aspect=aspect_,
curve=alph_dc[:,len(names_)-1],x=f,
symbol='--',
# legends=legends_,#legend_coord=(10,0.75),
xlabel="Frequency (MHz)",ylabel='Attenuation (1/m)',
colop=colors[len(names_)-1],margin=margin,
holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[1],figsize=size,aspect=aspect_,
curve=alph[:,len(names_)-1],x=f,
symbol='-',
# legends=legends_,#legend_coord=(10,0.75),
xlabel="Frequency (MHz)",ylabel='Attenuation (1/m)',
colop=colors[len(names_)-1],margin=margin,
guarda_path=guarda_path,holdon='on',
guarda=dpi,fig_name='sigm-freq-'+mo_le).plotter()
# ------------------------------------------------------------------------------
# plt_.show()
# ------------------------------------------------------------------------------

