#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name 
#PBS -N matbor_bwa
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e bwa.err
#PBS -o bwa.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=10,walltime=01:00:00,mem=50gb

module load tools
module load bwa-mem2/2.2.1

HOME_DIR=/home/projects/course_23262/people/matbor

REF_file=${HOME_DIR}/data/reference.fa

RAW_dir=/home/projects/course_23262/data/snp_outbreak_exercise/raw_data

bwa-mem2 index $REF_file

for i in 1 2 3 4 5 6
do
    strain_R1=${RAW_dir}/strain_${i}_R1.fq.gz
    strain_R2=${RAW_dir}/strain_${i}_R2.fq.gz
    outfile=${HOME_DIR}/data/strain_${i}.sam
    bwa-mem2 mem -t 10 ${REF_file} ${strain_R1} ${strain_R2} > ${outfile}
done