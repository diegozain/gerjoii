import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
# from all radar data take,
# 
# 1. max and min                (first loop)
# 2. make a picture of the data (second loop),
#     * all data has to have same max, min and middle values in their pics
# ------------------------------------------------------------------------------
n_models = 48
name_    = 'line1'
name_s   = 'line1'
# ------------------------------------------------------------------------------
path_read_max_min = '../data-set/train/'
# ------------------------------------------------------------------------------
path_read = input ("train or test: ")
path_read = '../data-set/' + path_read + '/'
# ------------------------------------------------------------------------------
# i dont remember why path_read and path_save can be different, lol
path_save= path_read
# ------------------------------------------------------------------------------
name_s   = 'w'
# ------------------------------------------------------------------------------
dpi      = 200
size     = [4,4]
aspect_  = 'auto'
midi     = 0
# ------------------------------------------------------------------------------
colo = input ("what colormap (i.e. kb or plasma): ")
# colo = 'kb' # 'kb'   'plasma'
# 'Greys,'hot,'Blues,'cafe,'apbcv,'ybwrk','coolwarm','viridis','kb','plasma'
# ------------------------------------------------------------------------------
#                       get max and min
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
# ------------------------------------------------------------------------------
for im in range(1,n_models+1):
    path_ = path_read_max_min + str(im) + '/'
    d,mini,maxi = fancy_figure.bring(path_,name_,mini,maxi,name__='radargram')
# ------------------------------------------------------------------------------
# choosing min and max of picture can be tricky i think,
# what happens if the picture looks flat?
# what happens to values that are clipped?
mini = 0.1*mini
maxi = 0.1*maxi
# ------------------------------------------------------------------------------
#                       make pictures
# ------------------------------------------------------------------------------
for im in range(1,n_models+1):
    path_r = path_read + str(im) + '/'
    path_s = path_save + str(im) + '/'
    # --------------------------------------------------------------------------
    d,_,_ = fancy_figure.bring(path_r,name_,mini,maxi,name__='radargram')
    # --------------------------------------------------------------------------
    plt_=fancy_figure(
        aspect=aspect_,
        figsize=size,
        data=d,
        midi=midi,vmin=mini,vmax=maxi,
        transparent='False',
        colo=colo,  
        colorbaron='off',
        x_ticklabels='off',
        y_ticklabels='off',
        no_frame='on',
        holdon  ='on',
        guarda_path=path_s,
        guarda=dpi,
        fig_name=name_s
        ).matrix()
    plt_.close()
    # --------------------------------------------------------------------------
    print('just finished your pics for model ',im)
# ------------------------------------------------------------------------------
# !sips -g all tmp/line1.png
# ------------------------------------------------------------------------------
