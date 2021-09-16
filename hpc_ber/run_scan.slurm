#!/bin/bash
#SBATCH -J get_ber_eqs # Name for your job
#SBATCH -n 1 # Number of tasks when using MPI. 
#SBATCH -N 1 # Number of nodes to spread cores across - default is 1 
#SBATCH --array=1-990 
#SBATCH --mem 6144 # Megabytes of memory requested. 
#SBATCH -t 120 # Runtime in minutes
#SBATCH -p defq # Partition to submit to 
#SBATCH -o get_ber_eqs_%A.out.txt # Standard output
#SBATCH -e get_ber_eqs_%A.err.txt # Standard error

date
echo "Hello from $(hostname)."
lscpu

module load matlab/R2020a
echo "Run get BER script"
matlab -nodesktop -nodisplay -nosplash -singleCompThread -r "scan_lms(${SLURM_ARRAY_TASK_ID}) ;exit;"
echo "Ended batch processing at `date`.
