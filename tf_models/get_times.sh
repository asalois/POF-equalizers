#!/bin/bash
# get all the epochs time and do some stats on it
(echo "time" &&  grep -i -- "---" nnEq*.out.txt | rev | cut -c 13- | cut -c -9 | rev)> full.csv
(echo "time" &&  grep -i "127500/127500" nnEq*.out.txt| cut -d "-" -f2 | rev | cut -c 3- | rev) > epochs.csv
