#!/usr/bin/env bash

#SBATCH -J hwr101

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH -N 1 -c 1

cd $SLURM_SUBMIT_DIR
g++ task1.cpp optimize.cpp -Wall -O3 -o task1 -fno-tree-vectorize
./task1 1000000

##for i in {1..10}
##do
## N=$((2**$i))
## ./task1 50400 $i
##done
