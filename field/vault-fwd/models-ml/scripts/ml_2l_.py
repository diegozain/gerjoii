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
        color_mode = 'rgba',       # 'rgb' , 'rgba' , 'grayscale'
        batch_size =  1,#batch_size,   # figure this out!!
        class_mode = 'sparse'      # multi-labels
        )
# ------------------------------------------------------------------------------
# 
#                     the model (learning machine)
# 
# ------------------------------------------------------------------------------
'''
model = tf.keras.models.Sequential([
    # number of outputs, size of conv2d window, ...
    tf.keras.layers.Conv2D(n_models_2l,(nfy,nfx), 
                           strides   = (1,1),
                           activation= 'relu',
                           input_shape=(pixSize,pixSize,4)),
    tf.keras.layers.MaxPooling2D(2, 2),
    # 
    tf.keras.layers.Conv2D(n_models_2l, (nfy,nfx), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(n_models_2l, (nfy,nfx), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(n_models_2l, (nfy*8,nfx*8), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(n_models_2l, (nfy*8,nfx*8), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(n_models_2l, activation='sigmoid'),
    #
    #tf.keras.layers.Dropout(0.5,seed=51),
    #
    tf.keras.layers.Dense(n_models_2l, activation='sigmoid'),
    # 
    tf.keras.layers.Dense(n_models_2l, activation='softmax')
])
'''
# ------------------------------------------------------------------------------
model = tf.keras.models.Sequential([
    # number of outputs, size of conv2d window, ...
    tf.keras.layers.Conv2D(me*(me-1)*ml,(nfy*8,nfx*8), 
                           strides   = (1,1),
                           activation= 'relu',
                           input_shape=(pixSize,pixSize,3)),
    tf.keras.layers.MaxPooling2D(2, 2),
    # 
    tf.keras.layers.Conv2D(me*(me-1)*ml, (nfy,nfx), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(me*(me-1)*ml, (nfy,nfx), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(ms*(ms-1)*ml, (nfy*8,nfx*8), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Conv2D(ms*(ms-1)*ml, (nfy*8,nfx*8), activation='relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    # 
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense((me*ms)*(me-1)*(ms-1)*ml, activation='sigmoid'),
    #
    #tf.keras.layers.Dropout(0.2,seed=51),
    #
    tf.keras.layers.Dense((me*ms)*(me-1)*(ms-1)*ml, activation='sigmoid'),
    # 
    tf.keras.layers.Dense(n_models_2l, activation='softmax')
])
# ------------------------------------------------------------------------------
# gives a nice overview of what the model is like
model.summary()
# ------------------------------------------------------------------------------
optimizer = tf.keras.optimizers.SGD(lr=0.001)
#optimizer = tf.keras.optimizers.Adadelta()
# ------------------------------------------------------------------------------
model.compile(optimizer=optimizer,
              #metrics  =['accuracy'],
              loss     ='sparse_categorical_crossentropy'
              )
# ------------------------------------------------------------------------------
history = model.fit(x_train,
                    steps_per_epoch=int(n_models_2l),
                    epochs =1000,
                    verbose=1)
# ..............................................................................
# model.save("ml_2l.h5")
# ------------------------------------------------------------------------------
loss   = history.history['loss']
epochs = range(len(loss))
# ------------------------------------------------------------------------------
plt.plot(epochs, loss, 'k.')
ax = plt.gca()
ax.set_title('Loss over iterations')
ax.set_xlabel('Epochs')
ax.set_ylabel('Loss')
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
  alphi = np.zeros( (pic.shape[0],pic.shape[1],1) )
  pic   = np.concatenate( (pic, alphi ), axis=2 )
  # for some weird reason, tf won't work unless this is done
  pic   = np.expand_dims(pic,axis=0)
  # ----------------------------------------------------------------------------
  classes = model.predict(pic)
  # ----------------------------------------------------------------------------
  classes_max = np.argmax(classes) + 1
  # ----------------------------------------------------------------------------
  classes_[i_-1] = classes_max
  #print(i_, classes_max)
# ------------------------------------------------------------------------------
classes_I = np.arange(1,classes.size+1)
classes_I = np.expand_dims(classes_I,axis=1)
# ------------------------------------------------------------------------------
plt.plot(classes_I,classes_, 'k.')
plt.plot(classes_I,classes_I, 'b-')
plt.grid()
ax = plt.gca()
ax.set_title('Probability of 2 layer models')
ax.set_xlabel('2 layer models - Labels')
ax.set_ylabel('2 layer models - Predicted')
plt.figure()
plt.show()
# ------------------------------------------------------------------------------