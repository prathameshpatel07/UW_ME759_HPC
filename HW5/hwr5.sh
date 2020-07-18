#!/usr/bin/env bash

#SBATCH -J hwr5

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --ntasks=1 --cpus-per-task=1
#SBATCH --gres=gpu:1

cd $SLURM_SUBMIT_DIR
module load cuda
##nvcc task1.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
##./task1 1073741824 1024
nvcc task2.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2
./task2 32768 32

##for i in {2..15}
##do
## N=$((2**$i))
## ./task2 $N 32
##done
