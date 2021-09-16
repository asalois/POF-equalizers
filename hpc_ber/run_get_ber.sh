#!/bin/bash
# script to organize the output and make new dir
#matlab -nodesktop -nodisplay -nosplash -singleCompThread -r "addpath('/home/alexandersalois/Documents/POF-equalizers');get_ber;exit;"
#matlab -nodesktop -nodisplay -nosplash -r "make_ber_eqs;exit;"
matlab -nodesktop -nodisplay -nosplash -r "scan_lms(100);exit;"
