#!/bin/bash
# Created: October 14, 2022
# Author: Bo Maxwell Stevens, USDA-ARS
# usage: sbatch <script_name>

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --account=akron
#SBATCH --job-name=NxW-emu
#SBATCH --output=output/sbatch_output_%j.txt
#SBATCH --mail-user=bo.stevens@usda.gov
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --priority=short
#SBATCH --partition
#SBATCH --output=output/Array_test.%A_%a.out
#SBATCH --array=01-96

#############################################################
module load miniconda
source activate /project/akron/databases/emu 
# Classify sequences
#############################################################
fastq_dir="../fastq/fastq_demultiplexed/"
mkdir $fastq_dir
emu_dir='../fastq/emu_16s_paralell'

mkdir $emu_dir
export EMU_DATABASE_DIR='/project/akron/databases/emu_default_16s/'

X=$SLURM_ARRAY_TASK_ID
printf -v j "%02d" $X


sample='barcode'$j
echo "Starting $sample..."
echo "Classifying $sample with emu..."
emu abundance \
    $fastq_dir/$sample.final.fasta \
    --threads 6 \
    --N 50 \
    --keep-files \
    --output-dir $emu_dir \
    --keep-counts

#############################################################
# <end of file>
