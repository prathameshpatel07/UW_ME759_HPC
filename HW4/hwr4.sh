#!/usr/bin/env bash

#SBATCH -J hwr4

#SBATCH -p wacc
#SBATCH -t 0-00:50:00
#SBATCH -o %x.out -e %x.err
#SBATCH --ntasks=1 --cpus-per-task=1
#SBATCH --gres=gpu:1

cd $SLURM_SUBMIT_DIR
module load cuda
nvcc task1.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
#./task1 32768 512
##nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2
##./task2 1073741824 128 1024
##nvcc task3.cu vadd.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task3

for i in {5..15}
do
  N=$((2**$i))
 ./task1 $N 512
done
