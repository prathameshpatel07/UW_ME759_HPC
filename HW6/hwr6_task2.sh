#!/usr/bin/env bash

#SBATCH -J hwr6_task2

#SBATCH -p wacc
#SBATCH -t 0-00:30:00
#SBATCH -o %x.out -e %x.err
#SBATCH --ntasks=1 --cpus-per-task=1
#SBATCH --gres=gpu:1

cd $SLURM_SUBMIT_DIR
module load cuda
##nvcc task1.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
##./task1 1073741824 1024
nvcc task2.cu scan.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2
##./task2 1093

for i in {10..20}
do
 N=$((2**$i))
 ./task2 $N
done
