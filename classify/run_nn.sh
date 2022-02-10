#!/bin/bash
# script to organize the output and make new dir
matlab -nodesktop -nodisplay -nosplash -r "nn;exit;"
cp ber*.mat /home/alexandersalois/DataDrive/Research-OneDrive/ 
