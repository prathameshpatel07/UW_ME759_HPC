#!/usr/bin/env bash

#SBATCH -J hwr102

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --nodes=2 --cpus-per-task=20 --ntasks-per-node=1

cd $SLURM_SUBMIT_DIR
module load mpi/openmpi
module load gcc/9.2.0
mpicxx task2.cpp reduce.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec
mpirun -np 2 --bind-to none ./task2 16 2
##./task2 1000000 10

##for i in {1..25}
##do
## N=$((2**$i))
## mpirun -np 2 task3 $N
##done
