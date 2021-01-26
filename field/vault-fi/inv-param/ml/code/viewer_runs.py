import sys
sys.path.append('../../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
# inversion runs
runs = np.asarray([10,11,12,13,14,15,16,17,18,19,20,21])
nparam = 12 	# number of inversion hyper-parameters
ni = 80 		# number of iterations per run
fact_ = 1.08 	# factor to stretch obj funcs and get target
ni_= ni
# ------------------------------------------------------------------------------
nruns = len(runs)
iter_ = np.arange(1.,ni+1)
size  = [4,4]
dpi   = 200
path_ = '../../all/'
path_o= '../data/'
guarda_path='../pics/'
# ------------------------------------------------------------------------------
EE = np.empty((nruns,ni*3))
P  = np.empty((nruns,nparam))
EE[:]  = np.nan
P[:]   = np.nan
print('\n\n # of: inversion runs and parameters: ',P.shape)
# ------------------------------------------------------------------------------
# load data 
for iruns in range(0,nruns):
	iruns_ = runs[iruns]
	
	p_inv,_,_=fancy_figure.bring(path_,'p_inv'+str(iruns_),0,0,name__='p_inv')
	as_,_,_  =fancy_figure.bring(path_,'as'+str(iruns_),0,0,name__='as')
	Ee,_,_   =fancy_figure.bring(path_,'E'+str(iruns_),0,0,name__='E')
	
	as_ = np.delete(as_,[0,0],axis=2)
	
	if as_.shape[2] < ni:
		ni = as_.shape[2]
		print('\n\n 	inversion run ',iruns_,' does not have enough iterations, \n		...it only has ',as_.shape[2])
		# break
	
	Ee  = np.squeeze(Ee)
	Ee  = Ee[0:ni]
	Ews = as_[1,0,0:ni]
	Edc = as_[1,1,0:ni]
	Ews = np.squeeze(Ews)
	Edc = np.squeeze(Edc)

	Ee  = 2*Ee - 0.5*(Ews+Edc)
	
	if ni<ni_:
		E_nan = np.empty((ni_-ni,))
		E_nan[:] = np.nan
		Ee = np.concatenate((Ee,E_nan),0)
		Ews = np.concatenate((Ews,E_nan),0)
		Edc = np.concatenate((Edc,E_nan),0)
		
		ni = ni_
		
	p_inv = np.squeeze(p_inv)	
	
	# # all param in the list below
	# p_inv = p_inv[9:26]
	# p_inv = np.delete(p_inv,np.s_[2:5])
	
	# all but the first two in the list below
	p_inv = p_inv[14:26]
	
	EE[iruns,:] = np.concatenate((Ee,Ews,Edc),0)
	P[iruns,:] = p_inv
# ------------------------------------------------------------------------------
# # the parameters to be found are (in that order):
# 
# dc
# # beta_dc
# # momentum_dc
# 
# w envelope 
# # g_e_weight
# # g_s_weight
# 
# joint
# # adc_
# # da_dc
# # dEdc
# # da_w
# # dEw
# 
# xgrad eps
# # h_eps
# # d_eps
# 
# xgrad sig
# # h_sig
# # d_sig
# 
# joint step size
# # step_
# ------------------------------------------------------------------------------
# plot the runs
size=[4,9]
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,ax=plt_.subplots(3,1,figsize=size)
# ------------------------------------------------------------------------------
for iruns in range(0,nruns-1):
	fancy_figure(
	ax_=ax[0],
	figsize=size,
	x=EE[iruns,ni:(ni*2)],
	curve=EE[iruns,0:ni],
	symbol='o-',
	markersize= nruns-iruns,
	# colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
	fancy_figure(
	ax_=ax[1],
	figsize=size,
	x=EE[iruns,(ni*2):(ni*3)],
	curve=EE[iruns,0:ni],
	symbol='o-',
	markersize= nruns-iruns,
	# colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
	fancy_figure(
	ax_=ax[2],
	figsize=size,
	x=EE[iruns,(ni*2):(ni*3)],
	curve=EE[iruns,ni:(ni*2)],
	symbol='o-',
	markersize= nruns-iruns,
	# colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()

# plot the last run
fancy_figure(
ax_=ax[0],
figsize=size,
x=EE[nruns-1,ni:(ni*2)],
curve=EE[nruns-1,0:ni],
symbol='o-',
markersize= nruns-iruns,
margin=(0.05,0.05),
title='Inversion runs',
ylabel=r'$\Theta_{\varepsilon}$',
xlabel=r'$\Theta_{w,\sigma}$',
holdon='on'
).plotter()

fancy_figure(
ax_=ax[1],
figsize=size,
x=EE[nruns-1,(ni*2):(ni*3)],
curve=EE[nruns-1,0:ni],
symbol='o-',
markersize= nruns-iruns,
margin=(0.05,0.05),
ylabel=r'$\Theta_{\varepsilon}$',
xlabel=r'$\Theta_{dc}$',
holdon='on'
).plotter()

fancy_figure(
ax_=ax[2],
figsize=size,
x=EE[nruns-1,(ni*2):(ni*3)],
curve=EE[nruns-1,ni:(ni*2)],
symbol='o-',
markersize= nruns-iruns,
margin=(0.05,0.05),
xlabel=r'$\Theta_{dc}$',
ylabel=r'$\Theta_{w,\sigma}$',
guarda_path=guarda_path,
guarda=dpi,
fig_name='inversion_runs'
).plotter()
# ------------------------------------------------------------------------------
size=[5,5]
# plot the parameters of the runs
for iruns in range(0,nruns):
	fancy_figure(
	figsize=size,
	curve=P[iruns,:],
	symbol='o-',
	markersize= nruns-iruns, #5,
	# colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	# colop=(1/(iruns+5),1/(iruns+5),1/(iruns+5)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
fancy_figure(
figsize=size,
curve=np.zeros((nparam,)),
symbol='--',
colop=(0.8,0.8,0.8),
title='Inversion parameters',
xticks=[r'$\beta_\varepsilon$',r'$\beta_\sigma$',r'$a_{dc\bullet}$',r'$\dot{a}_{dc}$',r'$\dot{\Theta}_{dc}$',r'$\dot{a}_w$',r'$\dot{\Theta}_{w,\sigma}$',r'$h_\varepsilon$',r'$d_\varepsilon$',r'$h_\sigma$',r'$d_\sigma$',r'$\alpha_{dc}$'],
# xlabel=r'Parameter',
ylabel=r'Value',
margin=(0.05,0.05),
# legends= ['true','estimated'],
guarda_path=guarda_path,
guarda=dpi,
fig_name='parames'
).plotter()
# ------------------------------------------------------------------------------
