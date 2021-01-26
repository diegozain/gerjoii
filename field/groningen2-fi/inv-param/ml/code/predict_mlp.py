import sys
sys.path.append('../../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import numpy as np
import torch
import os
# ------------------------------------------------------------------------------
iruns_ = 2
size=[4,4]
dpi=200
guarda_path='../pics/'
# ------------------------------------------------------------------------------
# paths
path_data = '../data/'
path_mach ='../machines/'
# ------------------------------------------------------------------------------
# files
# x = path_data + 'E_.txt'
x = path_data + 'E_.npy'
Yo = path_data + 'P.npy'
# ------------------------------------------------------------------------------
# load -> numpy -> transpose -> pytorch
# x = np.loadtxt(x,delimiter=' ',dtype='double')
x = np.load(x)
x = x[None,:]
x = torch.from_numpy(x)
# ------------------------------------------------------------------------------
# load learning machine
mlp = torch.load(path_mach+'i-am-a-mlp-machine.pt')
# ------------------------------------------------------------------------------
# run
y = mlp(x)
y = y.t()
y = y.data.numpy()
print('\n',y,'\n')
# ------------------------------------------------------------------------------
# '''
Yo = np.load(Yo)
nruns,_=Yo.shape
# plot the runs
for iruns in range(0,nruns):
	fancy_figure(
	figsize=size,
	x=np.arange(1,y.size+1,1),
	curve=Yo[iruns,:],
	symbol='o-',
	markersize=10,
	colop=(1/(nruns-iruns+1.1),1/(nruns-iruns+1.1),1/(nruns-iruns+1.1)),
	# colop=(1/(iruns+5),1/(iruns+5),1/(iruns+5)),
	margin=(0.05,0.05),
	holdon='on'
	).plotter()
	
fancy_figure(
figsize=size,
x=np.arange(1,y.size+1,1),
curve=np.zeros(y.size),
symbol='--',
colop=(0.8,0.8,0.8),
margin=(0.05,0.05),
holdon='on'
).plotter()	

fancy_figure(
figsize=size,
x=np.arange(1,y.size+1,1),
curve=y,
symbol='o-',
colop='r',
title='Inversion parameters',
xlabel=r'Parameter \#',
ylabel=r'Value',
margin=(0.05,0.05),
# legends= ['true','estimated'],
guarda_path=guarda_path,
guarda=dpi,
fig_name='param-mlp'
).plotter()
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
    p_inv[14:26] = y
    
    np.savetxt(path_data+'p_new_.txt',p_inv,newline=' ',fmt='%2.2e')
    print('\n')
    os.system('cat ../data/p_new_.txt')
print('\n')
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
