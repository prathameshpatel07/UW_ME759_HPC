#!/usr/bin/env bash

#SBATCH -p wacc

#SBATCH -J hw02

#SBATCH -t 0-00:10:00
#SBATCH -o %x.out -e %x.err

#SBATCH -c 2

cd $SLURM_SUBMIT_DIR
./task3
