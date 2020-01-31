import numpy as np
import torch
# ------------------------------------------------------------------------------
# paths
path_data = '../data/'
path_mach ='../machines/'
# ------------------------------------------------------------------------------
# files
x = path_data + 'E_.txt'
# ------------------------------------------------------------------------------
# load -> numpy -> transpose -> pytorch
x = np.loadtxt(x,delimiter=' ',dtype='double')
x = x[None,:]
x = torch.from_numpy(x)
# ------------------------------------------------------------------------------
# load learning machine
mlp = torch.load(path_mach+'i-am-a-mlp-machine.pt')
# ------------------------------------------------------------------------------
# run
y = mlp(x)
y = y.t()
print('\n',y,'\n')
# ------------------------------------------------------------------------------
# save
y=y.data.numpy()
np.savetxt(path_data+'p_new.txt',y,delimiter=' ')