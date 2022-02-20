#!/bin/bash
# script to organize the output and make new dir
matlab -nodesktop -nodisplay -nosplash -r "getBer;exit;"
cp *.png /home/alexandersalois/DataDrive/Research-OneDrive/
cp berTF.mat /home/alexandersalois/DataDrive/Research-OneDrive/
