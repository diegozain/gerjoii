import zipfile
import numpy as np
import shutil
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from keras_preprocessing import image
# ------------------------------------------------------------------------------
print(tf.__version__)
# # ----------------------------------------------------------------------------
tf.keras.backend.clear_session()
tf.random.set_seed(51)
np.random.seed(51)
# ------------------------------------------------------------------------------
path_data = '../../../pics-ml/pics-data'
path_outi = '../output/'
path_tmpi = '../tmp/'
# ------------------------------------------------------------------------------
local_zip = path_data+'.zip'
zip_ref   = zipfile.ZipFile(local_zip, 'r')
zip_ref.extractall(path_tmpi)
zip_ref.close()
# ------------------------------------------------------------------------------
dir_train = path_tmpi+'pics-data/train/'
dir_test  = path_tmpi+'pics-data/test/'
# ------------------------------------------------------------------------------
# 
#                       optimization parameters
# 
# ------------------------------------------------------------------------------
opti_param = path_tmpi+'param.txt'
opti_param = np.loadtxt(opti_param)
# ------------------------------------------------------------------------------
me     = opti_param[0].astype(int) # 3   # 
ms     = opti_param[1].astype(int) # 2   # 
ml     = opti_param[2].astype(int) # 4   # 
npix_x = opti_param[3].astype(int) # 740 # 
npix_y = opti_param[4].astype(int) # 740 # 
# ------------------------------------------------------------------------------
step_  = opti_param[5]             # 0.0005 # 
epochs_= opti_param[6].astype(int) # 3000   # 
# ------------------------------------------------------------------------------
n_models_2l = (me*ms)*(me-1)*(ms-1)*ml
# ------------------------------------------------------------------------------
# set conv2d sizes 
# 
# nfx = npx * drx/xmax
# nfy = npy * (2*l1*sqrt(epsmin) / (c*tmax)) 
# 
nfx = int(round(max(npix_x * 1.250000e-02 , 3)))
nfy = int(round(max(npix_y * 2.543117e-11 , 3)))
# ------------------------------------------------------------------------------
nfx = min(nfx,nfy)
nfy = nfx
# ------------------------------------------------------------------------------
# 
#                              load data
# 
# ------------------------------------------------------------------------------
# training 'images'
x_train = ImageDataGenerator(
                        #rescale = 1./255
                        )
# ------------------------------------------------------------------------------
x_train = x_train.flow_from_directory(
        dir_train,
        target_size= (npix_x,npix_y),   # size of pics
        color_mode = 'rgb',            # 'rgb' , 'rgba' , 'grayscale'
        batch_size =  1,
        class_mode = 'sparse'           # multi-labels
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
                           activation= 'swish',
                           kernel_initializer='GlorotNormal',
                           input_shape=(npix_x,npix_y,3)
                           ),
    #tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.AveragePooling2D(2, 2),
    # 
    tf.keras.layers.Conv2D(me, (nfy*1,nfx*1), 
                          activation='swish',
                          kernel_initializer='GlorotNormal'
                           ),
    #tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.AveragePooling2D(2, 2),
    # 
    tf.keras.layers.Conv2D(me, (nfy,nfx), 
                          activation='swish',
                          kernel_initializer='GlorotNormal'
                           ),
    #tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.AveragePooling2D(2, 2),
    #
    tf.keras.layers.Conv2D(me, (nfy,nfx), 
                          activation='swish', # 'swish' 'relu'
                          kernel_initializer='GlorotNormal'
                           ),
    #tf.keras.layers.MaxPooling2D(2,2),
    tf.keras.layers.AveragePooling2D(2, 2),
    # 
    tf.keras.layers.Flatten(),
    #
    #tf.keras.layers.Reshape( (23232,1) ),
    #tf.keras.layers.SimpleRNN( (me*ms)*(me-1)*(ms-1)*ml ),
    #
    #tf.keras.layers.Dropout(0.1,seed=51),
    #
    tf.keras.layers.Dense((me*ms)*(me-1)*(ms-1)*ml, 
                          activation='swish',
                          kernel_initializer='GlorotNormal'
                          ),
    # 
    tf.keras.layers.Dense(n_models_2l, 
                          activation='softmax',
                          kernel_initializer='GlorotNormal'
                          )
])
# ------------------------------------------------------------------------------
# gives a nice overview of what the model is like
model.summary()
# ------------------------------------------------------------------------------
# optimizer = tf.keras.optimizers.SGD(lr=step_)
optimizer = tf.keras.optimizers.Adadelta(
    learning_rate=step_, rho=0.95, epsilon=1e-07
    )
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
# ------------------------------------------------------------------------------
loss = history.history['loss']
loss = np.asarray(loss)
# ------------------------------------------------------------------------------
np.save(path_outi+'loss',loss)
model.save(path_outi+'ml_2l.h5')
# ------------------------------------------------------------------------------
# 
#                     testing the training set
# 
# ------------------------------------------------------------------------------
classes_train = np.zeros((n_models_2l,1))
# ------------------------------------------------------------------------------
for i_ in range(1,n_models_2l+1):
  # choose filename
  path_   = dir_train + str(i_) + '/wdc.png'
  # ----------------------------------------------------------------------------
  pic   = image.load_img(path_, target_size=(npix_x,npix_y,3))
  pic   = image.img_to_array(pic)
  # # manually put alpha channel in (have to fix this)
  # alphi = np.zeros( (pic.shape[0],pic.shape[1],1) )
  # pic   = np.concatenate( (pic, alphi ), axis=2 )
  # add batch size of zero
  pic   = np.expand_dims(pic,axis=0)
  # ----------------------------------------------------------------------------
  #pic /= 255
  # ----------------------------------------------------------------------------
  classes = model.predict(pic)
  # ----------------------------------------------------------------------------
  classes_max = np.argmax(classes) + 1
  # ----------------------------------------------------------------------------
  classes_train[i_-1] = classes_max
# ------------------------------------------------------------------------------
np.save(path_outi+'classes_train',classes_train)
# ------------------------------------------------------------------------------
# 
#                     testing the testing set
# 
# ------------------------------------------------------------------------------
n_models_2l_ = n_models_2l
# ------------------------------------------------------------------------------
classes_esti = np.zeros((n_models_2l_,n_models_2l))
# ------------------------------------------------------------------------------
for i_ in range(1,n_models_2l+1):
  # choose filename
  path_   = dir_test + str(i_) + '/wdc.png'
  # ----------------------------------------------------------------------------
  pic   = image.load_img(path_, target_size=(npix_x,npix_y,3))
  pic   = image.img_to_array(pic)
  # # manually put alpha channel in (have to fix this)
  # alphi = np.zeros( (pic.shape[0],pic.shape[1],1) )
  # pic   = np.concatenate( (pic, alphi ), axis=2 )
  # add batch size of zero
  pic   = np.expand_dims(pic,axis=0)
  # ----------------------------------------------------------------------------
  #pic /= 255
  # ----------------------------------------------------------------------------
  classes_esti[i_-1,:] = model.predict(pic)
# ------------------------------------------------------------------------------
np.save(path_outi+'classes_esti',classes_esti)
# ------------------------------------------------------------------------------
# 
#                       some cleaning
# 
# ------------------------------------------------------------------------------
shutil.rmtree(path_tmpi+'pics-data/')
shutil.rmtree(path_tmpi+'__MACOSX/')
# ------------------------------------------------------------------------------
