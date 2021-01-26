import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
import numpy as np
# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
path_= input ("project name: ")
# ------------------------------------------------------------------------------
guarda_path = 'tmp/'
# ------------------------------------------------------------------------------
dpi      = 200
size     = [5,5]
# ------------------------------------------------------------------------------
#                       get classes
# ------------------------------------------------------------------------------
classes_train = np.load('../projects/'+path_+'/output/classes_train.npy')
# ------------------------------------------------------------------------------
classes_I = np.arange(1,classes_train.size+1)
classes_I = np.expand_dims(classes_I,axis=1)
# ------------------------------------------------------------------------------
plt_=fancy_figure(
    figsize=size,
    curve=classes_train,
    x=classes_I,
    colop='k',
    symbol='.',
    title='Probability of 2 layer models',
    xlabel='2 layer models - Labels',
    ylabel='2 layer models - Predicted',
    margin=(0.03,0.03),
    guarda_path=guarda_path,
    guarda=dpi,
    fig_name='classes_train-'+path_
    ).plotter()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------

