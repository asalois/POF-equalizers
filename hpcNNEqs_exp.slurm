#!/bin/bash
#SBATCH -J nnEq # Name for your job
#SBATCH -n 16 # Number of tasks when using MPI. Default is 1, and SLURM assumes the usage of 1 cpu per task.
#SBATCH -N 1 # Number of nodes to spread cores across - default is 1 - if you are not using MPI this should likely be 1
#SBATCH --mem 2000 # Megabytes of memory requested. Default is 2000/task.
#SBATCH -t 0-0:30:00 # Runtime in days-hours:minutes:seconds.
#SBATCH -p express # Partition to submit to the standard compute node partition(defq) or the express node partition(express)
#SBATCH --mail-user alexander.salois@student.montana.edu # this is the email you wish to be notified.
#SBATCH --mail-type FAIL,END # this specifies what events you should get an email about ALL will alert you of job beginning, completion, failure, etc.
#SBATCH -o nnEq_exp_%A_%a.out.txt # Standard output
#SBATCH -e nnEq_exp_%A_%a.err.txt # Standard error

date
echo "Hello from $(hostname)."
echo "${SLURM_ARRAY_TASK_ID}"
lscpu

module load Anaconda3
source activate $HOME/condatf2
export HDF5_USE_FILE_LOCKING='FALSE' 
echo "Run a Python script"
python3 /mnt/lustrefs/scratch/v16b915/pof_nns/deep_nnEq_test_hpc.py ${SLURM_ARRAY_TASK_ID}
#python3 /mnt/lustrefs/scratch/v16b915/pof_nns/deep_nnEq_cv_hpc.py ${SLURM_ARRAY_TASK_ID}
echo "Ended batch processing at `date`."
