#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N matbor_assembly
### Output fileassemblyomment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/people/matbor/logs_and_errs/matbor_assembly.err
#PBS -o /home/projects/course_23262/people/matbor/logs_and_errs/matbor_assembly.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=20
### Memory
#PBS -l mem=40gb
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
module load anaconda3/2022.10
module load spades/3.15.5

HOMEDIR=/home/projects/course_23262/people/matbor

TRIMDIR=${HOMEDIR}/trim
trim1=${TRIMDIR}/SRR12207194_1.trim.fq.gz
trim2=${TRIMDIR}/SRR12207194_2.trim.fq.gz

ASSEMBLY_DIR=${HOMEDIR}/assembly 
mkdir -p ${ASSEMBLY_DIR}

QC_DIR=${HOMEDIR}/qc
mkdir -p ${QC_DIR}

spades.py -k 21,33,55,77,99,127 --careful --cov-cutoff 2.0 -t 20 -m 40 -o ${ASSEMBLY_DIR} -1 ${trim1} -2 ${trim2}

python /services/tools/anaconda3/2022.10/bin/quast.py --threads 20 -o ${QC_DIR} ${ASSEMBLY_DIR}/contigs.fasta