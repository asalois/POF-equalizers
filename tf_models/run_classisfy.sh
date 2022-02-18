#!/bin/bash
for i in {5..35}
do 
	python deep_nnEq_test.py $i 2 > snr_$i.txt
done
