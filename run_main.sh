#!/bin/bash
# script to organize the output and make new dir
#matlab -nodesktop -nodisplay -nosplash -r "makeSNRvBER;exit;"
matlab -nodesktop -nodisplay -nosplash -r "makeLimitSim;exit;"
cp ber_limit.mat  ~/DataDrive/Research-OneDrive/ 
