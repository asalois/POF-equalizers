# Make and train a Deep NN Eq in Python

import sys
import os
import scipy.io as spio
import math
import time
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import numpy as np
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.optimizers import SGD
from tensorflow.keras.losses import MeanSquaredError

start_time = time.time()
SNR = str(sys.argv[1])
verboseFlag = int(sys.argv[2])

if verboseFlag == 1:
    vb = 1
else:
    vb = 2

samples = 10
fiber_length = 100
num_classes = 1
batch_size = 32
epochs = 10

SNRs = str(SNR).zfill(2)
print(SNRs)

start_dir = '/home/alexandersalois/Documents/pof_data/fiberLen'
start_dir += str(fiber_length).zfill(2)
start_dir += '/' + str(samples) + '_samples/snr'

for cv in range(1,9):

    # Load the data
    matname = start_dir + SNRs + "/cv0" + str(cv) + "DataSnr" + SNRs + ".mat"
    print(matname)
    mat = spio.loadmat(matname, squeeze_me=False)
    x_train = mat['cvTrainIn']
    y_train = mat['cvTrainTarget']
    x_test = mat['cvTestIn']
    y_test = mat['cvTestTarget']

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
    #print('Label Examples:\n', x_train[0:9]);
    #print('Label Examples:\n', y_train[0:9]);


    # Formatting
    fmtLen = int(math.ceil(math.log(max(batch_size, y_train.shape[0]),10)))

    # Define the network
    model = Sequential()
    model.add(Dense(12, activation='relu', input_dim=(2*samples+1)))
    model.add(Dense(12, activation='tanh'))
    model.add(Dense(10, activation='tanh'))
    model.add(Dense(8, activation='tanh'))
    model.add(Dense(6, activation='tanh'))
    model.add(Dense(4, activation='tanh'))
    model.add(Dense(2, activation='tanh'))
    model.add(Dense(4, activation='tanh'))
    model.add(Dense(6, activation='tanh'))
    model.add(Dense(8, activation='tanh'))
    model.add(Dense(10, activation='tanh'))
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

    #predictions = model.predict(x_test)
    #matname = "predictionsSNR" + SNRs + ".mat"
    #spio.savemat(matname, {'pred': predictions})
    #savename = "deep_model_SNR" + SNRs + ".h5"
    #model.save(savename)

print("--- %.2f seconds ---" % (time.time() - start_time))
