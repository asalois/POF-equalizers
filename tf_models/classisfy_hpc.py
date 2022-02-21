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

num_threads = 4
# Maximum number of threads to use for OpenMP parallel regions.
os.environ["OMP_NUM_THREADS"] = str(num_threads)
# Without setting below 2 environment variables, it didn't work for me. Thanks to @cjw85
os.environ["TF_NUM_INTRAOP_THREADS"] = str(num_threads)
os.environ["TF_NUM_INTEROP_THREADS"] = str(num_threads)

start_time = time.time()
snr = str(sys.argv[1])

vb = 2
samples = 3
signals = 64
fiber_length = 100
num_classes = 4
batch_size = 32
epochs = 20

print('SNR = ',snr)
print('Signals = ',signals)
print('Samples = ', samples)
print('Fiber Length = ', fiber_length)

SNRs = str(snr).zfill(2)

start_dir = '/home/v16b915/TF_data/'
#start_dir += str(fiber_length).zfill(2)
start_dir += str(samples).zfill(2) + '_samples/'
start_dir += str(signals).zfill(2) + '_signals/'

# Load the data
matname = start_dir + 'testDataSnr' + SNRs + '.mat'
print(matname)
mat = spio.loadmat(matname, squeeze_me=False)
x_train = mat['trainIn']
y_train = mat['trainTarget']
x_test = mat['testIn']
y_test = mat['testTarget']
x_val = mat['valIn']
y_val = mat['valTarget']

# Convert the data to floats between 0 and 1 and transpose matrix
x_train = x_train.astype('float32')
y_train = y_train.astype('float32')
x_test = x_test.astype('float32')
y_test = y_test.astype('float32')
x_val = x_val.astype('float32')
y_val = y_val.astype('float32')
x_train = np.transpose(x_train)
y_train = np.transpose(y_train)
x_test = np.transpose(x_test)
y_test = np.transpose(y_test)
x_val = np.transpose(x_val)
y_val = np.transpose(y_val)


print(x_train.shape, 'train samples')
print(y_train.shape, 'train labels')
print(x_test.shape, 'test samples')
print(y_test.shape, 'test labels')


# Formatting
fmtLen = int(math.ceil(math.log(max(batch_size, y_train.shape[0]),10)))


# Define the network
model = Sequential()
model.add(Dense(100, activation='sigmoid', input_dim=(samples)))
model.add(Dense(num_classes, activation='sigmoid'))


model.summary()

model.compile(loss=keras.losses.CategoricalCrossentropy(),
              optimizer=keras.optimizers.Adam(),
              metrics=['accuracy'])

es = keras.callbacks.EarlyStopping(monitor='val_accuracy', mode='max', verbose=1)

history = model.fit(x_train, y_train,
                    validation_data = (x_val, y_val),
                    batch_size=batch_size,
                    shuffle=True,
                    epochs=epochs,
                    verbose=vb,
                    callbacks=[es])

score = model.evaluate(x_train, y_train, verbose=vb)
print('Final Training loss:', score[0])
print('Final Training acc:', score[1])

score = model.evaluate(x_test, y_test, verbose=vb)
print('Test loss:', score[0])
print('Test acc:', score[1])

predictions = model.predict(x_test)
matname = "predictionsSNR" + SNRs + ".mat"
spio.savemat(matname, {'pred': predictions})
savename = "class_model_SNR" + SNRs 
model.save(savename)

print("--- %.2f seconds ---" % (time.time() - start_time))
