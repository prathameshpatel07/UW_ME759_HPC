#!/usr/bin/env bash

#SBATCH -J hwr6_task1

#SBATCH -o %x.out -e %x.err
###SBATCH --ntasks=1 --cpus-per-task=1
#SBATCH -p ppc --gres=gpu:v100:1 -t 0-00:20:00
cd $SLURM_SUBMIT_DIR
module purge
module load cuda/10.1 clang/7.0.0
nvcc task1.cu mmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -lcublas -ccbin $CC -o task1
##./task1 1024 3

for i in {5..15}
do
 N=$((2**$i))
 ./task1 $N 5
done
