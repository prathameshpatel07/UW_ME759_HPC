#!/usr/bin/env bash

#SBATCH -J hwr91

#SBATCH -p wacc
#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err
#SBATCH --nodes=1 --cpus-per-task=20

cd $SLURM_SUBMIT_DIR
g++ task1.cpp cluster.cpp -Wall -O3 -o task1 -fopenmp
##./task1 50400 1

for i in {1..10}
do
## N=$((2**$i))
 ./task1 50400 $i
done
