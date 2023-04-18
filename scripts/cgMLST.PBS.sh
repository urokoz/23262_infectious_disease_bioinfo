#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N matbor_cgMLST
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e cgMLST.err
#PBS -o cgMLST.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=1:thinnode
### Memory
#PBS -l mem=60gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 1 hour)
#PBS -l walltime=2:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

###cgMLST###
# See for cgMLST documentation:
# https://bitbucket.org/genomicepidemiology/cgmlstfinder/src/master/
# To get cgMLST database:
# https://bitbucket.org/genomicepidemiology/cgmlstfinder_db/src/master/

# Load all required modules for the job
module load tools
module unload kma/1.2.5
module load kma/1.3.15
module load anaconda3/4.0.0

HOME_DIR=/home/projects/course_23262/people/matbor

REF_file=/home/projects/course_23262/tools/cgmlstfinder/cgmlstfinder_db

# example
# fastq_files=/home/projects/course_23262/course/week06/cgmlst/raw_trimmed_data/example/*.trim.fq.gz
# full dataset
fastq_files=/home/projects/course_23262/course/week06/cgmlst/raw_trimmed_data/*.trim.fq.gz

outdir=${HOME_DIR}/cgMLST

## Run the script with raw data (fastq) (Recommended to run with FASTQ)
# python3 cgMLST.py /path/to/isolate.fq.gz -s ecoli -o /path/to/outdir -db /path/to/cgmlstfinder_db/ -k /usr/local/bin/kma

##example of running cgMLST using Ecoli database (run for one sample)
python3 /home/projects/course_23262/tools/cgmlstfinder/cgMLST.py ${fastq_files} -s ecoli -o ${outdir} -db ${REF_file} -k /services/tools/kma/1.3.15/kma

##example of running cgMLST using Ecoli database (run the whole dataset)
# python3 /home/projects/course_23262/tools/cgmlstfinder/cgMLST.py /home/projects/course_23262/course/week06/cgmlst/raw_trimmed_data/*.trim.fq.gz -s ecoli -o . -db /home/projects/course_23262/tools/cgmlstfinder/cgmlstfinder_db -k /services/tools/kma/1.3.15/kma