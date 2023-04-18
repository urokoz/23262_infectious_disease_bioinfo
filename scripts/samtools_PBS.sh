#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name 
#PBS -N matbor_SNP
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e SNP_calling.err
#PBS -o SNP_calling.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=20,walltime=01:00:00,mem=50gb

module load tools
module load bcftools/1.14
module load samtools/1.14

HOME_DIR=/home/projects/course_23262/people/matbor

DATA_DIR=${HOME_DIR}/data
RESULTS_DIR=${HOME_DIR}/results

threads=20

for i in 1 2 3 4 5 6
do
    samtools fixmate --threads $threads -O bam ${DATA_DIR}/strain_${i}.sam ${DATA_DIR}/strain_${i}.bam
    rm ${DATA_DIR}/strain_${i}.sam

    samtools sort --threads $threads -O bam -o ${DATA_DIR}/strain_${i}.sorted.bam -T /tmp/strain1_matbor ${DATA_DIR}/strain_${i}.bam
    rm ${DATA_DIR}/strain_${i}.bam

    bcftools mpileup --threads $threads -O b -o ${DATA_DIR}/strain_${i}.complete.bcf -f ${DATA_DIR}/reference.fa ${DATA_DIR}/strain_${i}.sorted.bam

    bcftools call -v -m -O v --ploidy 1 -o ${DATA_DIR}/strain_${i}.raw.vcf ${DATA_DIR}/strain_${i}.complete.bcf
    rm ${DATA_DIR}/strain_${i}.complete.bcf

    grep -v INDEL ${DATA_DIR}/strain_${i}.raw.vcf > ${DATA_DIR}/strain_${i}.no_indels.vcf
    bcftools filter -O v -o ${RESULTS_DIR}/strain_${i}.vcf -i 'QUAL>=30 && DP>4' ${DATA_DIR}/strain_${i}.no_indels.vcf
done
# At this point it is also safe to remove the sorted BAM files
rm ${DATA_DIR}/*.sorted.bam