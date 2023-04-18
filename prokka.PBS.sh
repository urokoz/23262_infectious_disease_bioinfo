#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N Prokka_matbor
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e Prokka_matbor.err
#PBS -o Prokka_matbor.log
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
module load tools ngs pestat
module load hmmer/3.1b2 aragorn/1.2.36 barrnap/0.7 signalp/4.1c infernal/1.1.1
module load tbl2asn/20170106 jre/1.8.0-openjdk minced/0.2.0
module load perl
module load prokka/1.12

DATADIR=/home/projects/course_23262/groups/group_8/raw_data
WORKDIR=/home/projects/course_23262/people/matbor/prokka

# Make sure you annotate the six genomes by replacing the -outdir and -locustag and fasta file accordingly. It should take ~ 4 minutes per genome in a standard laptop computer.
# run Prokka

prokka --kingdom Bacteria --outdir ${WORKDIR}/prokka_GCA_000008285 --genus Listeria --locustag GCA_000008285 ${DATADIR}/GCA_000008285.fna
prokka --kingdom Bacteria --outdir ${WORKDIR}/prokka_GCA_000021185 --genus Listeria --locustag GCA_000021185 ${DATADIR}/GCA_000021185.fna
prokka --kingdom Bacteria --outdir ${WORKDIR}/prokka_GCA_000026705 --genus Listeria --locustag GCA_000026705 ${DATADIR}/GCA_000026705.fna
prokka --kingdom Bacteria --outdir ${WORKDIR}/prokka_GCA_000168635 --genus Listeria --locustag GCA_000168635 ${DATADIR}/GCA_000168635.fna
prokka --kingdom Bacteria --outdir ${WORKDIR}/prokka_GCA_000168815 --genus Listeria --locustag GCA_000168815 ${DATADIR}/GCA_000168815.fna
prokka --kingdom Bacteria --outdir ${WORKDIR}/prokka_GCA_000196035 --genus Listeria --locustag GCA_000196035 ${DATADIR}/GCA_000196035.fna
