#!/bin/bash
#SBATCH -J get_ber # Name for your job
#SBATCH -n 2 # Number of tasks when using MPI. 
#SBATCH -N 1 # Number of nodes to spread cores across - default is 1 
#SBATCH --mem 6144 # Megabytes of memory requested. 
#SBATCH -t 720 # Runtime in minutes
#SBATCH -p defq # Partition to submit to 
#SBATCH -o get_ber_%A.out.txt # Standard output
#SBATCH -e get_ber_%A.err.txt # Standard error

date
echo "Hello from $(hostname)."
lscpu

#module load matlab/R2020a
module load matlab/R2017a
echo "Run get BER script"
cd $HOME/nn_class/
matlab -nodesktop -nodisplay -nosplash -singleCompThread -r "getBer;exit;"
echo "Ended batch processing at `date`."

