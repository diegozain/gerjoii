from PIL import Image, ImageDraw, ImageFont
# -----------------------
# diego domenzain
# Boise State University 
# spring 2019
# -----------------------
class fancy_image():
    def __init__(self, **kwargs):
        '''
        plotting fancy
        '''
        self.kwargs  = kwargs
        # ......
        # image image
        # ......
        self.im   = kwargs.get('im', None)
        self.im_  = kwargs.get('im_', None)
        # ......
        # crop
        # ......
        self.box   = kwargs.get('box', None)
        # ......
        # pad
        # ......
        self.nh = kwargs.get('nh', None)
        self.nh_r = kwargs.get('nh_r', None)
        self.nv_d = kwargs.get('nv_d', None)
        self.nv   = kwargs.get('nv', None)
        # ......
        # text
        # ......
        self.text       = kwargs.get('text', None)
        self.font_type  = kwargs.get('font_type', None)
        self.font_size  = kwargs.get('font_size', None)
        self.font_color = kwargs.get('font_color', None)
        self.font_pos   = kwargs.get('font_pos', None)
        self.text_      = kwargs.get('text_', None)
    def openim(self):
        '''
        open image or read from file
        '''
        # ......
        # open one image
        # ......
        if type(self.im) is str:
            im = Image.open(self.im)
        else:
            im = self.im
        # ......
        # open two images
        # ......
        if self.im_ is not None:
            if isinstance(self.im_, str):
                im_ = Image.open(self.im_)
                im  = [im,im_]
            else:
                im = [im,self.im_]
        # ......
        # return
        # ......
        return im
    def cropper(self):
        '''
        crop an image
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # crop it
        # ......
        left   = self.box[0]
        top    = self.box[1]
        right  = self.box[2]
        bottom = self.box[3]
        # python is WEIRD
        width, height = im.size
        right   = width  - right
        bottom  = height - bottom
        # left top right bottom
        im = im.crop((left, top, right, bottom))
        # ......
        # return
        # ......
        return im
    def padder_h(self):
        import numpy as np
        '''
        pad an image horizontally
        
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # pad it
        # ......
        im   = np.asarray( im )
        size = im.shape
        nh_  = size[1]
        nh_l = self.nh - (nh_ + self.nh_r)
        if nh_l<0:
            print('horizontal target size to pad ',self.nh)
            print('size of pic to be padded      ',nh_)
            print('horizontal size of padding    ',self.nh_r)
        # right side
        im_ = im[:,-2:-1,:]*0
        im_ = np.tile(im_, (1, self.nh_r, 1))
        im  = np.concatenate( (im,im_) , 1 )
        # left side
        im_ = im[:,1:2,:]
        im_[:,:,3] = 0 # this fucker is there if color pixels are touching the border of the picture
        im_ = np.tile(im_, (1, nh_l, 1))
        im  = np.concatenate( (im_,im) , 1 )
        # ......
        # return
        # ......
        im = Image.fromarray(im , 'RGBA')
        return im
    def padder_v(self):
        import numpy as np
        '''
        pad an image vertically
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # pad it
        # ......
        im = np.asarray( im )
        size = im.shape
        nv_  = size[0]
        nv_u = self.nv - (nv_ + self.nv_d)
        # down side
        im_ = im[-2:-1,:,:]
        im_ = np.tile(im_, (self.nv_d, 1, 1))
        im = np.concatenate( (im,im_) , 0 )
        # up side
        im_ = im[1:2,:,:]
        im_ = np.tile(im_, (nv_u, 1, 1))
        im = np.concatenate( (im_,im) , 0 )
        # ......
        # return
        # ......
        im = Image.fromarray(im , 'RGBA')
        return im
    def annotate(self):
        '''
        annotate on an image
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # load and annotate
        # ......
        font = ImageFont.truetype(self.font_type,self.font_size)
        draw = ImageDraw.Draw(im)
        draw.text( self.font_pos, self.text_, fill=self.font_color,font=font)
        # ......
        # return
        # ......
        return im
    def concat_v(self):
        import numpy as np
        '''
        concatenate vertically 2 images
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # merge
        # ......
        im = np.vstack( (np.asarray( i_ ) for i_ in im ) )
        im = Image.fromarray( im )
        # ......
        # return
        # ......
        return im
    def concat_h(self):
        import numpy as np
        '''
        concatenate horizontally 2 images
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # merge
        # ......
        im = np.hstack( (np.asarray( i_ ) for i_ in im ) )
        im = Image.fromarray( im )
        # ......
        # return
        # ......
        return im
    def transpa_bye(self):
        '''
        remove transparency of an image
        '''
        # ......
        # open
        # ......
        im = fancy_image.openim(self)
        # ......
        # remove alpha
        # ......
        # alpha = im.convert('RGBA').getchannel('A')
        bg = (255, 255, 255)
        im_ = Image.new("RGB", im.size, bg)
        im_.paste(im)
        im_.convert('RGB')
        # ......
        # return
        # ......
        return im_
        