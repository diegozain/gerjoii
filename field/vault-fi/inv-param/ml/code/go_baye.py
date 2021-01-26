import sys
sys.path.append('../../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
import os
from data_baye import *
from bayesian_opti import *
# ------------------------------------------------------------------------------
np.random.seed(seed=0)
# ------------------------------------------------------------------------------
# paths
path_data = '../data/'
iruns_ = 10
size=[5,5]
dpi=200
guarda_path='../pics/'
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
bounds = np.array([\
[0,0.1],[0,0.1],\
[0.5,0.9],[1,10],[1,5],[1,5],[0.001,1],\
[0,0.1],[0,0.1],[0,0.1],[0,0.1],\
[1,10]])
# ------------------------------------------------------------------------------
x_ = optimize_baye(x,y,bounds)
# ------------------------------------------------------------------------------
# plot something??
# '''
nruns,_=x.shape
# plot the runs
for iruns in range(0,nruns):
	fancy_figure(
	figsize=size,
	curve=x[iruns,:],
	symbol='o-',
	markersize=5,
	# colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	# colop=(1/(iruns+5),1/(iruns+5),1/(iruns+5)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
fancy_figure(
figsize=size,
curve=np.zeros((np_,)),
symbol='--',
colop=(0.8,0.8,0.8),
margin=(0.05,0.05),
holdon='on'
).plotter()	

fancy_figure(
figsize=size,
curve=x_.reshape(-1,1),
symbol='*-',
markersize=10,
colop='k',
title='Inversion parameters',
xticks=[r'$\beta_\varepsilon$',r'$\beta_\sigma$',r'$a_{dc\bullet}$',r'$\dot{a}_{dc}$',r'$\dot{\Theta}_{dc}$',r'$\dot{a}_w$',r'$\dot{\Theta}_{w,\sigma}$',r'$h_\varepsilon$',r'$d_\varepsilon$',r'$h_\sigma$',r'$d_\sigma$',r'$\alpha_{dc}$'],
# xlabel=r'Parameter',
ylabel=r'Value',
margin=(0.05,0.05),
# legends= ['true','estimated'],
guarda_path=guarda_path,
guarda=dpi,
fig_name='param-bayes'
).plotter()
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
x=np.arange(1,y.size+1,1),
curve=np.log10(y),
margin=(0.05,0.05),
symbol='.-',
colop='r',
markersize=15,
xlabel='Iteration \#',
ylabel=r'$\log_{10}\,\Psi(\Theta)$',
title='Objective Function History'
).plotter()
# ------------------------------------------------------------------------------
# '''
# ------------------------------------------------------------------------------
# save
save_ = input(" Do you want to save these parameters (y or n):  ")
if save_=='y':
    np.savetxt(path_data+'p_new.txt',y,newline=' ')
    
    p_inv,_,_=fancy_figure.bring('../../all/','p_inv'+str(iruns_),0,0,name__='p_inv')
    p_inv = np.squeeze(p_inv)
    
	# # all param in the list below
    # p_inv[9] = y[0]
    # p_inv[10] = y[1]
    # p_inv[14:26] = y[2:14]
	
	# all but the first two in the list above
    p_inv[14:26] = x_
    
    np.savetxt(path_data+'p_new_.txt',p_inv,newline=' ',fmt='%2.2e')
    print('\n')
    os.system('cat ../data/p_new_.txt')
print('\n')
# ------------------------------------------------------------------------------

