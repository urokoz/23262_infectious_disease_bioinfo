#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name 
#PBS -N matbor_tree
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e tree_builder.err
#PBS -o tree_builder.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=20,walltime=01:00:00,mem=50gb

module load tools
module load perl
module load fasttree/2.1.11

HOME_DIR=/home/projects/course_23262/people/matbor

DATA_DIR=${HOME_DIR}/data
RESULTS_DIR=${HOME_DIR}/results

perl /home/projects/course_23262/apps/snp_scripts/snp_vcf2fasta.pl -o ${RESULTS_DIR}/snp ${RESULTS_DIR}/*.vcf

FastTree -nt -gtr < ${RESULTS_DIR}/snp.aln.fa > ${RESULTS_DIR}/snp_tree.newick

perl /home/projects/course_23262/apps/snp_scripts/Ks_snp_matrix.pl -i ${RESULTS_DIR}/snp.aln.fa -o ${RESULTS_DIR}/tree