#!/usr/bin/env bash

#SBATCH -J hwr82_op

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --nodes=1 --cpus-per-task=20

cd $SLURM_SUBMIT_DIR
##nvcc task1.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
##./task1 1073741824 1024
##export OMP_PLACES=cores
##export OMP_PROC_BIND=close
g++ task2_op.cpp convolution.cpp -Wall -O3 -o task2_op -fopenmp
##./task2 1024 4

for i in {1..20}
do
## N=$((2**$i))
 ./task2_op 1024 $i
done
