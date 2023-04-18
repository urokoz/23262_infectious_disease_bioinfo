#!/bin/bash


while read sample; do
  qsub -F \"${sample}\" -e /home/projects/course_23262/groups/group_8/logs_and_errs/assembly_${sample}.err -o /home/projects/course_23262/groups/group_8/logs_and_errs/assembly_${sample}.log scripts/assembly.PBS.sh
  echo ${sample}
  sleep 1
done < samples.txt
