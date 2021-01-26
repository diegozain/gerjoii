import sys
sys.path.append('../../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
# ------------------------------------------------------------------------------
# epsi manual & sigm homogeneous
runs = np.asarray([2])
nparam = 12 	# number of inversion hyper-parameters
ni = 15 		# number of iterations per run
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
EE = np.zeros((nruns,ni*2))
P  = np.zeros((nruns,nparam))
print('\n\n # of: inversion runs and parameters: ',P.shape)
# ------------------------------------------------------------------------------
# load data 
for iruns in range(0,nruns):
	iruns_ = runs[iruns]
	
	p_inv,_,_=fancy_figure.bring(path_,'p_inv'+str(iruns_),0,0,name__='p_inv')
	as_,_,_  =fancy_figure.bring(path_,'as'+str(iruns_),0,0,name__='as')
	
	as_ = np.delete(as_,[0,0],axis=2)
	
	if as_.shape[2] < ni:
		print('\n\n 	inversion run ',runs[iruns],' does not have enough iterations, \n		...it only has ',as_.shape[2])
		break
	
	Ews = as_[1,0,0:ni]
	Edc = as_[1,1,0:ni]
	
	p_inv = np.squeeze(p_inv)	
	
	# # all param in the list below
	# p_inv = p_inv[9:26]
	# p_inv = np.delete(p_inv,np.s_[2:5])
	
	# all but the first two in the list below
	p_inv = p_inv[14:26]
	
	EE[iruns,:] = np.concatenate((Ews,Edc),0)
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
Edc_ = E_[ni]
Ew_  = E_[0]
E_[ni:(ni*2)] = E_[ni:(ni*2)]-Edc_;
E_[0:ni] = E_[0:ni]-Ew_;
E_ = E_*fact_
E_[ni:(ni*2)] = E_[ni:(ni*2)]+Edc_
E_[0:ni] = E_[0:ni]+Ew_;
# ------------------------------------------------------------------------------
# Ews = np.linspace(E_[0],E_[ni-1],ni)
# Edc = np.linspace(E_[ni],E_[ni*2-1],ni)
# E_  = np.concatenate((Ews,Edc),0)
# ------------------------------------------------------------------------------
# plot the runs
for iruns in range(0,nruns):
	fancy_figure(figsize=size,
	x=EE[iruns,ni:(ni*2)],
	curve=EE[iruns,0:ni],
	symbol='o-',
	colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
# plot the run we want to imitate
fancy_figure(figsize=size,
x=E_[ni:(ni*2)],
curve=E_[0:ni],
symbol='o-',
colop='r',
title='Inversion runs',
xlabel=r'$\Theta_{dc}$',
ylabel=r'$\Theta_{w,\sigma}$',
margin=(0.05,0.05),
guarda_path=guarda_path,
guarda=dpi,
fig_name='inversion_runs'
).plotter()
# ------------------------------------------------------------------------------
save_ = input("\n Do you want to save these as .npy? (y or n):  ")
if save_=='y':
	# save
	np.save(path_o+'EE',EE)
	np.save(path_o+'P',P)
	np.save(path_o+'E_',E_)
	print('	ok, I just saved your parameters.')
else:
	print('	ok, whatever.')
print('\n')
# ------------------------------------------------------------------------------
