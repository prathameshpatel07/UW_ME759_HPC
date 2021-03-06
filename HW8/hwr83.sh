#!/usr/bin/env bash

#SBATCH -J hwr83

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --nodes=1 --cpus-per-task=20

cd $SLURM_SUBMIT_DIR
##nvcc task1.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
##./task1 1073741824 1024
g++ task3.cpp msort.cpp -Wall -O3 -o task3 -fopenmp
##./task3 1000000 8 4

for i in {1..20}
do
## N=$((2**$i))
 ./task3 1000000 $i 64
done
