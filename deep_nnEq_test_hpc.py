# Make and train a Deep NN Eq in Python

import sys
import os
import scipy.io as spio
import math
import time
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.optimizers import SGD
from tensorflow.keras.losses import MeanSquaredError

num_threads = 4
# Maximum number of threads to use for OpenMP parallel regions.
os.environ["OMP_NUM_THREADS"] = str(num_threads)
# Without setting below 2 environment variables, it didn't work for me. Thanks to @cjw85
os.environ["TF_NUM_INTRAOP_THREADS"] = str(num_threads)
os.environ["TF_NUM_INTEROP_THREADS"] = str(num_threads)

# tf threading
tf.config.threading.set_intra_op_parallelism_threads(num_threads)
tf.config.threading.set_inter_op_parallelism_threads(num_threads)
tf.config.set_soft_device_placement(True)

start_time = time.time()
snr = int(sys.argv[1])
samples = int(sys.argv[2])
vb = 2

fiber_length = 100
num_classes = 1
batch_size = 32
epochs = 10


print('SNR = ',snr)
print('Test run')
print('Samples = ', samples)
print('Fiber Length = ', fiber_length)

start_dir = '/mnt/lustrefs/scratch/v16b915/pof_data/fiberLen'
start_dir += str(fiber_length).zfill(2)
start_dir += '/' + str(samples).zfill(2) + '_samples/snr'


SNRs = str(snr).zfill(2)

# Load the data
matname = start_dir + SNRs + "/testDataSnr" + SNRs + ".mat"
print(matname)
mat = spio.loadmat(matname, squeeze_me=False)
x_train = mat['testTrainIn']
y_train = mat['testTrainTarget']
x_test = mat['testIn']
y_test = mat['testTarget']

x_train = np.transpose(x_train)
y_train = np.transpose(y_train)
x_test = np.transpose(x_test)
y_test = np.transpose(y_test)


# Convert the data to floats between 0 and 1.
x_train = x_train.astype('float32')
y_train = y_train.astype('float32')
x_test = x_test.astype('float32')
y_test = y_test.astype('float32')
print(x_train.shape, 'train samples')
print(y_train.shape, 'train labels')
print(x_test.shape, 'test samples')
print(y_test.shape, 'test labels')


# Formatting
fmtLen = int(math.ceil(math.log(max(batch_size, y_train.shape[0]),10)))

# Define the network
model = Sequential()
model.add(Dense(12, activation='relu', input_dim=(2*samples+1)))
model.add(Dense(12, activation='tanh'))
model.add(Dense(8, activation='tanh'))
model.add(Dense(4, activation='tanh'))
model.add(Dense(8, activation='tanh'))
model.add(Dense(12, activation='tanh'))
model.add(Dense(num_classes, activation='linear'))

model.summary()

model.compile(loss=keras.metrics.mean_squared_error,
              optimizer=SGD(),
              metrics=[keras.metrics.RootMeanSquaredError(name='rmse')])

history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=vb)

score = model.evaluate(x_train, y_train, verbose=vb)
print('Final Training MSE:', score[0])
print('Final Training RMSE:', score[1])

score = model.evaluate(x_test, y_test, verbose=vb)
print('Test MSE:', score[0])
print('Test RMSE:', score[1])

predictions = model.predict(x_test)
matname = str(samples).zfill(2) + "predictionsSNR" + SNRs + ".mat"
spio.savemat(matname, {'pred': predictions})
#savename = "deep_model_SNR" + SNRs + ".h5"
#model.save(savename)

print("--- %.2f seconds ---" % (time.time() - start_time))
