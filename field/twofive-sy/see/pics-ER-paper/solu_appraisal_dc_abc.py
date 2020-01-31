import numpy as np
from PIL import Image, ImageDraw, ImageFont
# ------------------------------------------------------------------------------
import numpy as np
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
# ------------------------------------------------------------------------------
# choose file and color of letters
file_ = guarda_path + 'conductivity-sy-' + '.png'
# ------------------------------------------------------------------------------
im = Image.open(file_)
# im.show()
# ------------------------------------------------------------------------------
# get dpi 
dpi = im.info['dpi']
# ------------------------------------------------------------------------------
# annotate
# ------------------------------------------------------------------------------
draw = ImageDraw.Draw(im)
font = ImageFont.truetype("/Library/Fonts/Verdana Bold.ttf",30*dpi_)
draw.text( (70*dpi_,25*dpi_), u"a)", fill='#ffffff',font=font)
draw.text( (70*dpi_,260*dpi_), u"b)", fill='#ffffff',font=font)
draw.text( (70*dpi_,495*dpi_), u"c)", fill='#ffffff',font=font)
# ------------------------------------------------------------------------------
# im.show()
# ------------------------------------------------------------------------------
# save
# ------------------------------------------------------------------------------
im.save(file_,"PNG", dpi=dpi)
# ------------------------------------------------------------------------------
# check resolution
# sips -g dpiHeight out.png