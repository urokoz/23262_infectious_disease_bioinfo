#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N Roary_matbor
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e Roary_matbor.err
#PBS -o Roary_matbor.log
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

#source https://github.com/microgenomics/tutorials/blob/master/pangenome.md

# Load all required modules for the job
# Roary dependencies
module load tools ngs pestat
module load mafft/7.245
module load parallel/20170822
module load prank/140603
module load mcl/14-137
module load cd-hit/4.6.1
module load fasttree/2.1.9
module load roary/3.13.0 

DATADIR=/home/projects/course_23262/people/matbor/prokka/all_gff
WORKDIR=/home/projects/course_23262/people/matbor/roary

# run Roary
# Let's put all the .gff files in the same folder (e.g., ./gff) and run Roary
# You might have to change the .gff filename because prokka might produce the same .gff filename

#example
roary -f ${WORKDIR} -e -p 20 -n -v -z -o clustered_proteins ${DATADIR}/*.gff

## Output

# Roary will get all the coding sequences, convert them into protein, and create pre-clusters. Then, using BLASTP and MCL, Roary will create clusters, and check for paralogs. Finally, Roary will take every isolate and order them by presence/absence of orthologs. The summary output is present in the summary_statistics.txt file. 

# Additionally, Roary produces a gene_presence_absence.csv file that can be opened in any spreadsheet software to manually explore the results. In this file, you will find information such as gene name and gene annotation, and, of course, whether a gene is present in a genome or not.

