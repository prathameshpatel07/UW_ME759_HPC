#!/usr/bin/env bash

#SBATCH -J hwr3

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --ntasks=1 --cpus-per-task=1
#SBATCH --gres=gpu:1

cd $SLURM_SUBMIT_DIR
module load cuda
nvcc task2.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2
./task2
##nvcc task3.cu vadd.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task3

##for i in {10..29}
##do
##  N=$((2**$i))
## ./task3 $N
##done
