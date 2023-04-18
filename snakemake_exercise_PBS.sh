#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name 
#PBS -N matbor_snakemake
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e snakemake.err
#PBS -o snakemake.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=10,walltime=01:00:00,mem=50gb

# Load all required modules for the job
module load tools
module load java/1.8.0 
module load anaconda3/2022.10
module load snakemake/7.8.2
module load perl/5.30.2
module load fastqc/0.11.9
module load bbmap/38.90
module load kma/1.2.5

# Make sure you have the most updated version of the CGE core python package (once you have loaded anaconda):
pip install --upgrade cgecore

# Run snakemake
cd /home/projects/course_23262/people/matbor/snakemake
snakemake -np
snakemake --jobs 1