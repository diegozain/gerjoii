import sys
sys.path.append('../../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
# epsi manual & sigm homogeneous
runs = np.asarray([2])
nparam = 12 	# number of inversion hyper-parameters
ni = 4 		# number of iterations per run
fact_ = 1.08 	# factor to stretch obj funcs and get target
# ------------------------------------------------------------------------------
nruns = len(runs)
iter_ = np.arange(1.,ni+1)
size  = [4,4]
dpi   = 200
path_ = '../../all/'
path_o= '../data/'
guarda_path='../pics/'
# ------------------------------------------------------------------------------
EE = np.zeros((nruns,ni*3))
P  = np.zeros((nruns,nparam))
Psi= np.zeros((nruns,))
print('\n\n # of: inversion runs and parameters: ',P.shape)
# ------------------------------------------------------------------------------
# load data 
for iruns in range(0,nruns):
	iruns_ = runs[iruns]
	
	p_inv,_,_=fancy_figure.bring(path_,'p_inv'+str(iruns_),0,0,name__='p_inv')
	as_,_,_  =fancy_figure.bring(path_,'as'+str(iruns_),0,0,name__='as')
	Ee,_,_  =fancy_figure.bring(path_,'E'+str(iruns_),0,0,name__='E')
	
	as_ = np.delete(as_,[0,0],axis=2)
	
	if as_.shape[2] < ni:
		print('\n\n 	inversion run ',iruns_,' does not have enough iterations, \n		...it only has ',as_.shape[2])
		break
	
	Ee  = np.squeeze(Ee)
	Ee  = Ee[0:ni]
	Ews = as_[1,0,0:ni]
	Edc = as_[1,1,0:ni]
	Ews = np.squeeze(Ews)
	Edc = np.squeeze(Edc)

	Psi[iruns] = Ee[ni-1]

	Ee  = 2*Ee - 0.5*(Ews+Edc)
	
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
# build the run we want to imitate
E_=EE.min(0)
Ee_  = E_[0]
Ew_  = E_[ni]
Edc_ = E_[2*ni]

E_[0:ni] = E_[0:ni]-Ee_;
E_[ni:(ni*2)] = E_[ni:(ni*2)]-Ew_;
E_[(ni*2):(ni*3)] = E_[(ni*2):(ni*3)]-Edc_;

E_ = E_*fact_

E_[0:ni] = E_[0:ni]+Ee_;
E_[ni:(ni*2)] = E_[ni:(ni*2)]+Ew_;
E_[(ni*2):(ni*3)] = E_[(ni*2):(ni*3)]+Edc_;
# ------------------------------------------------------------------------------
Ee_ = np.linspace(E_[0],np.amin(E_[0:ni]),ni)
Ew_ = np.linspace(E_[ni],np.amin(E_[ni:ni*2]),ni)
Edc_= np.linspace(E_[ni*2],np.amin(E_[ni*2:ni*3]),ni)
E_  = np.concatenate((Ee_,Ew_,Edc_),0)
# ------------------------------------------------------------------------------
Psi = EE - np.tile(E_,(nruns,1))
Psi = np.sum(Psi**2,1)
Psi = np.sqrt(Psi)
# ------------------------------------------------------------------------------
# plot the runs
size=[4,9]
plt_=fancy_figure(data=np.zeros((2,2)),holdon='close',colorbaron='off').matrix()
fig,ax=plt_.subplots(3,1,figsize=size)
# ------------------------------------------------------------------------------
for iruns in range(0,nruns):
	fancy_figure(
	ax_=ax[0],
	figsize=size,
	x=EE[iruns,ni:(ni*2)],
	curve=EE[iruns,0:ni],
	symbol='o-',
	colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
	fancy_figure(
	ax_=ax[1],
	figsize=size,
	x=EE[iruns,(ni*2):(ni*3)],
	curve=EE[iruns,0:ni],
	symbol='o-',
	colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
	fancy_figure(
	ax_=ax[2],
	figsize=size,
	x=EE[iruns,(ni*2):(ni*3)],
	curve=EE[iruns,ni:(ni*2)],
	symbol='o-',
	colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()

# plot the run we want to imitate
fancy_figure(
ax_=ax[0],
figsize=size,
x=E_[ni:(ni*2)],
curve=E_[0:ni],
symbol='o-',
colop='r',
margin=(0.05,0.05),
title='Inversion runs',
ylabel=r'$\Theta_{\varepsilon}$',
xlabel=r'$\Theta_{w,\sigma}$',
holdon='on'
).plotter()

fancy_figure(
ax_=ax[1],
figsize=size,
x=E_[(ni*2):(ni*3)],
curve=E_[0:ni],
symbol='o-',
colop='r',
margin=(0.05,0.05),
ylabel=r'$\Theta_{\varepsilon}$',
xlabel=r'$\Theta_{dc}$',
holdon='on'
).plotter()

fancy_figure(
ax_=ax[2],
figsize=size,
x=E_[(ni*2):(ni*3)],
curve=E_[ni:(ni*2)],
symbol='o-',
colop='r',
margin=(0.05,0.05),
xlabel=r'$\Theta_{dc}$',
ylabel=r'$\Theta_{w,\sigma}$',
guarda_path=guarda_path,
guarda=dpi,
fig_name='inversion_runs_'
).plotter()
# ------------------------------------------------------------------------------
fancy_figure(
figsize=[4,4],
curve=Psi,
x=np.arange(1,nruns+1,1),
symbol='o-',
colop='r',
margin=(0.05,0.05),
xlabel=r'Inversion Run \#',
ylabel=r'$\Psi(\Theta)$',
title='Inception Objective Function',
guarda_path=guarda_path,
guarda=dpi,
fig_name='inversion_inception'
).plotter()
# ------------------------------------------------------------------------------
save_ = input("\n Do you want to save these as .npy? (y or n):  ")
if save_=='y':
	# save
	np.save(path_o+'EE',EE)
	np.save(path_o+'P',P)
	np.save(path_o+'E_',E_)
	np.save(path_o+'Psi',Psi)
	print('	ok, I just saved your parameters.')
else:
	print('	ok, whatever.')
print('\n')
# ------------------------------------------------------------------------------
