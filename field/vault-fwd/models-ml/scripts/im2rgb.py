from PIL import Image
import numpy as np
# ------------------------------------------------------------------------------
# from all GPR and ER pictures in each project, create composite image:
# 
# 1. r channel is for dipole-dipole a-spaceing = 1
# 2. g channel is for wenner
# 3. b channel is for shot-gather
# 4. alpha channel is all transparent (maybe change this?)
# ------------------------------------------------------------------------------
n_models = 48
# ------------------------------------------------------------------------------
path__ = input ("train or test: ")
path__ = '../data-set/' + path__ + '/'
# ------------------------------------------------------------------------------
for im in range(1,n_models+1):
    path_= path__ + str(im) + '/'
    line1= Image.open(path_+'w.png')
    wen  = Image.open(path_+'wen.png')
    dd_1 = Image.open(path_+'dd_1.png')
    # --------------------------------------------------------------------------
    line1= np.asarray(line1)
    wen  = np.asarray(wen)
    dd_1 = np.asarray(dd_1)
    # --------------------------------------------------------------------------
    wdc  = np.zeros(line1.shape)
    wdc[:,:,0] = dd_1[:,:,0]
    wdc[:,:,1] = wen[:,:,1]
    wdc[:,:,2] = line1[:,:,2]
    wdc[:,:,3] = line1[:,:,2] # np.remainder(line1[:,:,3]+wen[:,:,3]+dd_1[:,:,3],256)
    # --------------------------------------------------------------------------
    wdc  = Image.fromarray(wdc.astype(np.uint8),'RGBA')
    wdc.save(path_+'wdc.png')
    # --------------------------------------------------------------------------
    print('just finished your pics for model ',im)
# ------------------------------------------------------------------------------

