import numpy as np
import torch
# ------------------------------------------------------------------------------
# paths
path_ = '../data/'
# ------------------------------------------------------------------------------
# files
Xo = path_ + 'EE.txt'
Yo = path_ + 'p.txt'
# ------------------------------------------------------------------------------
# load & convert to numpy
Xo = np.loadtxt(Xo,delimiter=' ',dtype='double')
Yo = np.loadtxt(Yo,delimiter=' ',dtype='double')
# ------------------------------------------------------------------------------
# get parameters: nx, ny, nruns, np, ni:
# Xo is a matrix of size (nruns x 2ni)
# Yo is a matrix of size (nruns x np)
# so nx=2ni, ny=np
nruns,nx = Xo.shape
nruns,ny = Yo.shape
runs_ = range(nruns)
print('\n\n\n     sizes of input, ouput and # of data samples: ' ,  nx,ny,nruns)
print('\n\n')
# ------------------------------------------------------------------------------
# make pytorch tensor
Xo = torch.from_numpy(Xo)
Yo = torch.from_numpy(Yo)
# ------------------------------------------------------------------------------
