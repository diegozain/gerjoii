import sys
sys.path.append('../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
# ------------------------------------------------------------------------------
# join figures
# ------------------------------------------------------------------------------
im =guarda_path+'sigm-freq-less.png'
im_=guarda_path+'sigm-freq-more.png'
im = fancy_image(im=im).openim()
dpi=im.info['dpi']
nh,nv=im.size
im = fancy_image(im=im,im_=im_).concat_h()
# ------------------------------------------------------------------------------
# im.show()
# ------------------------------------------------------------------------------
im.save(guarda_path+'sigm-freq'+'.png',"PNG", dpi=dpi)
