#!/bin/bash
# script to organize the output and make new dir
scp v16b915@hyalite.msu.montana.edu:/home/alexander.salois/full_symbol_Deepnn/pred*.mat . 
#scp v16b915@hyalite.msu.montana.edu:/home/alexander.salois/deep_nn_class/pred*.mat . 
#scp v16b915@hyalite.msu.montana.edu:/home/alexander.salois/nn_class/pred*.mat . 
matlab -nodesktop -nodisplay -nosplash -r "getBer;exit;"
cp *.png /home/alexandersalois/DataDrive/Research-OneDrive/
cp ber*.mat /home/alexandersalois/DataDrive/Research-OneDrive/
