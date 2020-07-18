#!/usr/bin/env bash

#SBATCH -J hwr92

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --nodes=1 --cpus-per-task=20

cd $SLURM_SUBMIT_DIR
module load gcc/9.2.0
g++ task2.cpp montecarlo.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec
##./task2 1000000 10

for i in {1..10}
do
## N=$((2**$i))
 ./task2 1000000 $i
done
