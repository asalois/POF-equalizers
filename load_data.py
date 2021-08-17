# Make and train a Deep NN Eq in Python

import sys
import os
import scipy.io as spio
import math
import time
import numpy as np
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.optimizers import SGD
from tensorflow.keras.losses import MeanSquaredError

start_time = time.time()
run = np.array(np.meshgrid(range(5,36),range(1,9))).T.reshape(-1,2)
indx = int(sys.argv[1])
SNR = run[indx,0]
cv = run[indx,1]
print(run[indx,0])
print(run[indx,1])

SNRs = str(SNR).zfill(2)
print(SNRs)

# Load the data
matname = "snr" + SNRs + "/cv01DataSnr" + SNRs + ".mat"
print(matname)
mat = spio.loadmat(matname, squeeze_me=False)
x_train = mat['cvTrainIn']
y_train = mat['cvTrainTarget']
x_test = mat['cvTestIn']
y_test = mat['cvTestTarget']


# Convert the data to floats between 0 and 1.
x_train = x_train.astype('float32')
y_train = y_train.astype('float32')
x_test = x_test.astype('float32')
y_test = y_test.astype('float32')
#x_train /= 255
#y_train /= 255
#x_test /= 255
#y_test /= 255
print(x_train.shape, 'train samples')
print(y_train.shape, 'train labels')
print(x_test.shape, 'test samples')
print(y_test.shape, 'test labels')
print('Label Examples:\n', y_train[0:20]);


print("--- %.2f seconds ---" % (time.time() - start_time))
