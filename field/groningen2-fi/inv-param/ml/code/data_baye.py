import numpy as np
# ------------------------------------------------------------------------------
# paths
path_ = '../data/'
# ------------------------------------------------------------------------------
# files
x = path_ + 'P.npy'
y = path_ + 'Psi.npy'
# ------------------------------------------------------------------------------
# load & convert to numpy
x = np.load(x)
y = np.load(y)
# ------------------------------------------------------------------------------
# get parameters: nx, ny, nruns, np, ni:
# y is an array of size (nruns x 1)
# x is a matrix of size (nruns x np)
nruns,np_ = x.shape
print('\n\n\n      # of: runs & parameters: ' ,nruns,np_)
print('\n\n')
# ------------------------------------------------------------------------------
