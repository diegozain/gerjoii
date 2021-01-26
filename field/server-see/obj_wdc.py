import sys
import numpy as np
sys.path.append('../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
size=[4,6]
guarda_path = "pics/"
dpi=120
# ------------------------------------------------------------------------------
legend_ = [r'$a_w$',r'$a_{dc}$']
# ------------------------------------------------------------------------------
as_,_,_ = fancy_figure.bring('','as',0,0)
# ------------------------------------------------------------------------------
as_= as_[:,:,1:]
aw = as_[0,0,:].squeeze()
adc= as_[0,1,:].squeeze()
Ew = as_[1,0,:].squeeze()
Edc= as_[1,1,:].squeeze()
# ------------------------------------------------------------------------------
iter_ = aw.size
iter_ = np.arange(1.,iter_+1)
# ------------------------------------------------------------------------------
aspect_ = 2 # larger number --> y axis is longer
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(2,1,figsize=size)
# ------------------------------------------------------------------------------
# aw and adc
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],figsize=size,#aspect=aspect_,
curve=aw,x=iter_,
symbol='.-',legends=legend_,
#legend_coord=(10,0.75),
xlabel="Iteration \#",ylabel="Weights",
colop=((0.1,0.5,0.3)),margin=(0.02,0.03),
holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],figsize=size,#aspect=aspect_,
curve=adc,x=iter_,
symbol='.-',legends=legend_,
#legend_coord=(10,0.75),
xlabel="Iteration \#",ylabel="Value",
colop=((0.3882,0.2039,0.6588)),margin=(0.02,0.03),
holdon='on').plotter() 
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[1],figsize=size,#aspect=aspect_,
curve=Ew,x=Edc,
symbol='o',
scatter_colo=iter_,
colo_accu='%2i',
# colo='Greys',
xlabel=r'$\Theta_{dc}$',
ylabel=r'$\Theta_{w,\sigma}$',
colo_title="Iteration \#",
margin=(0.02,0.03),
guarda_path=guarda_path,holdon='on',
guarda=dpi,fig_name="weights").scatterer()
# ------------------------------------------------------------------------------
plt_.show()
# ------------------------------------------------------------------------------
E,_,_ = fancy_figure.bring('','E',0,0)
E=np.squeeze(E)
Ee=2*E-0.5*(Ew+Edc)
size=[4,9]
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(3,1,figsize=size)
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[0],
figsize=size,
curve=Ee,x=Ew,
symbol='o',
scatter_colo=iter_,
colo_accu='%2i',
# colo='Greys',
ylabel=r'$\Theta_{\varepsilon}$',
xlabel=r'$\Theta_{w,\sigma}$',
colo_title="Iteration \#",
margin=(0.02,0.03),holdon='on',
).scatterer()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[1],
figsize=size,
curve=Ee,x=Edc,
symbol='o',
scatter_colo=iter_,
colo_accu='%2i',
# colo='Greys',
ylabel=r'$\Theta_{\varepsilon}$',
xlabel=r'$\Theta_{dc}$',
colo_title="Iteration \#",
margin=(0.02,0.03),holdon='on',
).scatterer()
# ------------------------------------------------------------------------------
fancy_figure(ax_=ax[2],
figsize=size,
curve=Ew,x=Edc,
symbol='o',
scatter_colo=iter_,
colo_accu='%2i',
# colo='Greys',
xlabel=r'$\Theta_{dc}$',
ylabel=r'$\Theta_{w,\sigma}$',
colo_title="Iteration \#",
margin=(0.02,0.03),
guarda_path=guarda_path,#holdon='on',
guarda=dpi,fig_name="objective-fncs").scatterer()
# ------------------------------------------------------------------------------

'''
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
curve=E,
x=iter_,
symbol='.-',
marekrsize=40,
ylabel=r'$\Theta_\varepsilon$',
xlabel='Iteration \#',
colop=((0.1,0.3,0.5)),
margin=(0.03,0.03),
guarda_path=guarda_path,
guarda=dpi,
fig_name='objective-fnc').plotter()
# ------------------------------------------------------------------------------
'''
# ------------------------------------------------------------------------------
bepsx,_,_ = fancy_figure.bring('','bepsx',0,0)
bsigx,_,_ = fancy_figure.bring('','bsigx',0,0)
bepsx=np.squeeze(bepsx)
bsigx=np.squeeze(bsigx)
size=[4,6]
# ------------------------------------------------------------------------------
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
# ------------------------------------------------------------------------------
fig,ax=plt_.subplots(2,1,figsize=size)
# ------------------------------------------------------------------------------
# aw and adc
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax[0],
figsize=size,
curve=aw,
x=iter_,
symbol='.-',
xlabel="Iteration \#",
ylabel="Weights",
colop=((0.1,0.5,0.3)),margin=(0.02,0.03),
holdon='on').plotter()
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax[0],
figsize=size,
curve=adc,
x=iter_,
symbol='.-',
legends=legend_,
#legend_coord=(10,0.75),
xlabel="Iteration \#",
ylabel="Value",
colop=((0.3882,0.2039,0.6588)),margin=(0.02,0.03),
holdon='on').plotter() 
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax[1],
figsize=size,
curve=bepsx[1:],
x=iter_[1:],
symbol='.-',
markersize=10,
colop=((0.4,0.6,1)),
holdon='on'
).plotter()
# ------------------------------------------------------------------------------
fancy_figure(
ax_=ax[1],
figsize=size,
curve=bsigx,
x=iter_[1:],
symbol='.-',
legends=[r'$b_{\varepsilon_r}$',r'$b_\sigma$'],
xlabel="Iteration \#",
ylabel="Value",
colop=((1,0.4,0)),
margin=(0.02,0.03),
guarda_path=guarda_path,
guarda=dpi,
fig_name='joix-weights'
).plotter()
# ------------------------------------------------------------------------------