# import sys
# sys.path.append('../../../../src/shared/graphics/graphics_py/')
# from fancy_figure import fancy_figure
# ------------------------------------------------------------------------------
import math
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import zipfile
import matplotlib.pyplot as plt
import numpy as np
# ------------------------------------------------------------------------------
print(tf.__version__)
# !pip install tensorflow==2.0.0
# ------------------------------------------------------------------------------
# Given synthetic shot gathers of two layer models, have the learning machine 
# figure out the physical model parameters.
# ------------------------------------------------------------------------------
# 1. load data
# 2. build learning machine
# 3. optimize
# 4. validate
# ------------------------------------------------------------------------------
# 
#                              set variables and stuff
# 
# ------------------------------------------------------------------------------
# dir_train = '/tmp/data-set/'
# dir_test  = '/tmp/data-set/'
# ------------------------------------------------------------------------------
tf.keras.backend.clear_session()
tf.random.set_seed(51)
np.random.seed(51)
# ------------------------------------------------------------------------------
# this is for google-colab
local_zip = '/content/pics-data.zip'
zip_ref   = zipfile.ZipFile(local_zip, 'r')
zip_ref.extractall('/content/')
zip_ref.close()
# ------------------------------------------------------------------------------
dir_train = '/content/pics-data/train/'
dir_test  = '/content/pics-data/test/'
# ------------------------------------------------------------------------------
me = 3
ms = 2
ml = 4
pixSize     = 740
# ------------------------------------------------------------------------------
n_models_2l = (me*ms)*(me-1)*(ms-1)*ml
# ------------------------------------------------------------------------------
step_       = 0.005
epochs_     = 1000
batch_size  = math.ceil(n_models_2l*0.2)
# ------------------------------------------------------------------------------
# set conv2d sizes 
# 
# nfx = npx * drx/xmax
# nfy = npy * (2*l1*sqrt(epsmin) / (c*tmax)) 
# 
nfx = int(round(max(pixSize * 1.250000e-02 , 3)))
nfy = int(round(max(pixSize * 2.543117e-11 , 3)))
# ------------------------------------------------------------------------------
nfx = min(nfx,nfy)
nfy = nfx
# ------------------------------------------------------------------------------
# output sizes
nout     = int(round( (pixSize/nfx) * (pixSize/nfy) ))
n_layers = 10
# ------------------------------------------------------------------------------
# 
#                              load data
# 
# ------------------------------------------------------------------------------
# training 'images'
x_train = ImageDataGenerator(
                        rescale = 1./255
                        )
# ------------------------------------------------------------------------------
x_train = x_train.flow_from_directory(
        dir_train,
        target_size= (pixSize,pixSize),    # size of shot-gathers
        color_mode = 'rgb',       # 'rgb' , 'rgba' , 'grayscale'
        batch_size =  1,#batch_size,   # figure this out!!
        class_mode = 'sparse'      # multi-labels
        )
