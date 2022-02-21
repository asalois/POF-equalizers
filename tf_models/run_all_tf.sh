#!/bin/bash
# pushes all tf jobs to queue
sbatch --array=5-35 hpcNNClass.slurm
~/show_me_jobs.sh
