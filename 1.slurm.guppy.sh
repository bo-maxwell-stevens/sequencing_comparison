#!/bin/bash

#SBATCH --time=10:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 8 processor core(s) per node X 2 threads per core
#SBATCH --mem=22G   # maximum memory per node
#SBATCH --partition=scavenger-gpu   # standard node(s)
#SBATCH --job-name="guppy-NxWater"
#SBATCH --mail-user=bo.stevens@usda.gov   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="error-output/slurm-NxWater.out"

module load guppy-gpu/6.0.6
salloc -N1 -n16 -pgpu-low

bash 1.minION.Analysis.guppy.sh
