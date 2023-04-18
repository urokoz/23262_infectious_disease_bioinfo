#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N matbor_covid_kma
### Output fileassemblyomment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/people/matbor/logs_and_errs/matbor_covid_kma.err
#PBS -o /home/projects/course_23262/people/matbor/logs_and_errs/matbor_covid_kma.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=160gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 3 hours)
#PBS -l walltime=3:00:00

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load tools
module load kma/1.4.7

HOMEDIR=/home/projects/course_23262/people/matbor
WORKDIR=${HOMEDIR}/week7_covid
DATADIR=${WORKDIR}/data

REF_file=${DATADIR}/Wuhan-hu-1.fasta
REF_index=${DATADIR}/Wuhan-hu-1.index

infile1=${DATADIR}/DK_ALAB-SSI-105_2020.fastq.gz
infile2=${DATADIR}/DK_ALAB-SSI-273_2020.fastq.gz

outfile1=${DATADIR}/DK_ALAB-SSI-105_2020
outfile2=${DATADIR}/DK_ALAB-SSI-273_2020

kma index -i ${REF_file} -o ${REF_index}

kma -i ${infile1} -o ${outfile1} -t_db ${REF_index} -vcf -ont -1t1
kma -i ${infile2} -o ${outfile2} -t_db ${REF_index} -vcf -ont -1t1
