#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N matbor_polish_kma
### Output fileassemblyomment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/people/matbor/logs_and_errs/matbor_polish_kma.err
#PBS -o /home/projects/course_23262/people/matbor/logs_and_errs/matbor_polish_kma.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=160gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 3 hours)
#PBS -l walltime=3:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
#PBS_O_WORKDIR=`pwd`
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load tools
module load kma/20220930

HOMEDIR=/home/projects/course_23262/people/matbor
WORKDIR=${HOMEDIR}/week2

ONT_fq=/home/projects/course_23262/data/w2/Ec01.fq.gz

kma index -i ${WORKDIR}/OUT.fsa -o ${WORKDIR}/OUT.index
kma -i ${ONT_fq} -o ${WORKDIR}/OUT.polish1 -t_db ${WORKDIR}/OUT.index -mem_mode -1t1 -ca -mq 1 -bcNano -bc 0.7