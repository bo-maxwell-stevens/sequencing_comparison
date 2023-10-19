#!/bin/bash

##SBATCH --time=10:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 8 processor core(s) per node X 2 threads per core
#SBATCH --mem=22G   # maximum memory per node
#SBATCH --partition=short   # standard node(s)
#SBATCH --job-name="NxW-quality"
#SBATCH --mail-user=bo.stevens@usda.gov   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="error-output/slurm-NxWater-quality.out"

module load vsearch/2.13.3 
module load cutadapt/3.2

bash 2.minION.Analysis.quality.sh
