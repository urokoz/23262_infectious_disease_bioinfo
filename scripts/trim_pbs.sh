#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N rkmo_trim
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e rkmo_trim.err
#PBS -o rkmo_trim.log
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
module load java/1.8.0
module load bbmap/38.90
module load perl
module load fastqc/0.11.9

HOMEDIR=/home/projects/course_23262/people/matbor

RAWDIR=${HOMEDIR}/raw
TRIMDIR=${HOMEDIR}/trim
mkdir -p ${TRIMDIR}

# Run Trimming command
bbduk.sh qin=auto k=19 ktrim='r' ref=/home/projects/course_23262/data/adapters.fa mink=11 qtrim=r trimq=20 minlength=50 tbo tpe ziplevel=6 overwrite=t in=${RAWDIR}/SRR12207194_1.fq.gz in2=${RAWDIR}/SRR12207194_2.fq.gz out=${TRIMDIR}/SRR12207194_1.trim.fq.gz out2=${TRIMDIR}/SRR12207194_2.trim.fq.gz outm=${TRIMDIR}/SRR12207194.discarded.fq.gz statscolumns=5 stats=SRR12207194.trimk_stats.txt -Xmx40g

# Run FastQC command
fastqc --outdir ${TRIMDIR} --noextract --threads 20 --contaminants /home/projects/course_23262/data/adapters.txt ${TRIMDIR}/SRR12207194_1.trim.fq.gz ${TRIMDIR}/SRR12207194_2.trim.fq.gz