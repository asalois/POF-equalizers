#!/bin/bash
for i in {5..35}
do 
	python classisfy.py $i 2 > snr_$i.txt
done
./run_getBer.sh