# ------------------------------------------------------------------------------
# 
#                     the model (learning machine)
# 
# ------------------------------------------------------------------------------
model = tf.keras.models.Sequential([
    # number of outputs, size of conv2d window, ...
    tf.keras.layers.Conv2D(me,(nfy*8,nfx*8), 
                           strides   = (1,1),
                           activation= 'sigmoid',
                           input_shape=(pixSize,pixSize,3)),
    tf.keras.layers.MaxPooling2D(2, 2),
    # 
    tf.keras.layers.Conv2D(me, (nfy*4,nfx*4), activation='sigmoid'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(me, (nfy,nfx), activation='sigmoid'),
    tf.keras.layers.MaxPooling2D(2,2),
    #
    # uncomment a maxpooling!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #
    #tf.keras.layers.Conv2D(me*(me-1), (nfy*4,nfx*4), activation='relu'),
    #tf.keras.layers.MaxPooling2D(2,2),
    # 
    #tf.keras.layers.Conv2D((ms-1)*ml, (nfy*4,nfx*4), activation='relu'),
    #tf.keras.layers.MaxPooling2D(2,2),
    # 
    #tf.keras.layers.Conv2D(ms*(ms-1)*ml, (nfy*3,nfx*3), activation='relu'),
    #tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Flatten(),
    #
    #tf.keras.layers.Dropout(0.2),
    #
    #tf.keras.layers.Dense((me*ms)*(me-1)*(ms-1)*ml, activation='sigmoid'),
    #
    tf.keras.layers.Dense((me*ms)*(me-1)*(ms-1)*ml, activation='sigmoid'),
    # 
    tf.keras.layers.Dense(n_models_2l, activation='softmax')
])
# ------------------------------------------------------------------------------
# gives a nice overview of what the model is like
model.summary()
# ------------------------------------------------------------------------------
optimizer = tf.keras.optimizers.SGD(lr=step_)
#optimizer = tf.keras.optimizers.Adadelta()
# ------------------------------------------------------------------------------
model.compile(optimizer=optimizer,
              #metrics  =['accuracy'],
              loss     ='sparse_categorical_crossentropy'
              )
# ------------------------------------------------------------------------------
history = model.fit(x_train,
                    steps_per_epoch=int(n_models_2l),
                    epochs = epochs_,
                    verbose=0)
# ..............................................................................
# model.save("/content/ml_2l.h5")
# ------------------------------------------------------------------------------
loss   = history.history['loss']
epochs = range(len(loss))
# ------------------------------------------------------------------------------
plt.plot(epochs, loss, 'k.')
ax = plt.gca()
ax.set_title('Loss over iterations', fontsize=20)
ax.set_xlabel('Epochs', fontsize=20)
ax.set_ylabel('Loss', fontsize=20)
plt.figure()
plt.show()
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# 
#                     testing and predicting
# 
# ------------------------------------------------------------------------------
# results = model.evaluate(x_test, y_test, batch_size=128)
# print('test loss, test acc:', results)
# # ----------------------------------------------------------------------------
from keras_preprocessing import image
# ------------------------------------------------------------------------------
classes_ = np.zeros((n_models_2l,1))
# ------------------------------------------------------------------------------
for i_ in range(1,n_models_2l+1):
  # path_   = dir_test + '1' + '/wdc.png'
  path_   = dir_train + str(i_) + '/wdc.png'
  # ----------------------------------------------------------------------------
  pic   = image.load_img(path_, target_size=(pixSize,pixSize))
  pic   = image.img_to_array(pic)
  # manually put alpha channel in (have to fix this)
  #alphi = np.zeros( (pic.shape[0],pic.shape[1],1) )
  #pic   = np.concatenate( (pic, alphi ), axis=2 )
  # for some weird reason, tf won't work unless this is done
  pic   = np.expand_dims(pic,axis=0)
  # ----------------------------------------------------------------------------
  classes = model.predict(pic)
  # ----------------------------------------------------------------------------
  classes_max = np.argmax(classes) + 1
  # ----------------------------------------------------------------------------
  classes_[i_-1] = classes_max
  if classes_[i_-1]==i_:
    print(classes_max)
# ------------------------------------------------------------------------------
classes_I = np.arange(1,classes.size+1)
classes_I = np.expand_dims(classes_I,axis=1)
# ------------------------------------------------------------------------------
plt.plot(classes_I,classes_, 'k.')
plt.plot(classes_I,classes_I, 'b-')
plt.grid()
ax = plt.gca()
ax.set_title('Probability of 2 layer models', fontsize=20)
ax.set_xlabel('2 layer models - Labels', fontsize=15)
ax.set_ylabel('2 layer models - Predicted', fontsize=15)
plt.figure()
plt.show()
# ------------------------------------------------------------------------------




# ..............................................................................
# 
#                         visualize the journey
# 
# ..............................................................................
# from tensorflow.keras.preprocessing.image import img_to_array, load_img
# ..............................................................................
# Let's define a new Model that will take an image as input, and will output
# intermediate representations for all layers in the previous model after
# the first.
outputs_     = [layer.output for layer in model.layers[1:]]
model_visual = tf.keras.models.Model(inputs = model.input, outputs = outputs_)
# ..............................................................................
# Let's prepare a random input image from the training set.
i_    = 4
path_ = dir_train + str(i_) + '/wdc.png'
# ..............................................................................
pic = image.load_img(path_, target_size=(pixSize,pixSize))  
# ..............................................................................
pic = image.img_to_array(pic)       # np array with shape (pixSize,pixSize, 3)
pic = pic.reshape((1,) + pic.shape) # np array with shape (1,pixSize,pixSize,3)
# ..............................................................................
# Rescale by 1/255
pic /= 255
# ..............................................................................
# Let's run our image through our network, thus obtaining all
# intermediate representations for this image.
outputs_ = model_visual.predict(pic)
# ..............................................................................
# These are the names of the layers, so can have them as part of our plot
layers_ = [layer.name for layer in model.layers]
# ..............................................................................
# Now let's display our representations
for layer_, output_ in zip(layers_, outputs_):
  # Just do this for the conv / maxpool layers, not the fully-connected layers
  print(output_.shape)
  if len(output_.shape) == 4:
    # The feature map has shape (1, nxy, nxy, nf)
    nf  = output_.shape[-1]
    nxy = output_.shape[1]
    # We will tile our images in this matrix
    display_grid = np.zeros((nxy, nxy * nf))
    # Postprocess the feature to make it visually palatable
    for i_ in range(nf):
      pic = output_[0, :, :, i_]
      pic -= pic.mean()
      pic /= pic.std()
      pic *= 64
      pic += 128
      pic = np.clip(pic, 0, 255).astype('uint8')
      # We'll tile each filter into this big horizontal grid
      display_grid[:, i_ * nxy : (i_ + 1) * nxy] = pic
    # ..........................................................................
    # Display the grid
    scale = 20. / nf
    plt.figure(figsize=(scale * nf, scale))
    plt.title(layer_ , fontsize=20)
    plt.grid(False)
    # ..........................................................................
    ax = plt.gca()
    ax.set_yticklabels([])
    ax.set_xticklabels([])
    # ..........................................................................
    plt.imshow(display_grid, aspect='auto', cmap='plasma')
    # ..........................................................................
    fig=plt.gcf()
    fig.savefig('/content/'+layer_+'.png', format='png', dpi=200,bbox_inches='tight',pad_inches=0)
# ..............................................................................
#                         exit and clean memory
# ..............................................................................
# os.kill(os.getpid(), signal.SIGKILL)
# ..............................................................................