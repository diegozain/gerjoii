import numpy as np
import torch
# ------------------------------------------------------------------------------
# paths
path_ = '../data/'
# ------------------------------------------------------------------------------
# # files
# Xo = path_ + 'EE.txt'
# Yo = path_ + 'P.txt'
# # ---------------------------------------------------------------------------
# # load & convert to numpy
# Xo = np.loadtxt(Xo,delimiter=' ',dtype='double')
# Yo = np.loadtxt(Yo,delimiter=' ',dtype='double')
# ------------------------------------------------------------------------------
# files
Xo = path_ + 'EE.npy'
Yo = path_ + 'P.npy'
# ------------------------------------------------------------------------------
# load & convert to numpy
Xo = np.load(Xo)
Yo = np.load(Yo)
# ------------------------------------------------------------------------------
# get parameters: nx, ny, nruns, np, ni:
# Xo is a matrix of size (nruns x 2ni)
# Yo is a matrix of size (nruns x np)
# so nx=3*ni, ny=np
nruns,nx = Xo.shape
nruns,ny = Yo.shape
runs_ = range(nruns)
print('\n\n\n      # of: runs, iterations, parameters: ' ,  nruns,int(Xo.shape[1])/3,Yo.shape[1])
print('\n\n')
# ------------------------------------------------------------------------------
# make pytorch tensor
Xo = torch.from_numpy(Xo)
Yo = torch.from_numpy(Yo)
# ------------------------------------------------------------------------------
