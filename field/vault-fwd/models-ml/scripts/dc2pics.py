import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
# from all ER data take,
# 
# 1. max and min                (first loop)
# 2. make a picture of the data (second loop),
#     * all data has to have same max, min and middle values in their pics
# ------------------------------------------------------------------------------
n_models = 48
a_max    = 1
# ------------------------------------------------------------------------------
path_read_max_min = '../data-set/train/'
# ------------------------------------------------------------------------------
path_read = input ("train or test: ")
path_read = '../data-set/' + path_read + '/'
# ------------------------------------------------------------------------------
# i dont remember why path_read and path_save can be different, lol
path_save= path_read
# ------------------------------------------------------------------------------
dpi      = 200
size     = [4,4]
aspect_  = 'auto'
# ------------------------------------------------------------------------------
#                       get max and min
# ------------------------------------------------------------------------------
mini =  float('Inf')
maxi = -float('Inf')
name_= 'rhoas'
# ------------------------------------------------------------------------------
for im in range(1,n_models+1):
    path_ = path_read_max_min + str(im) + '/'
    _,mini,maxi = fancy_figure.bring(path_,name_,mini,maxi)
# ------------------------------------------------------------------------------
# choosing middle of colorbar of picture can be tricky i think,
# what happens if the picture looks flat?
midi = 0.5*(maxi-mini) + mini
# ------------------------------------------------------------------------------
#                       make pictures
# ------------------------------------------------------------------------------
struct_    = 'voltagram'
pseus_rhoa_= 'pseus_rhoa'
# ------------------------------------------------------------------------------
for im in range(1,n_models+1):
    path_r = path_read + str(im) + '/'
    path_s = path_save + str(im) + '/'
    # --------------------------------------------------------------------------
    #                   dipole-dipole
    # --------------------------------------------------------------------------
    for ii_ in range(1,a_max+1):
        name_ = 'dd_' + str(ii_)
        colo  = 'kr'
        # ----------------------------------------------------------------------
        pseus_rhoa,_,_ = fancy_figure.bring_struct(path_r,name_,struct_,
                                                   pseus_rhoa_,mini,maxi)
        # ----------------------------------------------------------------------
        plt_=fancy_figure(
            aspect=aspect_,
            figsize=size,
            data=pseus_rhoa,
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
            fig_name=name_
            ).pmatrix()
        plt_.close()
    # --------------------------------------------------------------------------
    #                   wenner 
    # --------------------------------------------------------------------------
    name_ = 'wen'
    colo  = 'kg'
    # --------------------------------------------------------------------------
    pseus_rhoa,_,_ = fancy_figure.bring_struct(path_r,name_,struct_,
                                               pseus_rhoa_,mini,maxi)
    # --------------------------------------------------------------------------
    fancy_figure(
        aspect=aspect_,
        figsize=size,
        data=pseus_rhoa,
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
        fig_name=name_
        ).pmatrix()
    plt_.close()
    # --------------------------------------------------------------------------
    print('just finished your pics for model ',im)
# ------------------------------------------------------------------------------
# !sips -g all tmp/line1.png
# ------------------------------------------------------------------------------
