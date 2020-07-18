#!/usr/bin/env bash

#SBATCH -J hwr93

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --ntasks-per-node=2

cd $SLURM_SUBMIT_DIR
module load mpi/openmpi
mpicxx task3.cpp -Wall -O3 -o task3
##mpirun -np 2 task3 4
##./task2 1000000 10

for i in {1..25}
do
 N=$((2**$i))
 mpirun -np 2 task3 $N
done
