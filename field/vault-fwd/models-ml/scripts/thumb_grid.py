import sys
import glob
import re
from PIL import Image, ImageDraw, ImageFont
# ------------------------------------------------------------------------------
import sys
sys.path.append('../../../../src/shared/graphics/graphics_py/')
from fancy_image import fancy_image
# ------------------------------------------------------------------------------
mod_or_dat= input ("models or data: ")
path_= '../pics-ml/pics-'+mod_or_dat+'-compare/'
# ------------------------------------------------------------------------------
t_or_t= input ("test or train or estimated: ")
# ------------------------------------------------------------------------------
pattern = path_+t_or_t+'/*.png'
# ------------------------------------------------------------------------------
rows    = 4        # ml
cols    = 12       # me*ml*(me-1)*(ms-1)
size_x  = 150
size_y  = 150
banner_x= 20
banner_y= 20
font    = ImageFont.truetype("/Library/Fonts/Verdana Bold.ttf",50)
colo    = '#ffffff' #'#eb4934' # '#03d3fc'
# ------------------------------------------------------------------------------
# get filenames
# '''
filenames = glob.glob(pattern)
filenames = sorted(filenames, key=lambda x:float(re.findall("(\d+)",x)[0]))
# ------------------------------------------------------------------------------
# load images and resize them
images = [Image.open(name).resize((size_x, size_y)) for name in filenames]
# ------------------------------------------------------------------------------
# output image for grid with thumbnails
size_x_ = cols*size_x + banner_x*(cols+1)
size_y_ = rows*size_y + banner_y*(rows+1)
new_image = Image.new('RGBA', (size_x_,size_y_),color=(255,255,255,0))
# ------------------------------------------------------------------------------
# paste thumbnails on output
i_ = 0
for y in range(rows):
    if i_ >= len(images):
        break
    y *= size_y+banner_y
    for x in range(cols):
        x *= size_x+banner_x
        img = images[i_]
        if mod_or_dat=='models':
            # ------------------------------------------------------------------
            # annotate
            # ------------------------------------------------------------------
            draw  = ImageDraw.Draw(img)
            # ------------------------------------------------------------------
            draw.text( (size_x*0.3-1,size_y*0.3-1), str(i_+1), fill='#000000',font=font)
            draw.text( (size_x*0.3+1,size_y*0.3-1), str(i_+1), fill='#000000',font=font)
            draw.text( (size_x*0.3-1,size_y*0.3+1), str(i_+1), fill='#000000',font=font)
            draw.text( (size_x*0.3+1,size_y*0.3+1), str(i_+1), fill='#000000',font=font)
            # ------------------------------------------------------------------
            draw.text( (size_x*0.3,size_y*0.3), str(i_+1), fill=colo,font=font)
            # ------------------------------------------------------------------
        new_image.paste(img, (x+banner_x, y+banner_y, x+size_x+banner_x, y+size_y+banner_y))
        print('image # : ', i_)
        i_ += 1
# ------------------------------------------------------------------------------
# save output
new_image.save(path_+'/'+t_or_t+'.png')
# '''
# ----------------------------------------------------------------------------
# join figures
# ----------------------------------------------------------------------------
im  = path_+'/'+t_or_t+'.png'
im_ = path_+'/colors.png'
im  = fancy_image(im=im).openim()
# print(im.info)
# dpii= im.info['dpi']
nh,_= im.size
im_ = fancy_image(im=im_,nh=nh,nh_r=270).padder_h()
im  = fancy_image(im=im,im_=im_).concat_v()
# im.show()
im.save(path_+'/'+t_or_t+'.png',"PNG")
# ----------------------------------------------------------------------------
# plt_.close()
# ------------------------------------------------------------------------------