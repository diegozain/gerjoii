import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageOps
# ------------------------------------------------------------------------------
import numpy as np
# ------------------------------------------------------------------------------
guarda_path = 'pics/'
dpi_=np.loadtxt('dpi.txt',dtype='int')
dpi_=dpi_.item()
# ------------------------------------------------------------------------------
mo_le = input('more or less? ')
# ------------------------------------------------------------------------------
# choose file and color of letters
file_ = guarda_path + 'sigm-freq-' + mo_le + '.png'
# ------------------------------------------------------------------------------
colo = '#000000'
# ------------------------------------------------------------------------------
im = Image.open(file_)
# ------------------------------------------------------------------------------
# get dpi 
dpi = im.info['dpi']
# ------------------------------------------------------------------------------
# annotate
# ------------------------------------------------------------------------------
draw = ImageDraw.Draw(im)
font = ImageFont.truetype("/Library/Fonts/Verdana.ttf",25*dpi_)
# ------------------------------------------------------------------------------
if mo_le=='less':
    draw.text( (120*dpi_,65*dpi_), u"Wet sand", fill=colo,font=font)
    draw.text( (380*dpi_,205*dpi_), u"Moist sand", fill=colo,font=font)
    draw.text( (380*dpi_,260*dpi_), u"Dry sand", fill=colo,font=font)
    # --------------------------------------------------------------------------
    draw.text( (380*dpi_,540*dpi_), u"Wet sand", fill=colo,font=font)
    draw.text( (120*dpi_,430*dpi_), u"Moist sand", fill=colo,font=font)
    draw.text( (380*dpi_,455*dpi_), u"Dry sand", fill=colo,font=font)
    # --------------------------------------------------------------------------
    font = ImageFont.truetype("/Library/Fonts/Verdana Bold.ttf",30*dpi_)
    draw.text( (10*dpi_,1*dpi_), u"a)", fill=colo,font=font)
    draw.text( (10*dpi_,350*dpi_), u"b)", fill=colo,font=font)
elif mo_le=='more':
    draw.text( (370*dpi_,115*dpi_), u"Wet clay", fill=colo,font=font)
    draw.text( (150*dpi_,170*dpi_), u"Sandstone with brine", fill=colo,font=font)
    draw.text( (370*dpi_,260*dpi_), u"Silty loam", fill=colo,font=font)
    # --------------------------------------------------------------------------
    draw.text( (370*dpi_,430*dpi_), u"Wet clay", fill=colo,font=font)
    draw.text( (150*dpi_,550*dpi_), u"Sandstone with brine", fill=colo,font=font)
    draw.text( (370*dpi_,630*dpi_), u"Silty loam", fill=colo,font=font)
    # --------------------------------------------------------------------------
    font = ImageFont.truetype("/Library/Fonts/Verdana Bold.ttf",30*dpi_)
    draw.text( (10*dpi_,1*dpi_), u"c)", fill=colo,font=font)
    draw.text( (10*dpi_,350*dpi_), u"d)", fill=colo,font=font)
# ------------------------------------------------------------------------------
# im.show()
# ------------------------------------------------------------------------------
# save
# ------------------------------------------------------------------------------
im.save(file_,"PNG", dpi=dpi)
# ------------------------------------------------------------------------------
# check resolution
# sips -g dpiHeight out.png