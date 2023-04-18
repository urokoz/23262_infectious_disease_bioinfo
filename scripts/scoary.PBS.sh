#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N Scoary_matbor
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e Scoary_matbor.err
#PBS -o Scoary_matbor.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=20:thinnode
### Memory
#PBS -l mem=90gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 1 hour)
#PBS -l walltime=3:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load tools ngs
module load anaconda3/2022.10

WORKDIR=/home/projects/course_23262/people/matbor/roary
SCOARYDIR=/home/projects/course_23262/people/matbor/scoary

scoary -t /home/projects/course_23262/course/week08/scoary/Tetracycline_resistance.csv -g /home/projects/course_23262/course/week08/scoary/Gene_presence_absence.csv -u -c I EPW -o ${SCOARYDIR} --threads 20